// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console2.sol";
import "lib/yield-utils-v2/contracts/token/IERC20.sol";
import "lib/yield-utils-v2/contracts/token/ERC20Permit.sol";

contract Wrapper is ERC20Permit {
    IERC20 public immutable token;

    event Wrap(address indexed user, uint256 amount);
    event Unwrap(address indexed user, uint256 amount);

    error InsufficientBalance();
    error TransferFailed();

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address erc20Address
    ) ERC20Permit(name_, symbol_, decimals_) {
        token = IERC20(erc20Address);
    }

    function wrap(uint256 amount) public {
        _mint(msg.sender, amount);
        bool success = token.transferFrom(msg.sender, address(this), amount);
        if (!success) {
            revert TransferFailed();
        }
        emit Wrap(msg.sender, amount);
    }

    function unwrap(uint256 amount) public {
        uint256 wrappedBalance = this.balanceOf(msg.sender);
        if (wrappedBalance < amount) {
            revert InsufficientBalance();
        }
        _burn(msg.sender, amount);
        bool success = token.transferFrom(address(this), msg.sender, amount);
        if (!success) {
            revert TransferFailed();
        }
        emit Unwrap(msg.sender, amount);
    }
}
