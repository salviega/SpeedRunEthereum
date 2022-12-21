// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.15;  //Do not change the solidity version as it negativly impacts submission grading

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  uint256 public constant tokensPerEth = 100;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }


  // ToDo: create a payable buyTokens() function:
  function buyTokens() payable public {
    //require(msg.value <= msg.sender.balance, "Insufficient funds");
    uint256 amountOfTokens = msg.value * tokensPerEth;

    yourToken.transfer(msg.sender, amountOfTokens);

    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    require(address(this).balance != 0, "There isn't funds in the contract");
    (bool response, /*bytes memory data*/) = msg.sender.call{value: address(this).balance}("");
    require(response, "Failed to send Ether");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
      uint256 amountOfETH = _amount / tokensPerEth;
      require(address(this).balance >= amountOfETH, "Ventor doesn't have enough funds");
      require(yourToken.balanceOf(msg.sender) >= _amount, "You don't have enough tokens");

      yourToken.transferFrom(msg.sender, address(this), _amount);
      (bool response, /*bytes memory data*/) = msg.sender.call{value: amountOfETH}("");
      require(response, "Failed to send Ether");
  }

}
