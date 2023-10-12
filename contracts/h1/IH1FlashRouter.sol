// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;
pragma abicoder v2;

import '@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3FlashCallback.sol';
import '../interfaces/ISwapRouter.sol';
import '../libraries/PoolAddress.sol';

interface IH1FlashRouter is IUniswapV3FlashCallback {
    function swapRouter() external view returns (ISwapRouter);

    function h1nativeApplication() external view returns (address);

    function factory() external view returns (address);

    function initFlash(
        PoolAddress.PoolKey memory poolKey,
        uint256 amount0,
        uint256 amount1,
        bytes memory data
    ) external payable;

    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external override;
}
