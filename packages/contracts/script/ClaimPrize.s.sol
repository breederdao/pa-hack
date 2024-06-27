pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";

import { Base_Script } from "./Base.s.sol";
import { KingOfTheHill } from "../src/systems/koth/KingOfTheHill.sol";

contract ClaimPrize is Base_Script {
    function _run(IWorld world) public override broadcastPlayer {
        // get ssu_id on env file
        uint256 smartStorageUnitId = vm.envUint("SSU_ID");

        // world.call(
        //     kothSystemId(),
        //     abi.encodeCall(
        //         KingOfTheHill.claimPrize(uint256),
        //         (smartStorageUnitId)
        //     )
        // );

        bytes memory data = abi.encodeWithSelector(
            bytes4(keccak256("claimPrize(uint256)")),
            smartStorageUnitId
        );
        world.call(kothSystemId(), data);
    }
}
