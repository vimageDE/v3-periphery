// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

interface IFeeContract {
    // This function retrieves the value of H1 in USD.
    function queryOracle() external view returns (uint256);

    //This function returns a timestamp that will tell the contract when to update the oracle.
    function nextResetTime() external view returns (uint256);

    // This function updates the fees in the fee contract to match the oracle values.
    function updateFee() external;
}

contract MockFeeContract is IFeeContract {
    uint256 public fee;

    constructor(uint256 _fee) {
        fee = _fee;
    }

    // This function retrieves the value of H1 in USD.
    function queryOracle() external view override returns (uint256) {
        return fee;
    }

    //This function returns a timestamp that will tell the contract when to update the oracle.
    function nextResetTime() external view override returns (uint256) {
        return (block.timestamp + (60 * 60 * 24));
    }

    // This function updates the fees in the fee contract to match the oracle values.
    function updateFee() external override {}

    receive() external payable {}
}
