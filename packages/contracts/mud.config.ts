import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  namespace: "bdArena",
  systems: {
    KingOfTheHill: {
      name: "KingOfTheHill",
      openAccess: true,
    }
  },
  tables: {
    KingOfTheHillConfig: {
      keySchema: {
        smartObjectId: "uint256"
      },
      valueSchema: {
        duration: "uint256",
        expectedItemId: "uint256", // item required
        expectedItemIncrement: "uint256",
        lastStartTime: "uint256" // based on startTime
      },
    },
    KingOfTheHillStatus: {
      keySchema: {
        smartObjectId: "uint256"
        // id can be startTime
      },
      valueSchema: {
        king: "address",
        startTime: "uint256", // to calculate total running time
        lastClaimedTime: "uint256",
        totalItemCount: "uint256", // total pot
        // claimed: "bool"
      },
    }
  },
});
