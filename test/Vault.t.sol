// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract VaultTest is Test {
    IVault public vault;

    /// @dev Setup the testing environment.
    function setUp() public {
        vault = IVault(HuffDeployer.deploy("Vault"));
    }
}

interface IVault {
    function owner() external returns (address);

    function setOwner(address) external returns (bool);

    function deposit() external;

    function withdraw() external;
}
