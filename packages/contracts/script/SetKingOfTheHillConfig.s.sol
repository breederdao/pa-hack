pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";

import { Base_Script } from "./Base.s.sol";
import { KingOfTheHill } from "../src/systems/koth/KingOfTheHill.sol";

contract SetKingOfTheHillConfig is Base_Script {
    function _run(IWorld world) public override broadcast {
        uint256 _smartObjectId = vm.envUint("SSU_ID");
        uint256 _duration = 3 minutes; // reset 3 minutes duration every claim
        uint256 _expectedItemId = vm.envUint("ITEM_ID");
        uint256 _expectedItemIncrement = 1; // increment by 1 every claim

        world.call(
            kothSystemId(),
            abi.encodeCall(
                KingOfTheHill.setKingOfTheHillConfig,
                (
                    _smartObjectId,
                    _duration,
                    _expectedItemId,
                    _expectedItemIncrement
                )
            )
        );
    }
}
