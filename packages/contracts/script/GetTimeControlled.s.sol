pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { IKingOfTheHill } from "../src/codegen/world/IKingOfTheHill.sol";
import { KingOfTheHillConfig, KingOfTheHillStatus } from "../src/codegen/index.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { IAreaControlLobby } from "../src/codegen/world/IAreaControlLobby.sol";

import { KOTH_NAMESPACE } from "../src/systems/constants.sol";
import { AreaControlPoint } from "../src/systems/area_control/AreaControlPoint.sol";

import { Utils as KothUtils } from "../src/systems/area_control/Utils.sol";

contract GetTimeControlled is Script {
    using KothUtils for bytes14;

    function run(address worldAddress) external {
        IWorld world = IWorld(worldAddress);

        uint256 privatePk = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privatePk);
        vm.startBroadcast(owner);

        console.log("world address:", worldAddress);
        console.log("Owner:", owner);

        // get ssu_id on env file
        uint256 _lobbySmartObjectId = vm.envUint("SSU_ID");
        uint256 _smartObjectId = vm.envUint("ACP_ONE_SSU_ID");
        console.log("smartStorageUnitId", _lobbySmartObjectId);
        console.log("pointId", _smartObjectId);

        (uint256 teamATime, uint256 teamBTime) = abi.decode(
            world.call(
                KOTH_NAMESPACE.pointSystemId(),
                abi.encodeCall(
                    AreaControlPoint.getTimeControlled,
                    (_lobbySmartObjectId, _smartObjectId)
                )
            ),
            (uint256, uint256)
        );

        console.log("teamATime", teamATime);
        console.log("teamBTime", teamBTime);

        vm.stopBroadcast();
    }
}
