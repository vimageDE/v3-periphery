// SPDX-License-Identifier: ISC
pragma solidity ^0.7.0;

import "./base/H1NativeBaseV07Downgrade.sol";

contract H1NativeApplicationV07Downgrade is H1NativeBaseV07Downgrade {
    constructor(address _feeContract) {
        _h1NativeBase_init(_feeContract);
    }
}
