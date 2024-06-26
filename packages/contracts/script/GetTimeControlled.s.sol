pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";

import { Base_Script } from "./Base.s.sol";
import { AreaControlPoint } from "../src/systems/area_control/AreaControlPoint.sol";

contract GetTimeControlled is Base_Script {
    function _run(IWorld world) internal override broadcastPlayer {
        // Load Area Point SSU ID from env file
        uint256 _smartObjectId = vm.envUint("AP_SSU_ID");

        (uint256 teamATime, uint256 teamBTime) = abi.decode(
            world.call(
                pointSystemId(),
                abi.encodeCall(
                    AreaControlPoint.getTimeControlled,
                    (ssuIdLobby, _smartObjectId)
                )
            ),
            (uint256, uint256)
        );

        console.log("teamATime", teamATime);
        console.log("teamBTime", teamBTime);
    }
}
