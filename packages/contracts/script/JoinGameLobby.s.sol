pragma solidity >=0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {IWorld} from "../src/codegen/world/IWorld.sol";

import {Base_Script} from "./Base.s.sol";
import {AreaControlLobby} from "../src/systems/area_control/AreaControlLobby.sol";

contract JoinGameLobby is Base_Script {
    function _run(IWorld world) public override broadcastPlayer {
        // Load Team from env file
        uint256 _team = vm.envUint("TEAM");

        world.call(
            lobbySystemId(),
            abi.encodeCall(AreaControlLobby.acJoinGame, (ssuIdLobby, _team))
        );
    }
}
