pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

contract SetKingOfTheHillConfig is Script {
    function run(address worldAddress) external {
        uint256 ssuOwner = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(ssuOwner);
        vm.startBroadcast(ssuOwner);

        console.log("world address:", worldAddress);
        console.log("ssuOwner:", ssuOwner);

        // get ssu_id on env file
        uint256 smartStorageUnitId = vm.envUint("SSU_ID");
        uint256 itemId = vm.envUint("ITEM_ID");

        console.log("smartStorageUnitId", smartStorageUnitId);
        console.log("itemId", itemId);

        // IKingOfTheHill(worldAddress).bdArena__setKingOfTheHillConfig(
        //     smartStorageUnitId,
        //     block.timestamp + 1 days,
        //     itemId,
        //     5 // increment by 5 every claim
        // );
        IKingOfTheHill(worldAddress).king__setKingOfTheHillConfig(
            smartStorageUnitId,
            3 minutes,
            itemId,
            3
        );

        vm.stopBroadcast();
    }
}
