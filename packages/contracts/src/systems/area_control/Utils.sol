//SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";
import { WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { ResourceIds } from "@latticexyz/store/src/codegen/tables/ResourceIds.sol";

import { KOTH_NAMESPACE, AC_LOBBY_SYSTEM_NAME, AC_POINT_SYSTEM_NAME } from "../constants.sol";

library Utils {
    function lobbySystemId(
        bytes14 namespace
    ) internal pure returns (ResourceId) {
        return
            WorldResourceIdLib.encode({
                typeId: RESOURCE_SYSTEM,
                namespace: namespace,
                name: AC_LOBBY_SYSTEM_NAME
            });
    }

    function pointSystemId(
        bytes14 namespace
    ) internal pure returns (ResourceId) {
        return
            WorldResourceIdLib.encode({
                typeId: RESOURCE_SYSTEM,
                namespace: namespace,
                name: AC_POINT_SYSTEM_NAME
            });
    }
}
