import { mudConfig } from '@latticexyz/world/register'

export default mudConfig({
  namespace: 'king',
  systems: {
    KingOfTheHill: {
      name: 'KingOfTheHill',
      openAccess: true,
    },
    AreaControlLobby: {
      name: 'AreaControlLobby',
      openAccess: true,
    },
  },
  tables: {
    KingOfTheHillConfig: {
      keySchema: {
        smartObjectId: 'uint256',
      },
      valueSchema: {
        duration: "uint256",
        expectedItemId: "uint256", // item required
        expectedItemIncrement: "uint256",
        lastResetTime: "uint256" // based on startTime
      },
    },
    KingOfTheHillStatus: {
      keySchema: {
        smartObjectId: "uint256",
        lastResetTime: "uint256" // id can be lastResetTime
      },
      valueSchema: {
        king: 'address',
        startTime: 'uint256', // to calculate total running time
        lastClaimedTime: 'uint256',
        totalItemCount: 'uint256', // total pot
        claimed: 'bool',
      },
    },
    ACLobbyConfig: {
      keySchema: {
        smartObjectId: 'uint256'
      },
      valueSchema: {
        duration: 'uint256',
        playerCount: 'uint256',
        expectedItemId: 'uint256',
        expectedItemQuantity: 'uint256',
        expectedControlDepositId: 'uint256',
        lastResetTime: 'uint256'
      }
    },
    ACLobbyStatus: {
      keySchema: {
        smartObjectId: 'uint256',
        lastResetTime: 'uint256'
      },
      valueSchema: {
        startTime: 'uint256',
        teamATotalTime: 'uint256',
        teamBTotalTime: 'uint256',
        teamAPlayers: 'uint256',
        teamBPlayers: 'uint256',
        claimed: "bool"
      }
    },
    ACPointStatus: {
      keySchema: {
        smartObjectId: 'uint256',
        lastResetTime: 'uint256'
      },
      valueSchema: {
        controllingTeam: 'uint256',
        lastControlChangeTime: 'uint256',
        teamATime: 'uint256',
        teamBTime: 'uint256'
      }
    }
  },
})
