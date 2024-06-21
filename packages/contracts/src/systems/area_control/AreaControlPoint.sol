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
import { ACControlPointStatus, ACControlPointStatusData } from "../../codegen/tables/ACControlPointStatus.sol";

import { IWorld } from "../../codegen/world/IWorld.sol";

import { KOTH_NAMESPACE } from "../constants.sol";
import { Utils as KothUtils } from "./Utils.sol";

import { IAreaControlLobby } from "../../codegen/world/IAreaControlLobby.sol";
import { AreaControlLobby } from "./AreaControlLobby.sol";

contract AreaControlPoint is System {
    using KothUtils for bytes14;

    // resetTime => team 1/2 => time
    mapping(uint256 => mapping(uint256 => uint256)) private timeControl;

    // todo: access control separate from ssuOwner
    // function setACLobby(address _acLobby) public {
    //     ACLobby = IAreaControlLobby(_acLobby);
    // }

    function claimPoint(
        uint256 _smartObjectId,
        uint256 _lobbySmartObjectId
    ) public {
        IWorld world = IWorld(_world());

        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _lobbySmartObjectId
        );
        ACLobbyStatusData memory acLobbyStatusData = _getCurrentLobbyStatus(
            _lobbySmartObjectId
        );

        uint256 duration = acLobbyConfigData.duration;
        uint256 startTime = acLobbyStatusData.startTime;
        uint256 resetTime = acLobbyConfigData.lastResetTime;

        ACControlPointStatusData memory acControlPointStatus = ACControlPointStatus.get(
            _smartObjectId, 
            resetTime
        );

        // get isPlayer using namespace from world
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

        require(
            isPlayer != ACControlPointStatus.getControllingTeam(_smartObjectId, resetTime),
            "AreaControlPoint.claimPoint: point already controlled"
        );
        
        if (acControlPointStatus.controllingTeam > 0) {  
            // get time difference
            uint256 timeDifference = block.timestamp - acControlPointStatus.lastControlChange;

            // add to totalTime, 
            if(acControlPointStatus.controllingTeam == 1) {
                ACControlPointStatus.setTeamATime(_smartObjectId, resetTime, acControlPointStatus.teamATime + timeDifference);
            } else if(acControlPointStatus.controllingTeam == 2) {
                ACControlPointStatus.setTeamBTime(_smartObjectId, resetTime, acControlPointStatus.teamBTime + timeDifference);
            }
        }

        // change control and log time
        ACControlPointStatus.setControllingTeam(_smartObjectId, resetTime, isPlayer);
        ACControlPointStatus.setLastControlChange(_smartObjectId, resetTime, block.timestamp);
    }

    // returns totalTimeControlled, need to provide lobby and ssu point id
    function getTimeControlled(
        uint256 _lobbySmartObjectId,
        uint256 _smartObjectId
    ) public view returns (uint256 teamATime, uint256 teamBTime) {
        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _lobbySmartObjectId
        );
        ACLobbyStatusData memory acLobbyStatusData = _getCurrentLobbyStatus(
            _lobbySmartObjectId
        );

        uint256 duration = acLobbyConfigData.duration;
        uint256 startTime = acLobbyStatusData.startTime;
        uint256 resetTime = acLobbyConfigData.lastResetTime;

        // check if using roundEnd or current time, if timestamp is greater use roundEnd
        uint256 roundEnd = startTime + duration;
        uint256 referenceTime = block.timestamp;
        if(block.timestamp > roundEnd) {
            referenceTime = roundEnd;
        }

        ACControlPointStatusData memory acControlPointStatus = ACControlPointStatus.get(
            _smartObjectId, 
            resetTime
        );

        teamATime = acControlPointStatus.teamATime;
        teamBTime = acControlPointStatus.teamBTime;

        // if you're controlling team need to compute your current time as its not reflecting in your time, but need to be bound by the round end
        if(acControlPointStatus.controllingTeam == 1) {
            teamATime += (referenceTime - acControlPointStatus.lastControlChange);
        } else if(acControlPointStatus.controllingTeam == 2) {
            teamBTime += (referenceTime - acControlPointStatus.lastControlChange);
        }
    }

    // returns controlling team 1=A 2=B
    function getControllingTeam(
        uint256 _smartObjectId,
        uint256 _lobbySmartObjectId
    ) public view returns (uint256) {
        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _lobbySmartObjectId
        );
        uint256 lastResetTime = acLobbyConfigData.lastResetTime;

        return ACControlPointStatus.getControllingTeam(_smartObjectId, lastResetTime);
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
