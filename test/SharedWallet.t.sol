// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/SolSharedWallet.sol";

contract SharedWalletTest is Test {

    SharedWallet public sharedWallet;
    SolSharedWallet public solSharedWallet;
    address payable omeguhh;
    address payable ohecksqt;

    /// @dev Setup the testing environment.
    function setUp() public {
        // string memory wrappers = vm.readFile("test/mocks/SharedWalletWrapper.huff");
        omeguhh = payable(vm.addr(420));
        ohecksqt = payable(vm.addr(69));
        address deployer = HuffDeployer.config()
        // .with_code(wrappers)
        .with_args(abi.encode(omeguhh))
        .deploy("SharedWallet");
        sharedWallet = SharedWallet(deployer);
        solSharedWallet = new SolSharedWallet();
       
    }

 
    function testGetAccountBalance() public {
        uint256 balance = sharedWallet.userBalance(0xDA9dfA130Df4dE4673b89022EE50ff26f6EA73Cf);
        console.log(balance);
        console.log(address(0xDA9dfA130Df4dE4673b89022EE50ff26f6EA73Cf).balance);
        assertEq(balance, address(0xDA9dfA130Df4dE4673b89022EE50ff26f6EA73Cf).balance);
    }

    function testGetContractBalance() public {
        vm.deal(address(sharedWallet), 10 ether);
        uint256 balance = sharedWallet.checkContractBalance();
        uint256 tradBalance = address(sharedWallet).balance;
        console.log(balance);
        console.log(tradBalance);
        assertEq(balance, tradBalance);
    }

    function testGetOwner() public {
        address owner = sharedWallet.owner();
        console.log("this is the owner", owner);
        assertEq(owner, omeguhh);
    }

    function testApproveAllowance() public {
        vm.startPrank(omeguhh);
        console.log("omeguhh",omeguhh);
        console.log("msg.sender",msg.sender);
        uint256 allowance = sharedWallet.userAllowance(omeguhh, ohecksqt);
        console.log("starting allowance", allowance);
        sharedWallet.setUserAllowance(ohecksqt, 2e18);
        console.log("starting allowance", sharedWallet.userAllowance(omeguhh, ohecksqt));
        assertEq(sharedWallet.userAllowance(omeguhh, ohecksqt), 2e18);
    }

    function testCantApproveIfNotOwner() public {
        vm.startPrank(ohecksqt);
        vm.expectRevert();
        sharedWallet.setUserAllowance(omeguhh, 2e18);
    }

    function testCanTransferToOwner() public {
        vm.deal(address(sharedWallet), 10e18);
        vm.startPrank(omeguhh);
        assertEq(address(omeguhh), sharedWallet.owner());
        console.log("this is the balance of omeguhh before transfer", omeguhh.balance);
        sharedWallet.setUserAllowance(ohecksqt, 2e18);
        // vm.stopPrank();
        // vm.startPrank(ohecksqt);
        
        sharedWallet.transfer(1e18);

        
        
        console.log("this is the balance of the contract", sharedWallet.checkContractBalance());
        console.log("this is the balance of omeguhh after transfer", omeguhh.balance);
    }
    function testCanTransferToOther() public {
        vm.deal(address(sharedWallet), 10e18);
        vm.startPrank(omeguhh);
        assertEq(address(omeguhh), sharedWallet.owner());
        console.log("this is the balance of ohecksqt before transfer", ohecksqt.balance);
        sharedWallet.setUserAllowance(ohecksqt, 2e18);
        console.log("starting allowance", sharedWallet.userAllowance(omeguhh, ohecksqt));
        vm.stopPrank();
        vm.startPrank(ohecksqt);
        
        sharedWallet.transfer(1e18);
        console.log("ending allowance", sharedWallet.userAllowance(omeguhh, ohecksqt));

        
        
        console.log("this is the balance of the contract", sharedWallet.checkContractBalance());
        console.log("this is the balance of ohecksqt after transfer", ohecksqt.balance);
    }

    function testUserCantWithdrawWithZeroAllowance() public {
        vm.startPrank(ohecksqt);
        vm.expectRevert();
        sharedWallet.transfer(1e18);
    }

    /** Huff v Sol Tests */

    function testCompareHuffGetAccountBalance() public {
        vm.deal(omeguhh, 69 ether);
        uint256 balance = sharedWallet.userBalance(omeguhh);
        assertEq(balance,69e18);
    }
    function testCompareSolidityGetAccountBalance() public {
        vm.deal(omeguhh, 69 ether);
        uint256 balance = solSharedWallet.userEthBalance(omeguhh);
        assertEq(balance,69e18);
    }
    function testCompareHuffGetContractBalance() public {
        vm.deal(address(sharedWallet), 10 ether);
        uint256 balance = sharedWallet.checkContractBalance();
        assertEq(balance,10e18);
    }
    function testCompareSolidityGetContractBalance() public {
        vm.deal(address(solSharedWallet), 10 ether);
        uint256 balance = solSharedWallet.seeBalance();
        assertEq(balance,10e18);
    }

    function testCompareHuffTransfer() public {
        vm.deal(address(sharedWallet), 10e18);
        vm.startPrank(omeguhh);
  
        
        sharedWallet.setUserAllowance(ohecksqt, 2e18);

        vm.stopPrank();
        vm.startPrank(ohecksqt);
        
        sharedWallet.transfer(1e18);
    }

    function testCompareSolTransfer() public {
        vm.deal(address(solSharedWallet), 10e18);
        vm.startPrank(omeguhh);


        solSharedWallet.setUserAllowance(ohecksqt, 2e18);

        vm.stopPrank();
        vm.startPrank(ohecksqt);
        
        solSharedWallet.withdrawFunds(ohecksqt, 1e18);
    }

    
}

interface SharedWallet {
    function userBalance(address) external view returns(uint256);
    function checkContractBalance() external view returns (uint256);
    function userAllowance(address,address) external returns(uint256);
    function setUserAllowance(address,uint256) external;
    function owner() external view returns(address);
    function transfer(uint256) external payable;
}
