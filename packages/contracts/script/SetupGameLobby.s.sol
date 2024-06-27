pragma solidity >=0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {IWorld} from "../src/codegen/world/IWorld.sol";

import {Base_Script} from "./Base.s.sol";
import {AreaControlLobby} from "../src/systems/area_control/AreaControlLobby.sol";

contract SetupGameLobby is Base_Script {
    function _run(IWorld world) public override broadcast {
        // uint256 _duration = 60 * 60 * 24 * 7; // 1 week duration
        // Sample of 1 minute duration
        uint256 _duration = 60 * 1;
        uint256 _playerCount = 1;
        uint256 _expectedItemId = vm.envUint("ITEM_ID");
        uint256 _expectedItemQuantity = 1;
        uint256 _expectedControlDepositId = 0;
        uint256 _ssuIdLobby = ssuIdLobby;

        // Load Area Control Point ID from env file
        uint256[] memory _areaControlPointIds = new uint256[](1);
        _areaControlPointIds[0] = vm.envUint("AP_SSU_ID");

        world.call(
            lobbySystemId(),
            abi.encodeCall(
                AreaControlLobby.setLobbyConfig,
                (
                    _ssuIdLobby,
                    _duration,
                    _playerCount,
                    _expectedItemId,
                    _expectedItemQuantity,
                    _expectedControlDepositId,
                    _areaControlPointIds
                )
            )
        );
    }
}
