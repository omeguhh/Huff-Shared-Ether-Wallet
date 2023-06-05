# Rewriting Old Repos in Huff

Going through old repos and rewriting them in Huff for the keks. Funny thing about rewriting repos that you first wrote when you were learning sc dev - not only do you have to rewrite them in a new language - you have to change the updated version because the og contracts were too novice or incomplete - couldnt in good conscience do a 1:1 rewrite lol.

Still very basic - but some improvements made.

## SharedEtherWallet -- Original 5/22

## Gas Comparison with old version

```
SharedWalletTest:testApproveAllowance() (gas: 45608)
SharedWalletTest:testCanTransferToOther() (gas: 57203)
SharedWalletTest:testCanTransferToOwner() (gas: 74565)
SharedWalletTest:testCantApproveIfNotOwner() (gas: 15030)
SharedWalletTest:testCompareHuffGetAccountBalance() (gas: 10547)
SharedWalletTest:testCompareHuffGetContractBalance() (gas: 5983)
SharedWalletTest:testCompareHuffTransfer() (gas: 44077)
SharedWalletTest:testCompareSolTransfer() (gas: 44160)
SharedWalletTest:testCompareSolidityGetAccountBalance() (gas: 10919)
SharedWalletTest:testCompareSolidityGetContractBalance() (gas: 6080)
SharedWalletTest:testGetAccountBalance() (gas: 11288)
SharedWalletTest:testGetContractBalance() (gas: 9478)
SharedWalletTest:testGetOwner() (gas: 13062)
SharedWalletTest:testUserCantWithdrawWithZeroAllowance() (gas: 15206)
```
