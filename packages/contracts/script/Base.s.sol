pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

import { Utils } from "../src/systems/area_control/Utils.sol";
import { KOTH_NAMESPACE } from "../src/systems/constants.sol";
import { AreaControlLobby } from "../src/systems/area_control/AreaControlLobby.sol";
import { AreaControlPoint } from "../src/systems/area_control/AreaControlPoint.sol";

abstract contract Base_Script is Script {
    using Utils for bytes14;

    uint256 internal ssuOwnerPk;
    uint256 internal playerPk;
    uint256 internal ssuIdLobby;

    constructor() {
        // Load environment variables
        ssuOwnerPk = vm.envUint("PRIVATE_KEY");
        playerPk = vm.envUint("PLAYER_KEY");
        ssuIdLobby = vm.envUint("SSU_ID");
    }

    modifier broadcast() {
        vm.startBroadcast(ssuOwnerPk);
        _;
        vm.stopBroadcast();
    }

    modifier broadcastPlayer() {
        vm.startBroadcast(playerPk);
        _;
        vm.stopBroadcast();
    }

    function run(address worldAddress) public virtual {
        IWorld world = IWorld(worldAddress);
        _run(world);
    }

    function _run(IWorld world) public virtual;

    function lobbySystemId() internal pure returns (ResourceId) {
        return KOTH_NAMESPACE.lobbySystemId();
    }

    function pointSystemId() internal pure returns (ResourceId) {
        return KOTH_NAMESPACE.pointSystemId();
    }

    function kothSysmteId() internal pure returns (ResourceId) {
        return KOTH_NAMESPACE.kothSystemId();
    }
}
