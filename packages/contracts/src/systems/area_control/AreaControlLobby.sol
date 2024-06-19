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
import { FRONTIER_WORLD_DEPLOYMENT_NAMESPACE as DEPLOYMENT_NAMESPACE } from "@eveworld/common-constants/src/constants.sol";

import { ACLobbyConfig, ACLobbyConfigData } from "../../codegen/tables/ACLobbyConfig.sol";
import { ACLobbyStatus, ACLobbyStatusData } from "../../codegen/tables/ACLobbyStatus.sol";

import { IAreaControlPoint } from "../../codegen/world/IAreaControlPoint.sol";

// interface IAreaControlPoint {
//     function getTimeControlled(
//         uint256 _resetTime
//     ) external view returns (uint256 teamATime, uint256 teamBTime);
// }

contract AreaControlLobby is System {
    using InventoryLib for InventoryLib.World;
    using EntityRecordUtils for bytes14;
    using InventoryUtils for bytes14;
    using SmartDeployableUtils for bytes14;

    IAreaControlPoint public areaControlPoint;

    // resetTime => address => 1=A, 2=B
    mapping(uint256 => mapping(address => uint256)) public team;
    // resetTime => 1=A, 2=B => address[]
    mapping(uint256 => mapping(uint256 => address[])) public playersInTeam;

    modifier onlySSUOwner(uint256 _smartObjectId) {
        address ssuOwner = IERC721(
            DeployableTokenTable.getErc721Address(
                _namespace().deployableTokenTableId()
            )
        ).ownerOf(_smartObjectId);

        require(
            _msgSender() == ssuOwner,
            "KingOfTheHill.setKingOfTheHillConfig: not owned"
        );

        _;
    }

    function setLobbyConfig(
        uint256 _smartObjectId,
        uint256 _duration,
        uint256 _playerCount,
        uint256 _expectedItemId,
        uint256 _expectedItemQuantity,
        uint256 _expectedControlDepositId,
        address _areaControlPoint
    ) public onlySSUOwner(_smartObjectId) {
        // make sure item exists
        EntityRecordTableData memory entityInRecord = EntityRecordTable.get(
            _namespace().entityRecordTableId(),
            _expectedItemId
        );

        // check if item exist on chain, else revert
        if (entityInRecord.recordExists == false) {
            revert IInventoryErrors.Inventory_InvalidItem(
                "KingOfTheHill: item is not created on-chain",
                _expectedItemId
            );
        }

        // areaControlPoint = IAreaControlPoint(_areaControlPoint);

        _resetGame(_smartObjectId);

        ACLobbyConfig.set(
            _smartObjectId,
            _duration,
            _playerCount,
            _expectedItemId,
            _expectedItemQuantity,
            _expectedControlDepositId,
            0
        );
    }

    function acResetGame(
        uint256 _smartObjectId
    ) public onlySSUOwner(_smartObjectId) {
        _resetGame(_smartObjectId);
    }

    // _team 1=A, 2=B
    function acJoinGame(uint256 _smartObjectId, uint256 _team) public {
        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _smartObjectId
        );
        ACLobbyStatusData memory acLobbyStatusData = _getCurrentLobbyStatus(
            _smartObjectId
        );

        uint256 lastResetTime = acLobbyConfigData.lastResetTime;

        require(
            acLobbyStatusData.startTime + acLobbyConfigData.duration >=
                block.timestamp,
            "AreaControlPoint.claimPoint: game is ongoing"
        );

        require(_team <= 2, "AreaControlLobby.acJoinGame: invalid team");

        require(
            team[lastResetTime][_msgSender()] == 0,
            "AreaControlLobby.acJoinGame: already in team"
        );

        if (_team == 1) {
            require(
                acLobbyStatusData.teamAPlayers < acLobbyConfigData.playerCount,
                "AreaControlLobby.acJoinGame: team is full"
            );
            ACLobbyStatus.setTeamAPlayers(
                _smartObjectId,
                lastResetTime,
                acLobbyStatusData.teamAPlayers + 1
            );
        } else if (_team == 2) {
            require(
                acLobbyStatusData.teamBPlayers < acLobbyConfigData.playerCount,
                "AreaControlLobby.acJoinGame: team is full"
            );
            ACLobbyStatus.setTeamBPlayers(
                _smartObjectId,
                lastResetTime,
                acLobbyStatusData.teamBPlayers + 1
            );
        }

        // setting team
        team[lastResetTime][_msgSender()] = _team;
        // adding to array
        playersInTeam[lastResetTime][_team].push(_msgSender());

        // get item deposit
        uint256 expectedItemId = acLobbyConfigData.expectedItemId;
        EntityRecordTableData memory itemInEntity = EntityRecordTable.get(
            _namespace().entityRecordTableId(),
            expectedItemId
        );
        InventoryItem[] memory inItems = new InventoryItem[](1);
        inItems[0] = InventoryItem(
            expectedItemId,
            _msgSender(),
            itemInEntity.typeId,
            itemInEntity.itemId,
            itemInEntity.volume,
            acLobbyConfigData.expectedItemQuantity
        );
        _inventoryLib().ephemeralToInventoryTransfer(_smartObjectId, inItems);
    }

    function acStartGame(uint256 _smartObjectId) public {
        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _smartObjectId
        );
        ACLobbyStatusData memory acLobbyStatusData = _getCurrentLobbyStatus(
            _smartObjectId
        );

        uint256 lastResetTime = acLobbyConfigData.lastResetTime;

        require(
            team[lastResetTime][_msgSender()] > 0,
            "AreaControlLobby.acStartGame: not part of game"
        );
        require(
            acLobbyStatusData.teamAPlayers == acLobbyConfigData.playerCount &&
                acLobbyStatusData.teamBPlayers == acLobbyConfigData.playerCount,
            "AreaControlLobby.acStartGame: not enough players"
        );
        require(
            acLobbyStatusData.startTime == 0,
            "AreaControlLobby.acStartGame: game already started"
        );

        ACLobbyStatus.setStartTime(
            _smartObjectId,
            lastResetTime,
            block.timestamp
        );
    }

    function acClaimPrize(uint256 _smartObjectId) public {
        ACLobbyStatusData memory acLobbyStatusData = _getCurrentLobbyStatus(
            _smartObjectId
        );
        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _smartObjectId
        );

        uint256 teamStatus = isPlayer(_smartObjectId, _msgSender());

        require(
            acLobbyStatusData.startTime + acLobbyConfigData.duration >=
                block.timestamp,
            "AreaControlPoint.claimPoint: game is ongoing"
        );

        require(
            !acLobbyStatusData.claimed,
            "AreaControlPoint.claimPoint: already claimed"
        );

        // @todo change this
        // (uint256 teamATime, uint256 teamBTime) = areaControlPoint
        //     .getTimeControlled(acLobbyConfigData.lastResetTime);

        (uint256 teamATime, uint256 teamBTime) = IAreaControlPoint(_world())
            .kothTestV1__getTimeControlled(acLobbyConfigData.lastResetTime);
        if (teamATime > teamBTime) {
            require(
                teamStatus == 1,
                "AreaControlPoint.claimPoint: not winning team"
            );
        } else {
            require(
                teamStatus == 2,
                "AreaControlPoint.claimPoint: not winning team"
            );
        }

        // giving item
        uint256 expectedItemId = acLobbyConfigData.expectedItemId;
        uint256 totalItemCount = acLobbyConfigData.expectedItemQuantity *
            acLobbyConfigData.playerCount *
            2; // items * players per team * 2 teams
        EntityRecordTableData memory itemOutEntity = EntityRecordTable.get(
            _namespace().entityRecordTableId(),
            expectedItemId
        );

        InventoryItem[] memory outItems = new InventoryItem[](1);
        outItems[0] = InventoryItem(
            expectedItemId,
            _msgSender(),
            itemOutEntity.typeId,
            itemOutEntity.itemId,
            itemOutEntity.volume,
            totalItemCount
        );
        _inventoryLib().inventoryToEphemeralTransfer(_smartObjectId, outItems);

        ACLobbyStatus.setClaimed(
            _smartObjectId,
            acLobbyConfigData.lastResetTime,
            true
        );
    }

    function getGameSettings(
        uint256 _smartObjectId
    )
        public
        view
        returns (uint256 duration, uint256 startTime, uint256 resetTime)
    {
        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _smartObjectId
        );
        ACLobbyStatusData memory acLobbyStatusData = _getCurrentLobbyStatus(
            _smartObjectId
        );
        return (
            acLobbyConfigData.duration,
            acLobbyStatusData.startTime,
            acLobbyConfigData.lastResetTime
        );
    }

    // returns array of team players
    function getTeamPlayers(
        uint256 _smartObjectId
    )
        public
        view
        returns (address[] memory teamAPlayers, address[] memory teamBPlayers)
    {
        ACLobbyConfigData memory acLobbyConfigData = _getLobbyConfig(
            _smartObjectId
        );

        return (
            playersInTeam[acLobbyConfigData.lastResetTime][1],
            playersInTeam[acLobbyConfigData.lastResetTime][2]
        );
    }

    // returns 1 if A, 2 if B, 0 if non player
    function isPlayer(
        uint256 _smartObjectId,
        address _player
    ) public view returns (uint256) {
        return team[_getLobbyConfig(_smartObjectId).lastResetTime][_player];
    }

    function _resetGame(uint256 _smartObjectId) internal {
        // setting resetTime as game id proxy
        uint256 resetTime = block.timestamp;
        ACLobbyConfig.setLastResetTime(_smartObjectId, resetTime);

        ACLobbyStatus.setClaimed(_smartObjectId, resetTime, false);
        ACLobbyStatus.setStartTime(
            _smartObjectId,
            resetTime,
            resetTime + 5 days // move the time to the next day, this making sure that players can join the game
        );
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

    function _inventoryLib() internal view returns (InventoryLib.World memory) {
        //InventoryLib.World({ iface: IBaseWorld(_world()), namespace: INVENTORY_DEPLOYMENT_NAMESPACE })
        if (
            !ResourceIds.getExists(
                WorldResourceIdLib.encodeNamespace(DEPLOYMENT_NAMESPACE)
            )
        ) {
            return
                InventoryLib.World({
                    iface: IBaseWorld(_world()),
                    namespace: DEPLOYMENT_NAMESPACE
                });
        } else
            return
                InventoryLib.World({
                    iface: IBaseWorld(_world()),
                    namespace: DEPLOYMENT_NAMESPACE
                });
    }

    function _namespace() internal pure returns (bytes14 namespace) {
        return DEPLOYMENT_NAMESPACE;
    }
}
