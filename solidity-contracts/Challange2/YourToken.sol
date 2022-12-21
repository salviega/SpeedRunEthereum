// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.15;  //Do not change the solidity version as it negativly impacts submission grading

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/4.x/erc20

contract YourToken is ERC20 {
    constructor(address _contractAndress) ERC20("Gold", "GLD") {
        _mint(_contractAndress, 1000 * 10 ** 18);
    }
}
