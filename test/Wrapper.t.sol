// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";
import "../src/Wrapper.sol";
import "../src/Token.sol";

abstract contract StateZero is Test {
    Wrapper internal wrapper;
    Token internal token;

    address alice;

    event Wrap(address indexed user, uint256 amount);
    event Unwrap(address indexed user, uint256 amount);

    error TransferFailed();
    error InsufficientBalance();

    function setUp() public virtual {
        token = new Token();
        wrapper = new Wrapper("HUB", "Hubble", 18, address(token));

        alice = address(0x1);
        vm.label(alice, "alice");
        token.mint(alice, 1000);
    }
}

contract StateZeroTest is StateZero {
    function testWrapping() public {
        vm.startPrank(alice);
        token.approve(address(wrapper), 100);
        wrapper.wrap(100);
        vm.stopPrank();
        uint256 tokenBalance = token.balanceOf(alice);
        uint256 wrapperBalance = wrapper.balanceOf(alice);
        assertEq(tokenBalance, 900);
        assertEq(wrapperBalance, 100);
    }

    function testWrappingEmitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Wrap(alice, 100);
        vm.startPrank(alice);
        token.approve(address(wrapper), 100);
        wrapper.wrap(100);
        vm.stopPrank();
    }

    function testUnwrapReverts() public {
        vm.expectRevert(InsufficientBalance.selector);
        vm.prank(alice);
        wrapper.unwrap(100);
    }
}

abstract contract StateOne is StateZero {
    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(alice);
        token.approve(address(wrapper), 100);
        wrapper.wrap(100);
        vm.stopPrank();
    }
}

contract StateOneTest is StateOne {
    function testUnwrap() public {
        vm.prank(alice);
        wrapper.unwrap(100);
        uint256 tokenBalance = token.balanceOf(alice);
        uint256 wrapperBalance = wrapper.balanceOf(alice);
        assertEq(tokenBalance, 1000);
        assertEq(wrapperBalance, 0);
    }

    function testUnwrapEmitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Unwrap(alice, 100);
        vm.prank(alice);
        wrapper.unwrap(100);
    }
}
