pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

import { IAreaControlLobby } from "../src/codegen/world/IAreaControlLobby.sol";

contract SetupGameLobby is Script {
    function run(address worldAddress) external {
        uint256 ssuOwner = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(ssuOwner);
        vm.startBroadcast(ssuOwner);

        console.log("world address:", worldAddress);
        console.log("ssuOwner:", owner);

        // get ssu_id on env file
        uint256 _smartObjectId = vm.envUint("SSU_ID");
        console.log("smartStorageUnitId", _smartObjectId);

        // uint256 _duration = 60 * 60 * 24 * 7; // 1 week
        uint256 _duration = 60 * 5; // 15 minutes
        uint256 _playerCount = 1;
        uint256 _expectedItemId = vm.envUint("ITEM_ID");
        uint256 _expectedItemQuantity = 1;
        uint256 _expectedControlDepositId = 0;
        // uint256[] memory _areaControlPointIds; // @todo change this to ssu id of control points
        uint256[] memory _areaControlPointIds = new uint256[](3);
        _areaControlPointIds[0] = vm.envUint("ACP_ONE_SSU_ID");
        _areaControlPointIds[1] = vm.envUint("ACP_TWO_SSU_ID");
        _areaControlPointIds[2] = vm.envUint("ACP_THREE_SSU_ID");

        // uint256 _smartObjectId,
        //         uint256 _duration,
        //         uint256 _playerCount,
        //         uint256 _expectedItemId,
        //         uint256 _expectedItemQuantity,
        //         uint256 _expectedControlDepositId,
        //         address _areaControlPoint
        IAreaControlLobby(worldAddress).kothTestV16__setLobbyConfig(
            _smartObjectId, // SSU ID
            _duration, // duration in seconds
            _playerCount,
            _expectedItemId,
            _expectedItemQuantity,
            _expectedControlDepositId, // set to zero
            _areaControlPointIds // address of area point
        );

        vm.stopBroadcast();
    }
}
