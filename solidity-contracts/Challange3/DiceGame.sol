// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.15;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";

contract DiceGame {

    uint256 public nonce = 0;
    uint256 public prize = 0;

    event Roll(address indexed player, uint256 roll);
    event Winner(address winner, uint256 amount);

    constructor() payable {
        resetPrize();
    }

    function resetPrize() private {
        prize = ((address(this).balance * 10) / 100);
    }

    function rollTheDice() public payable {
        require(msg.value >= 0.002 ether, "Failed to send enough value");
        //blockhash: return hash of the given block -- block.number: Current block number
        bytes32 prevHash = blockhash(block.number - 1); 
        //keccak256: return hash -- abi.encodePacked(arg) encode
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(this), nonce));
        // %: return of residuos of the division
        uint256 roll = uint256(hash) % 16;

        console.log('\t',"   Dice Game Roll:",roll);

        nonce++;
        prize += ((msg.value * 40) / 100);

        emit Roll(msg.sender, roll);

        if (roll > 2 ) {
            return;
        }

        uint256 amount = prize;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        resetPrize();
        emit Winner(msg.sender, amount);
    }

    receive() external payable {  }
}
