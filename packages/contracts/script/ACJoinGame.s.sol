pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IAreaControlLobby } from "../src/codegen/world/IAreaControlLobby.sol";

contract ACJoinGame is Script {
    function run(address worldAddress) external {
        uint256 playerKey = vm.envUint("PLAYER_KEY");
        address player = vm.addr(playerKey);
        vm.startBroadcast(playerKey);

        console.log("world address:", worldAddress);
        console.log("player:", player);

        // get ssu_id on env file
        uint256 _smartObjectId = vm.envUint("SSU_ID");
        uint256 _team = vm.envUint("SELECTED_TEAM");
        console.log("smartStorageUnitId", _smartObjectId);
        console.log("team selected: ", _team);

        IAreaControlLobby(worldAddress).payBdPaMark1__acJoinGame(
            _smartObjectId, // SSU ID
            _team
        );

        vm.stopBroadcast();
    }
}
