pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

import { IAreaControlLobby } from "../src/codegen/world/IAreaControlLobby.sol";

contract AcClaimPrize is Script {
    function run(address worldAddress) external {
        uint256 playerPK = vm.envUint("PLAYER_KEY");
        address player = vm.addr(playerPK);
        vm.startBroadcast(playerPK);

        console.log("world address:", worldAddress);
        console.log("Player Address:", player);

        // Load SSU ID from env file
        uint256 _smartObjectId = vm.envUint("SSU_ID");
        console.log("smartStorageUnitId", _smartObjectId);

        IAreaControlLobby(worldAddress).kothTestV16__acClaimPrize(
            _smartObjectId
        );

        vm.stopBroadcast();
    }
}
