// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IBaseWorld } from "@latticexyz/world-modules/src/interfaces/IBaseWorld.sol";
import { WorldRegistrationSystem } from "@latticexyz/world/src/modules/init/implementations/WorldRegistrationSystem.sol";

import { WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

// register tables
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";
// deploying system
import { KingOfTheHill } from "../src/systems/koth/KingOfTheHill.sol";

contract DeployKingOfTheHill is Script {
    function run(address worldAddress) external {
        StoreSwitch.setStoreAddress(worldAddress);

        console.log("world address", worldAddress);

        uint256 ownerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(ownerPrivateKey);
        console.log("owner deployer", owner);

        WorldRegistrationSystem world = WorldRegistrationSystem(worldAddress);
        console.log("world xyz", world._world());

        ResourceId namespaceResource = WorldResourceIdLib.encodeNamespace(
            bytes14("bdArena")
        );
        ResourceId systemResource = WorldResourceIdLib.encode(
            RESOURCE_SYSTEM,
            "bdArena",
            "KingOfTheHill"
        );

        vm.startBroadcast(ownerPrivateKey);
        world.registerNamespace(namespaceResource);

        // register tables
        KingOfTheHillConfig.register();
        KingOfTheHillStatus.register();

        // deploy system
        KingOfTheHill kothSystem = new KingOfTheHill();
        console.log("KingOfTheHill system address", address(kothSystem));

        // register kill of the hill system
        world.registerSystem(systemResource, kothSystem, true);
        // register function selectors
        world.registerFunctionSelector(
            systemResource,
            "setKingOfTheHillConfig(uint256,uint256,uint256,uint256)"
        );
        world.registerFunctionSelector(systemResource, "claimKing(uint256)");
        world.registerFunctionSelector(systemResource, "claimPrize(uint256)");

        vm.stopBroadcast();
    }
}
