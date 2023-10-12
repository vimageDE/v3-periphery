// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;
pragma abicoder v2;

import '@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3FlashCallback.sol';
import '@uniswap/v3-core/contracts/libraries/LowGasSafeMath.sol';
import '../interfaces/ISwapRouter.sol';
import '../libraries/PoolAddress.sol';
import '../libraries/CallbackValidation.sol';
import '../libraries/TransferHelper.sol';
import './H1NativeApplication.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';

contract H1FlashRouter is IUniswapV3FlashCallback, H1NativeApplication {
    using LowGasSafeMath for uint256;
    using SafeERC20 for IERC20;

    ISwapRouter public immutable swapRouter;
    address immutable factory;

    address caller;
    uint256 amount0;
    uint256 amount1;
    IUniswapV3Pool pool;

    constructor(
        ISwapRouter _swapRouter,
        address _factory,
        address _fee
    ) H1NativeApplication(_fee) {
        swapRouter = _swapRouter;
        factory = _factory;
    }

    function initFlash(
        PoolAddress.PoolKey memory poolKey,
        uint256 _amount0,
        uint256 _amount1,
        bytes memory data
    ) external payable applicationFee {
        require(caller == address(0));

        pool = IUniswapV3Pool(PoolAddress.computeAddress(factory, poolKey));
        caller = msg.sender;
        amount0 = _amount0;
        amount1 = _amount1;

        pool.flash(caller, amount0, amount1, data);
    }

    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external override {
        require(msg.sender == address(pool));

        address _caller = caller;
        delete caller;

        IUniswapV3FlashCallback(_caller).uniswapV3FlashCallback(fee0, fee1, data);

        // pay the required amounts back to the pair
        address token0 = pool.token0();
        address token1 = pool.token1();
        IERC20(token0).safeTransfer(address(pool), IERC20(token0).balanceOf(address(this)));
        IERC20(token1).safeTransfer(address(pool), IERC20(token1).balanceOf(address(this)));

        delete pool;
        delete amount0;
        delete amount1;
    }
}
