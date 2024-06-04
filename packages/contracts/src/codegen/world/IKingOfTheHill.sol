// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IKingOfTheHill
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IKingOfTheHill {
  function action__setKingOfTheHillConfig(
    uint256 _smartObjectId,
    uint256 _duration,
    uint256 _expectedItemId,
    uint256 _expectedItemIncrement
  ) external;

  function action__claimKing(uint256 _smartObjectId) external;

  function action__claimPrize(uint256 _smartObjectId) external;

  function action__claimPrize(uint256 _smartObjectId, uint256 _resetTime) external;

  function action__resetGame(uint256 _smartObjectId, uint256 _initItemQuantity) external;

  function action__getCurrentStatusData(
    uint256 _smartObjectId
  )
    external
    view
    returns (address king, uint256 startTime, uint256 lastClaimedTime, uint256 totalItemCount, bool claimed);

  function action__getConfigData(
    uint256 _smartObjectId
  )
    external
    view
    returns (uint256 duration, uint256 expectedItemId, uint256 expectedItemIncrement, uint256 lastResetTime);
}
