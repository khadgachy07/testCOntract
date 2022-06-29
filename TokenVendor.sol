// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BlockTuneToken.sol";

contract TokenVendor is BlockTuneToken{
    BlockTuneToken blockTuneToken;
    address public owner;
    address public buyer;
    
    uint256 public tokenPrice = 10**(18 - 3); //0.001 eth
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    
    constructor() {
        owner = msg.sender;
    }

    function approveToken(uint256 tokenApprove )public{
        bool allow = blockTuneToken.approve(buyer,tokenApprove);
        require(allow,'Allowance not provided');
    }

    function getBalance() public view returns(uint256){
         uint256 vendorBalance = blockTuneToken.balanceOf(address(this));
         return vendorBalance;
    }

    function buyTokens() public payable returns(uint256 tokenAmount){
        uint256 totalPrice = tokenPrice * 100;
        require(msg.value >= totalPrice, "Send ETH to buy some tokens");

        uint256 amountToBuy = 100*10**18;

        uint256 vendorBalance = blockTuneToken.balanceOf(address(this));
        require(vendorBalance >= amountToBuy, "Vendor contract has not enough tokens in its balance");

        transferBtToken(owner,amountToBuy);

        emit BuyTokens(msg.sender, msg.value, amountToBuy);
        return amountToBuy;
    }

    function transferBtToken(address _owner, uint256 tokenBought)public {
         bool sent = blockTuneToken.transferFrom(_owner,msg.sender, tokenBought);
        require(sent, "Failed to transfer token to user");
    }


    function withdraw() public {
        require(msg.sender == owner,'Caller must be owner');
        uint256 ownerBalance = address(owner).balance;
        require(ownerBalance > 0, "Owner has not balance to withdraw");

        (bool sent,) = msg.sender.call{value: address(owner).balance}("");
        require(sent, "Failed to send user balance back to the owner");
  }
}