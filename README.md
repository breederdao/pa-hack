# Project Documentation

## Prerequisite

- Follow the link to install Foundry, Node.js, and PNPM: [https://mud.dev/quickstart](https://mud.dev/quickstart)

## Installation

1. From the root directory, run the command `pnpm install`.
2. Navigate to the `contracts` folder by running `cd packages/contracts` from the root directory.
3. Change your MUD namespace in the `contracts/mud.config.ts` file.
4. After changing the namespace, run the command `pnpm clean`. Note: If you encounter an error in the `/scripts` folder, comment out the `IKingOfTheHill(worldAddress)` part.
5. Build the project by running the command `pnpm build`.
6. Deploy the project on the PA world using the command `pnpm run deploy:testnet --world-address 0x8dc9cab3e97da6df615a8a24cc07baf110d63071`.
7. Uncomment the `IKingOfTheHill(worldAddress)` line in the `/scripts/` directory under `contracts`. Change your prefix based on the `mud.config.ts` file. Example: `SetKingOfTheHillConfig.s.sol IKingOfTheHill(worldAddress).yourMudPrefix__setKingOfTheHillConfig(smartStorageUnitId, 3 minutes, itemId, 3)`.

## Available Commands

1. Deploy KingOfTheHill contracts on the PA world:

   ```
   pnpm run deploy:testnet --world-address 0x8dc9cab3e97da6df615a8a24cc07baf110d63071
   ```

2. Setup KingOfTheHill game config:

   - Comment out the `IKingOfTheHill(worldAddress)` part in `scripts/SetKingOfTheHillConfig.s.ts`.
   - Change the prefix of the function based on your `mud.config.ts` file.

   ```
   pnpm run setup-koth
   ```

3. Reset KingOfTheHill game:

   - Comment out the `IKingOfTheHill(worldAddress)` part in `scripts/SetKingOfTheHillConfig.s.ts`.
   - Change the prefix of the function based on your `mud.config.ts` file.

   ```
   pnpm run reset-game
   ```

4. Claim King on KingOfTheHill game:

   - Comment out the `IKingOfTheHill(worldAddress)` part in `scripts/ClaimKing.s.ts`.
   - Change the prefix of the function based on your `mud.config.ts` file.
   - Note: You can change the caller by changing the PLAYER_KEY in the `.env` file.

   ```
   pnpm run claim-king
   ```

5. Claim KingOfTheHill prize:
   - Comment out the `IKingOfTheHill(worldAddress)` part in `scripts/ClaimPrize.s.ts`.
   - Change the prefix of the function based on your `mud.config.ts` file.
   ```
   pnpm run claim-prize
   ```
