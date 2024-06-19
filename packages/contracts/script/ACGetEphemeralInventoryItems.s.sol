pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IAreaControlLobby } from "../src/codegen/world/IAreaControlLobby.sol";

contract ACGetEphemeralInventoryItems is Script {
    function run(address worldAddress) external {
        uint256 playerKey = vm.envUint("PRIVATE_KEY");
        address player = vm.addr(playerKey);
        vm.startBroadcast(playerKey);

        console.log("world address:", worldAddress);
        console.log("player:", player);

        // get ssu_id on env file
        uint256 _smartObjectId = vm.envUint("SSU_ID");
        uint256 _itemId = vm.envUint("ITEM_ID");
        console.log("smartStorageUnitId", _smartObjectId);
        console.log("itemId: ", _itemId);

        uint256 quantity = IAreaControlLobby(worldAddress)
            .payBdPaMark1__getItemsOnEphemeralInventory(
                _smartObjectId, // SSU ID
                _itemId // ITEM ID
            );

        console.log("quantity: ", quantity);
        vm.stopBroadcast();
    }
}
