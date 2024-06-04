// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

// Import schema type
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout, FieldLayoutLib } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

// Hex below is the result of `WorldResourceIdLib.encode({ namespace: "bdArena", name: "KingOfTheHillCon", typeId: RESOURCE_TABLE });`
ResourceId constant _tableId = ResourceId.wrap(0x746262644172656e61000000000000004b696e674f6654686548696c6c436f6e);
ResourceId constant KingOfTheHillConfigTableId = _tableId;

FieldLayout constant _fieldLayout = FieldLayout.wrap(
  0x0080040020202020000000000000000000000000000000000000000000000000
);

struct KingOfTheHillConfigData {
  uint256 duration;
  uint256 expectedItemId;
  uint256 expectedItemIncrement;
  uint256 lastResetTime;
}

library KingOfTheHillConfig {
  /**
   * @notice Get the table values' field layout.
   * @return _fieldLayout The field layout for the table.
   */
  function getFieldLayout() internal pure returns (FieldLayout) {
    return _fieldLayout;
  }

  /**
   * @notice Get the table's key schema.
   * @return _keySchema The key schema for the table.
   */
  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _keySchema = new SchemaType[](1);
    _keySchema[0] = SchemaType.UINT256;

    return SchemaLib.encode(_keySchema);
  }

  /**
   * @notice Get the table's value schema.
   * @return _valueSchema The value schema for the table.
   */
  function getValueSchema() internal pure returns (Schema) {
    SchemaType[] memory _valueSchema = new SchemaType[](4);
    _valueSchema[0] = SchemaType.UINT256;
    _valueSchema[1] = SchemaType.UINT256;
    _valueSchema[2] = SchemaType.UINT256;
    _valueSchema[3] = SchemaType.UINT256;

    return SchemaLib.encode(_valueSchema);
  }

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "smartObjectId";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](4);
    fieldNames[0] = "duration";
    fieldNames[1] = "expectedItemId";
    fieldNames[2] = "expectedItemIncrement";
    fieldNames[3] = "lastResetTime";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, getKeySchema(), getValueSchema(), getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, getKeySchema(), getValueSchema(), getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get duration.
   */
  function getDuration(uint256 smartObjectId) internal view returns (uint256 duration) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get duration.
   */
  function _getDuration(uint256 smartObjectId) internal view returns (uint256 duration) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set duration.
   */
  function setDuration(uint256 smartObjectId, uint256 duration) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((duration)), _fieldLayout);
  }

  /**
   * @notice Set duration.
   */
  function _setDuration(uint256 smartObjectId, uint256 duration) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((duration)), _fieldLayout);
  }

  /**
   * @notice Get expectedItemId.
   */
  function getExpectedItemId(uint256 smartObjectId) internal view returns (uint256 expectedItemId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get expectedItemId.
   */
  function _getExpectedItemId(uint256 smartObjectId) internal view returns (uint256 expectedItemId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set expectedItemId.
   */
  function setExpectedItemId(uint256 smartObjectId, uint256 expectedItemId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((expectedItemId)), _fieldLayout);
  }

  /**
   * @notice Set expectedItemId.
   */
  function _setExpectedItemId(uint256 smartObjectId, uint256 expectedItemId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((expectedItemId)), _fieldLayout);
  }

  /**
   * @notice Get expectedItemIncrement.
   */
  function getExpectedItemIncrement(uint256 smartObjectId) internal view returns (uint256 expectedItemIncrement) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get expectedItemIncrement.
   */
  function _getExpectedItemIncrement(uint256 smartObjectId) internal view returns (uint256 expectedItemIncrement) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set expectedItemIncrement.
   */
  function setExpectedItemIncrement(uint256 smartObjectId, uint256 expectedItemIncrement) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((expectedItemIncrement)), _fieldLayout);
  }

  /**
   * @notice Set expectedItemIncrement.
   */
  function _setExpectedItemIncrement(uint256 smartObjectId, uint256 expectedItemIncrement) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((expectedItemIncrement)), _fieldLayout);
  }

  /**
   * @notice Get lastResetTime.
   */
  function getLastResetTime(uint256 smartObjectId) internal view returns (uint256 lastResetTime) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get lastResetTime.
   */
  function _getLastResetTime(uint256 smartObjectId) internal view returns (uint256 lastResetTime) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set lastResetTime.
   */
  function setLastResetTime(uint256 smartObjectId, uint256 lastResetTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((lastResetTime)), _fieldLayout);
  }

  /**
   * @notice Set lastResetTime.
   */
  function _setLastResetTime(uint256 smartObjectId, uint256 lastResetTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((lastResetTime)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get(uint256 smartObjectId) internal view returns (KingOfTheHillConfigData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    (bytes memory _staticData, PackedCounter _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get(uint256 smartObjectId) internal view returns (KingOfTheHillConfigData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    (bytes memory _staticData, PackedCounter _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(
    uint256 smartObjectId,
    uint256 duration,
    uint256 expectedItemId,
    uint256 expectedItemIncrement,
    uint256 lastResetTime
  ) internal {
    bytes memory _staticData = encodeStatic(duration, expectedItemId, expectedItemIncrement, lastResetTime);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    uint256 smartObjectId,
    uint256 duration,
    uint256 expectedItemId,
    uint256 expectedItemIncrement,
    uint256 lastResetTime
  ) internal {
    bytes memory _staticData = encodeStatic(duration, expectedItemId, expectedItemIncrement, lastResetTime);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(uint256 smartObjectId, KingOfTheHillConfigData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.duration,
      _table.expectedItemId,
      _table.expectedItemIncrement,
      _table.lastResetTime
    );

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(uint256 smartObjectId, KingOfTheHillConfigData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.duration,
      _table.expectedItemId,
      _table.expectedItemIncrement,
      _table.lastResetTime
    );

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(
    bytes memory _blob
  )
    internal
    pure
    returns (uint256 duration, uint256 expectedItemId, uint256 expectedItemIncrement, uint256 lastResetTime)
  {
    duration = (uint256(Bytes.slice32(_blob, 0)));

    expectedItemId = (uint256(Bytes.slice32(_blob, 32)));

    expectedItemIncrement = (uint256(Bytes.slice32(_blob, 64)));

    lastResetTime = (uint256(Bytes.slice32(_blob, 96)));
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   *
   *
   */
  function decode(
    bytes memory _staticData,
    PackedCounter,
    bytes memory
  ) internal pure returns (KingOfTheHillConfigData memory _table) {
    (_table.duration, _table.expectedItemId, _table.expectedItemIncrement, _table.lastResetTime) = decodeStatic(
      _staticData
    );
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(uint256 smartObjectId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(uint256 smartObjectId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    uint256 duration,
    uint256 expectedItemId,
    uint256 expectedItemIncrement,
    uint256 lastResetTime
  ) internal pure returns (bytes memory) {
    return abi.encodePacked(duration, expectedItemId, expectedItemIncrement, lastResetTime);
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    uint256 duration,
    uint256 expectedItemId,
    uint256 expectedItemIncrement,
    uint256 lastResetTime
  ) internal pure returns (bytes memory, PackedCounter, bytes memory) {
    bytes memory _staticData = encodeStatic(duration, expectedItemId, expectedItemIncrement, lastResetTime);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(uint256 smartObjectId) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(smartObjectId));

    return _keyTuple;
  }
}
