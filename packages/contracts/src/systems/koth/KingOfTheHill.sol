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

import { KingOfTheHillConfig, KingOfTheHillConfigData } from "../../codegen/tables/KingOfTheHillConfig.sol";
import { KingOfTheHillStatus, KingOfTheHillStatusData } from "../../codegen/tables/KingOfTheHillStatus.sol";

contract KingOfTheHill is System {
    using InventoryLib for InventoryLib.World;
    using EntityRecordUtils for bytes14;
    using InventoryUtils for bytes14;
    using SmartDeployableUtils for bytes14;

    // add access control
    function setKingOfTheHillConfig(
        uint256 _smartObjectId,
        uint256 _duration,
        uint256 _expectedItemId,
        uint256 _expectedItemIncrement
    ) public {
        address ssuOwner = IERC721(
            DeployableTokenTable.getErc721Address(
                _namespace().deployableTokenTableId()
            )
        ).ownerOf(_smartObjectId);

        require(
            _msgSender() == ssuOwner,
            "KingOfTheHill.setKingOfTheHillConfig: not owned"
        );

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

        // adding limit so people have to deposit after every claim to make sure they're present
        _inventoryLib().setInventoryCapacity(_smartObjectId, 20);

        KingOfTheHillConfig.set(
            _smartObjectId,
            _duration,
            _expectedItemId,
            _expectedItemIncrement,
            0
        );
    }

    function claimKing(uint256 _smartObjectId) public {
        KingOfTheHillConfigData memory kingOfTheHillConfigData = KingOfTheHillConfig.get(_smartObjectId);

        // get lastResetTime for game id purposes
        uint256 lastResetTime = kingOfTheHillConfigData.lastResetTime;

        KingOfTheHillStatusData memory kingOfTheHillStatusData = KingOfTheHillStatus.get(_smartObjectId, lastResetTime);

        // making sure that no one can claim past duration
        uint256 duration = kingOfTheHillConfigData.duration;
        uint256 lastClaimedTime = kingOfTheHillStatusData.lastClaimedTime;
        // Ensure the game is still running
        // require(lastClaimedTime + duration < block.timestamp, "KingOfTheHill.claimKing: game has ended");
        require(
            lastClaimedTime + duration >= block.timestamp,
            "KingOfTheHill.claimKing: game has ended. done"
        );

        // king cannot reclaim
        address king = kingOfTheHillStatusData.king;
        require(_msgSender() != king, "KingOfTheHill.claimKing: already king");

        uint256 startTime;
        if (kingOfTheHillStatusData.startTime == 0) {
            startTime = block.timestamp;
        } else {
            startTime = kingOfTheHillStatusData.startTime;
        }

        // computing item deposit
        uint256 currentItemCount = kingOfTheHillStatusData.totalItemCount;
        uint256 expectedItemIncrement = kingOfTheHillConfigData
            .expectedItemIncrement;
        uint256 updatedItemCount = currentItemCount + expectedItemIncrement;

        // getting item from user
        uint256 expectedItemId = kingOfTheHillConfigData.expectedItemId;
        EntityRecordTableData memory itemInEntity = EntityRecordTable.get(
            _namespace().entityRecordTableId(),
            expectedItemId
        );
        InventoryItem[] memory inItems = new InventoryItem[](1);
        inItems[0] = InventoryItem(
            expectedItemId,
            msg.sender,
            itemInEntity.typeId,
            itemInEntity.itemId,
            itemInEntity.volume,
            expectedItemIncrement
        );
        _inventoryLib().ephemeralToInventoryTransfer(_smartObjectId, inItems);

        // updating status
        KingOfTheHillStatus.set(
            _smartObjectId,
            lastResetTime,
            _msgSender(),
            startTime,
            block.timestamp,
            updatedItemCount,
            false
        );
    }

    // overload for basic claim
    function claimPrize(uint256 _smartObjectId) public {
        claimPrize(_smartObjectId, 0);
    }

    // overload for specific claim
    function claimPrize(uint256 _smartObjectId, uint256 _resetTime) public {
        KingOfTheHillConfigData
            memory kingOfTheHillConfigData = KingOfTheHillConfig.get(
                _smartObjectId
            );

        // 0 if for last round or exact resetTime if for past events
        uint256 resetTime;
        if(_resetTime == 0) {
            resetTime = kingOfTheHillConfigData.lastResetTime;
        } else {
            resetTime = _resetTime;
        }

        KingOfTheHillStatusData
            memory kingOfTheHillStatusData = KingOfTheHillStatus.get(
                _smartObjectId,
                resetTime
            );

        // make sure king is claiming
        address king = kingOfTheHillStatusData.king;
        require(_msgSender() == king, "KingOfTheHill.claimPrize: must be king");

        uint256 duration = kingOfTheHillConfigData.duration;
        uint256 lastClaimedTime = kingOfTheHillStatusData.lastClaimedTime;
        require(
            lastClaimedTime + duration < block.timestamp,
            "KingOfTheHill.claimKing: game has not ended"
        );

        // make sure not yet claimed
        require(!kingOfTheHillStatusData.claimed, "KingOfTheHill.claimPrize: already claimed");

        // giving item to user
        uint256 expectedItemId = kingOfTheHillConfigData.expectedItemId;
        uint256 totalItemCount = kingOfTheHillStatusData.totalItemCount;
        EntityRecordTableData memory itemOutEntity = EntityRecordTable.get(
            _namespace().entityRecordTableId(),
            expectedItemId
        );

        InventoryItem[] memory outItems = new InventoryItem[](1);
        outItems[0] = InventoryItem(
            expectedItemId,
            msg.sender,
            itemOutEntity.typeId,
            itemOutEntity.itemId,
            itemOutEntity.volume,
            totalItemCount
        );
        _inventoryLib().inventoryToEphemeralTransfer(_smartObjectId, outItems);

        // updating status to claimed
        KingOfTheHillStatus.setClaimed(_smartObjectId, resetTime, true);
    }

    function resetGame(uint256 _smartObjectId, uint256 _initItemQuantity) public {
        KingOfTheHillConfigData memory kingOfTheHillConfigData = KingOfTheHillConfig.get(_smartObjectId);

        address ssuOwner = IERC721(DeployableTokenTable.getErc721Address(_namespace().deployableTokenTableId())).ownerOf(
            _smartObjectId
        );

        require(msg.sender == ssuOwner, "KingOfTheHill.setKingOfTheHillConfig: not owned");

        // seeding initial value
        uint256 expectedItemId = kingOfTheHillConfigData.expectedItemId;

        EntityRecordTableData memory itemInEntity = EntityRecordTable.get(
            _namespace().entityRecordTableId(),
            expectedItemId
        );
        InventoryItem[] memory inItems = new InventoryItem[](1);
        inItems[0] = InventoryItem(
            expectedItemId,
            msg.sender,
            itemInEntity.typeId,
            itemInEntity.itemId,
            itemInEntity.volume,
            _initItemQuantity
        );
        _inventoryLib().ephemeralToInventoryTransfer(_smartObjectId, inItems);

        // setting resetTime as game id proxy
        uint256 resetTime = block.timestamp;
        KingOfTheHillConfig.setLastResetTime(_smartObjectId, resetTime);

        // adding init value for pool
        KingOfTheHillStatus.setTotalItemCount(_smartObjectId, resetTime, _initItemQuantity);
        
        // moving status setting to reset
        KingOfTheHillStatus.setLastClaimedTime(
            _smartObjectId,
            resetTime,
            block.timestamp + 5 days
        );
        KingOfTheHillStatus.setKing(_smartObjectId, resetTime, address(0));
        KingOfTheHillStatus.setClaimed(_smartObjectId, resetTime, false);
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

    function getCurrentStatus(uint256 _smartObjectId) internal view returns (KingOfTheHillStatusData memory) {
        KingOfTheHillConfigData memory kingOfTheHillConfigData = KingOfTheHillConfig.get(_smartObjectId);

        // get lastResetTime for game id purposes
        uint256 lastResetTime = kingOfTheHillConfigData.lastResetTime;

        KingOfTheHillStatusData memory kingOfTheHillStatusData = KingOfTheHillStatus.get(_smartObjectId, lastResetTime);
    }

    function getCurrentStatusData(uint256 _smartObjectId) public view returns (
        address king, 
        uint256 startTime, 
        uint256 lastClaimedTime, 
        uint256 totalItemCount, 
        bool claimed
    ) {
        KingOfTheHillStatusData memory kingOfTheHillStatusData = getCurrentStatus(_smartObjectId);

        return (
            kingOfTheHillStatusData.king,
            kingOfTheHillStatusData.startTime,
            kingOfTheHillStatusData.lastClaimedTime,
            kingOfTheHillStatusData.totalItemCount,
            kingOfTheHillStatusData.claimed
        );
    }

    function getConfigData(uint256 _smartObjectId) public view returns (
        uint256 duration,
        uint256 expectedItemId,
        uint256 expectedItemIncrement,
        uint256 lastResetTime
    ) {
        KingOfTheHillConfigData memory kingOfTheHillConfigData = KingOfTheHillConfig.get(_smartObjectId);

        return (
            kingOfTheHillConfigData.duration,
            kingOfTheHillConfigData.expectedItemId,
            kingOfTheHillConfigData.expectedItemIncrement,
            kingOfTheHillConfigData.lastResetTime
        );
    }
}
