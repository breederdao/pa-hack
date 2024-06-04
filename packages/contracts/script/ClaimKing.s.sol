pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

contract ClaimKing is Script {
    function run(address worldAddress) external {
        uint256 playerKey = vm.envUint("PLAYER_KEY");
        address player = vm.addr(playerKey);
        vm.startBroadcast(playerKey);

        console.log("world address:", worldAddress);
        console.log("ssuOwner:", player);

        // get ssu_id on env file
        uint256 smartStorageUnitId = vm.envUint("SSU_ID");
        console.log("smartStorageUnitId", smartStorageUnitId);

        // IKingOfTheHill(worldAddress).lala__claimKing(smartStorageUnitId);

        vm.stopBroadcast();
    }
}
