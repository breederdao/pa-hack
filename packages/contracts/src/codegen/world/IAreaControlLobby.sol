// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IAreaControlLobby
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IAreaControlLobby {
  function king__setLobbyConfig(
    uint256 _smartObjectId,
    uint256 _duration,
    uint256 _playerCount,
    uint256 _expectedItemId,
    uint256 _expectedItemQuantity,
    uint256 _expectedControlDepositId,
    address _areaControlPoint
  ) external;

  function king__acResetGame(uint256 _smartObjectId) external;

  function king__acJoinGame(uint256 _smartObjectId, uint256 _team) external;

  function king__acStartGame(uint256 _smartObjectId) external;

  function king__acClaimPrize(uint256 _smartObjectId) external;

  function king__getGameSettings(
    uint256 _smartObjectId
  ) external view returns (uint256 duration, uint256 startTime, uint256 resetTime);

  function king__getTeamPlayers(
    uint256 _smartObjectId
  ) external view returns (address[] memory teamAPlayers, address[] memory teamBPlayers);

  function king__isPlayer(uint256 _smartObjectId, address _player) external view returns (uint256);
}
