pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IAreaControlLobby } from "../src/codegen/world/IAreaControlLobby.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

contract ReleasePrize is Script {
    function run(address worldAddress) external {
        uint256 playerPk = vm.envUint("PLAYER_KEY");
        address player = vm.addr(playerPk);
        vm.startBroadcast(playerPk);

        console.log("world address:", worldAddress);
        console.log("player:", player);

        // get ssu_id on env file
        uint256 smartStorageUnitId = vm.envUint("SSU_ID");
        console.log("smartStorageUnitId", smartStorageUnitId);

        IAreaControlLobby(worldAddress).kothTestV16__acClaimPrize(
            smartStorageUnitId
        );

        vm.stopBroadcast();
    }
}
