// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Streamer is Ownable {
    struct Voucher {
        uint256 updatedBalance;
        Signature sig;
    }
    struct Signature {
        bytes32 r;
        bytes32 s;
        uint8 v;
    }

    mapping(address => uint256) balances;
    mapping(address => uint256) canCloseAt;

    event Opened(address, uint256);
    event Challenged(address);
    event Withdrawn(address, uint256);
    event Closed(address);

    function fundChannel() public payable {

        require(balances[msg.sender] == 0, "You have a running channel");
        balances[msg.sender] = msg.value;
        emit Opened(msg.sender, msg.value);
    }

    function timeLeft(address channel) public view returns (uint256) {
        require(canCloseAt[channel] != 0, "channel is not closing");
        return canCloseAt[channel] - block.timestamp;
    }

    function withdrawEarnings(Voucher calldata voucher) public onlyOwner {
        bytes32 hashed = keccak256(abi.encode(voucher.updatedBalance));

        bytes memory prefixed = abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            hashed
        );
        bytes32 prefixedHashed = keccak256(prefixed);

        address signer = ecrecover(
            prefixedHashed,
            voucher.sig.v,
            voucher.sig.r,
            voucher.sig.s
        );

        require(
            balances[signer] > voucher.updatedBalance,
            "The channel isn't running"
        );
        uint256 payment = balances[signer] - voucher.updatedBalance;
        balances[signer] = payment;

        payable(signer).transfer(voucher.updatedBalance);

        emit Withdrawn(signer, payment);
    }

    function challengeChannel() public {
        require(balances[msg.sender] != 0, "Don't have running channel");
        canCloseAt[msg.sender] = block.timestamp + 30 seconds;

        emit Challenged(msg.sender);
    }

    function defundChannel() public {
        require(canCloseAt[msg.sender] != 0, "You have running channels");
        require(
            block.timestamp > canCloseAt[msg.sender],
            "cannot change the channel yet"
        );
        uint256 withdraw = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = payable(msg.sender).call{value: withdraw}("");
        require(sent);

        emit Closed(msg.sender);
    }
}
