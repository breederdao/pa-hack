pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";

import { Base_Script } from "./Base.s.sol";
import { AreaControlPoint } from "../src/systems/area_control/AreaControlPoint.sol";

contract ClaimPoint is Base_Script {
    function _run(IWorld world) public override broadcastPlayer {
        // Load area control point to claim from env file
        uint256 _apSmartObjectId = vm.envUint("AP_SSU_ID");
        world.call(
            pointSystemId(),
            abi.encodeCall(
                AreaControlPoint.claimPoint,
                (_apSmartObjectId, ssuIdLobby)
            )
        );
    }
}
