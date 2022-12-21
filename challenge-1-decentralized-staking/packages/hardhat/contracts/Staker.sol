// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 72 hours;
  
  mapping(address => uint256) public balances;

  event Stake(address, uint256);

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable {
    //require(address(this).balance <= threshold, "The Stake is completed");
    require(msg.value <= msg.sender.balance, "Funds insufficient");
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public returns(bool) {
    //require(block.timestamp > deadline, "Stake time isn't over yet");
    if (address(this).balance >= threshold) {
      exampleExternalContract.complete{value: address(this).balance}();
      return exampleExternalContract.completed();
    } else {
      return exampleExternalContract.completed();
    }
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
  function withdraw() public {
    //require(block.timestamp < deadline, "Stake time is already over");
    require(balances[msg.sender] > 0, "You don't have funds to withdraw");
    
    (bool response, /*bytes memory data*/) = msg.sender.call{value: balances[msg.sender]}("");
    require(response, "Failed to send Ether");
    balances[msg.sender] = 0;    
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns(uint256) {
    if (block.timestamp >= deadline) {
      return 0;
    } else {
      return deadline - block.timestamp;
    }
  }

  function getAccountBalance() public view returns (uint256) {
    return msg.sender.balance;
  }

  function getContractBalance() public view returns (uint256) {
    return address(this).balance;
  }

  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable {}
}
