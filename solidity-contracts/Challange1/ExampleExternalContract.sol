// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.15; //Do not change the solidity version as it negativly impacts submission grading

contract ExampleExternalContract {

  bool public completed;

  function complete() public payable {
    completed = true;
  }

}
