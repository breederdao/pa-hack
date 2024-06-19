// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ResourceId } from "@latticexyz/world/src/WorldResourceId.sol";
import { ResourceIds } from "@latticexyz/store/src/codegen/tables/ResourceIds.sol";
import { WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { System } from "@latticexyz/world/src/System.sol";

import { IERC721 } from "@eveworld/world/src/modules/eve-erc721-puppet/IERC721.sol";
import { InventoryLib } from "@eveworld/world/src/modules/inventory/InventoryLib.sol";
import { InventoryItem } from "@eveworld/world/src/modules/inventory/types.sol";
import { IInventoryErrors } from "@eveworld/world/src/modules/inventory/IInventoryErrors.sol";

import { DeployableTokenTable } from "@eveworld/world/src/codegen/tables/DeployableTokenTable.sol";
import { InventoryItemTable } from "@eveworld/world/src/codegen/tables/InventoryItemTable.sol";
import { EphemeralInvTable } from "@eveworld/world/src/codegen/tables/EphemeralInvTable.sol";
import { EphemeralInvItemTable } from "@eveworld/world/src/codegen/tables/EphemeralInvItemTable.sol";
import { EntityRecordTable, EntityRecordTableData } from "@eveworld/world/src/codegen/tables/EntityRecordTable.sol";

import { Utils as EntityRecordUtils } from "@eveworld/world/src/modules/entity-record/Utils.sol";
import { Utils as InventoryUtils } from "@eveworld/world/src/modules/inventory/Utils.sol";
import { Utils as SmartDeployableUtils } from "@eveworld/world/src/modules/smart-deployable/Utils.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { FRONTIER_WORLD_DEPLOYMENT_NAMESPACE as DEPLOYMENT_NAMESPACE } from "@eveworld/common-constants/src/constants.sol";

import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";

import { ACLobbyConfig, ACLobbyConfigData } from "../../codegen/tables/ACLobbyConfig.sol";
import { ACLobbyStatus, ACLobbyStatusData } from "../../codegen/tables/ACLobbyStatus.sol";

import { IWorld } from "../../codegen/world/IWorld.sol";

import { KOTH_NAMESPACE } from "../constants.sol";
import { Utils as KothUtils } from "./Utils.sol";

import { IAreaControlLobby } from "../../codegen/world/IAreaControlLobby.sol";
import { AreaControlLobby } from "./AreaControlLobby.sol";

// interface IAreaControlLobby {
//     function getGameSettings(
//         uint256 _smartObjectId
//     )
//         external
//         view
//         returns (uint256 duration, uint256 startTime, uint256 resetTime);

//     function isPlayer(
//         uint256 _smartObjectId,
//         address _player
//     ) external view returns (uint256);
// }

contract AreaControlPoint is System {
    using KothUtils for bytes14;
    // IAreaControlLobby public ACLobby;

    // resetTime => team 1/2 => time
    mapping(uint256 => mapping(uint256 => uint256)) private timeControl;

    mapping(uint256 => mapping(uint256 => uint256)) controllingTeam; // ssu => resetTime => team 1/2
    mapping(uint256 => mapping(uint256 => uint256)) lastControlChange; // ssu => resetTime => time of control change

    // todo: access control separate from ssuOwner
    // function setACLobby(address _acLobby) public {
    //     ACLobby = IAreaControlLobby(_acLobby);
    // }

    function claimPoint(
        uint256 _smartObjectId,
        uint256 _lobbySmartObjectId
    ) public {
        IWorld world = IWorld(_world());
        // (uint256 duration, uint256 startTime, uint256 resetTime) = ACLobby
        //     .getGameSettings(_lobbySmartObjectId);

        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _lobbySmartObjectId
        );
        ACLobbyStatusData memory acLobbyStatusData = _getCurrentLobbyStatus(
            _lobbySmartObjectId
        );

        uint256 duration = acLobbyConfigData.duration;
        uint256 startTime = acLobbyStatusData.startTime;
        uint256 resetTime = acLobbyConfigData.lastResetTime;

        // uint256 isPlayer = ACLobby.isPlayer(_lobbySmartObjectId, _msgSender());
        // uint256 isPlayer = IAreaControlLobby(_world()).kothTestV4__isPlayer(
        //     _lobbySmartObjectId,
        //     _msgSender()
        // );
        uint256 isPlayer = abi.decode(
            world.call(
                KOTH_NAMESPACE.lobbySystemId(),
                abi.encodeCall(
                    AreaControlLobby.isPlayer,
                    (_lobbySmartObjectId, _msgSender())
                )
            ),
            (uint256)
        );

        require(isPlayer > 0, "AreaControlPoint.claimPoint: not a player");

        require(
            startTime + duration >= block.timestamp,
            "AreaControlPoint.claimPoint: no ongoing game"
        );

        if (controllingTeam[_smartObjectId][resetTime] > 0) {
            require(
                controllingTeam[_smartObjectId][resetTime] != isPlayer,
                "AreaControlPoint.claimPoint: point already controlled"
            );

            // add to totalTime
            timeControl[resetTime][isPlayer] +=
                block.timestamp -
                lastControlChange[_smartObjectId][resetTime];
        }

        // change control and log time
        controllingTeam[_smartObjectId][resetTime] = isPlayer;
        lastControlChange[_smartObjectId][resetTime] = block.timestamp;
    }

    // returns totalTimeControlled, only accurate if game was ended
    function getTimeControlled(
        uint256 _resetTime
    ) public view returns (uint256 teamATime, uint256 teamBTime) {
        return (timeControl[_resetTime][1], timeControl[_resetTime][2]);
    }

    // returns controlling team 1=A 2=B
    function getControllingTeam(
        uint256 _smartObjectId,
        uint256 _lobbySmartObjectId
    ) public view returns (uint256) {
        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _lobbySmartObjectId
        );
        uint256 resetTime = acLobbyConfigData.lastResetTime;
        // (, , uint256 resetTime) = IAreaControlLobby(_world())
        //     .hack007__getGameSettings(_lobbySmartObjectId);

        return controllingTeam[_smartObjectId][resetTime];
    }

    function _getLobbyConfig(
        uint256 _smartObjectId
    ) internal view returns (ACLobbyConfigData memory) {
        return ACLobbyConfig.get(_smartObjectId);
    }

    function _getCurrentLobbyStatus(
        uint256 _smartObjectId
    ) internal view returns (ACLobbyStatusData memory) {
        return
            ACLobbyStatus.get(
                _smartObjectId,
                _getLobbyConfig(_smartObjectId).lastResetTime
            );
    }
}
