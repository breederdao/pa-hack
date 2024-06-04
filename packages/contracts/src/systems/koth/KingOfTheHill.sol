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

import { InventoryInteract } from "@eveworld/world/src/modules/inventory/system/InventoryInteract.sol";

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

        KingOfTheHillConfig.set(
            _smartObjectId,
            _duration,
            _expectedItemId,
            _expectedItemIncrement,
            0
        );

        KingOfTheHillStatus.setLastClaimedTime(
            _smartObjectId,
            block.timestamp + 5 days
        );
        KingOfTheHillStatus.setKing(_smartObjectId, address(0));
        KingOfTheHillStatus.setClaimed(_smartObjectId, false);
    }

    function claimKing(uint256 _smartObjectId) public {
        KingOfTheHillStatusData
            memory kingOfTheHillStatusData = KingOfTheHillStatus.get(
                _smartObjectId
            );
        KingOfTheHillConfigData
            memory kingOfTheHillConfigData = KingOfTheHillConfig.get(
                _smartObjectId
            );

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
            _msgSender(),
            startTime,
            block.timestamp,
            updatedItemCount,
            false
        );
    }

    function claimPrize(uint256 _smartObjectId) public {
        KingOfTheHillConfigData
            memory kingOfTheHillConfigData = KingOfTheHillConfig.get(
                _smartObjectId
            );
        KingOfTheHillStatusData
            memory kingOfTheHillStatusData = KingOfTheHillStatus.get(
                _smartObjectId
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
        KingOfTheHillStatus.setClaimed(_smartObjectId, true);
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