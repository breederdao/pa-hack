pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

contract ResetGame is Script {
    function run(address worldAddress) external {
        uint256 ssuOwnerPK = vm.envUint("PRIVATE_KEY");
        address ssuOwner = vm.addr(ssuOwnerPK);
        vm.startBroadcast(ssuOwnerPK);

        console.log("world address:", worldAddress);
        console.log("ssuOwner:", ssuOwner);

        // get ssu_id on env file
        uint256 smartStorageUnitId = vm.envUint("SSU_ID");
        console.log("smartStorageUnitId", smartStorageUnitId);

        // IKingOfTheHill(worldAddress).abcde__resetGame(smartStorageUnitId, 2);

        vm.stopBroadcast();
    }
}
