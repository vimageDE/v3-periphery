// SPDX-License-Identifier: MIT

pragma solidity =0.7.6;
pragma abicoder v2;

import '../base/Multicall.sol';

contract H1Multicall is Multicall {
    /// @dev this can block potential refunds, until the last call
    bool blockRefund;

    function multicall(bytes[] calldata data) public payable override returns (bytes[] memory results) {
        blockRefund = true;
        results = super.multicall(data);
        blockRefund = false;
        require(address(this).balance == 0, 'Balance not zero');
        // if (address(this).balance > 0) TransferHelper.safeTransferETH(msg.sender, address(this).balance);
    }
}
