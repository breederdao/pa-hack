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
        uint256 _duration = 60 * 15; // 15 minutes
        uint256 _playerCount = 2;
        uint256 _expectedItemId = vm.envUint("ITEM_ID");
        uint256 _expectedItemQuantity = 1;
        uint256 _expectedControlDepositId = 0;
        address _areaControlPoint = address(0); // @todo change this to AreaControlLobby address

        // uint256 _smartObjectId,
        //         uint256 _duration,
        //         uint256 _playerCount,
        //         uint256 _expectedItemId,
        //         uint256 _expectedItemQuantity,
        //         uint256 _expectedControlDepositId,
        //         address _areaControlPoint
        IAreaControlLobby(worldAddress).kothTestV4__setLobbyConfig(
            _smartObjectId, // SSU ID
            _duration, // duration in seconds
            _playerCount,
            _expectedItemId,
            _expectedItemQuantity,
            _expectedControlDepositId, // set to zero
            _areaControlPoint // address of area point
        );

        vm.stopBroadcast();
    }
}
