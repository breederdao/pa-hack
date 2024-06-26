pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

import { IAreaControlLobby } from "../src/codegen/world/IAreaControlLobby.sol";

contract StartGame is Script {
    function run(address worldAddress) external {
        uint256 playerPk = vm.envUint("PLAYER_KEY");
        address player = vm.addr(playerPk);
        vm.startBroadcast(playerPk);

        console.log("world address:", worldAddress);
        console.log("Player:", player);

        // get ssu_id on env file
        uint256 _smartObjectId = vm.envUint("SSU_ID");
        console.log("smartStorageUnitId", _smartObjectId);

        // uint256 _duration = 60 * 60 * 24 * 7; // 1 week
        IAreaControlLobby(worldAddress).kothTestV16__acStartGame(
            _smartObjectId // SSU ID
        );

        vm.stopBroadcast();
    }
}
