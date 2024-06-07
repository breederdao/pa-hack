// pragma solidity >=0.8.20;

// import { Script } from "forge-std/Script.sol";
// import { console } from "forge-std/console.sol";

// import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
// import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

// import { IAreaControlLobby } from "../src/codegen/world/IAreaControlLobby.sol";

// contract ACSetLobbyConfig is Script {
//     function run(address worldAddress) external {
//         uint256 playerKey = vm.envUint("PLAYER_KEY");
//         address player = vm.addr(playerKey);
//         vm.startBroadcast(playerKey);

//         console.log("world address:", worldAddress);
//         console.log("ssuOwner:", player);

//         // get ssu_id on env file
//         uint256 _smartObjectId = vm.envUint("LOBBY_SSU_ID");
//         console.log("LOBBY_SSU_ID", _smartObjectId);
//         uint256 _team = vm.envUint("TEAM");

//         // uint256 _smartObjectId,
//         //         uint256 _duration,
//         //         uint256 _playerCount,
//         //         uint256 _expectedItemId,
//         //         uint256 _expectedItemQuantity,
//         //         uint256 _expectedControlDepositId,
//         //         address _areaControlPoint
//         // IAreaControlLobby(worldAddress).kothTestV1__acJoinGame(
//         //     _smartObjectId, // SSU ID
//         //     _team
//         // );

//         vm.stopBroadcast();
//     }
// }
