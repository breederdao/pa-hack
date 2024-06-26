pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

import { IAreaControlPoint } from "../src/codegen/world/IAreaControlPoint.sol";

contract ClaimPoint is Script {
    function run(address worldAddress) external {
        uint256 playerPk = vm.envUint("PLAYER_KEY");
        address player = vm.addr(playerPk);
        vm.startBroadcast(playerPk);

        console.log("world address:", worldAddress);
        console.log("Player:", player);

        // get ssu_ids on env file
        uint256 _apSmartObjectId = vm.envUint("AP_SSU_ID");
        uint256 _lobbySmartObjectId = vm.envUint("SSU_ID");
        console.log("smartStorageUnitId", _apSmartObjectId);
        console.log("smartStorageUnitId", _lobbySmartObjectId);

        // uint256 _duration = 60 * 60 * 24 * 7; // 1 week
        IAreaControlPoint(worldAddress).kothTestV16__claimPoint(
            _apSmartObjectId,
            _lobbySmartObjectId
        );

        vm.stopBroadcast();
    }
}
