pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { IAreaControlLobby } from "../src/codegen/world/IAreaControlLobby.sol";

import { KOTH_NAMESPACE } from "../src/systems/constants.sol";
import { AreaControlLobby } from "../src/systems/area_control/AreaControlLobby.sol";

import { Utils as KothUtils } from "../src/systems/area_control/Utils.sol";

contract GetGameSettings is Script {
    using KothUtils for bytes14;

    function run(address worldAddress) external {
        IWorld world = IWorld(worldAddress);

        uint256 privatePk = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privatePk);
        vm.startBroadcast(owner);

        console.log("world address:", worldAddress);
        console.log("Owner:", owner);

        // get ssu_id on env file
        uint256 _smartObjectId = vm.envUint("SSU_ID");
        console.log("ssu id", _smartObjectId);

        (
            uint256 duration,
            uint256 startTime,
            bool isActive,
            bool claimed,
            uint256 resetTime,
            uint256 expectedItemQuantity,
            uint256 playerCount
        ) = abi.decode(
                world.call(
                    KOTH_NAMESPACE.lobbySystemId(),
                    abi.encodeCall(
                        AreaControlLobby.getGameSettings,
                        (_smartObjectId)
                    )
                ),
                (uint256, uint256, bool, bool, uint256, uint256, uint256)
            );

        console.log("duration", duration);
        console.log("startTime", startTime);
        console.log("resetTime", resetTime);
        console.log("isActive", isActive);
        console.log("claimed", claimed);
        console.log("expectedItemQuantity", expectedItemQuantity);
        console.log("playerCount", playerCount);

        vm.stopBroadcast();
    }
}
