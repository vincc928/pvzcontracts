// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract BatchSendEther{

    string password;

    constructor(string memory pwd) {
        // set password
        password = pwd;
    }

    // Function for sending Ether in batches
    function batchSendEther(address payable[] memory recipients, uint256 amount, string memory pwd) external payable {
        require(keccak256(abi.encodePacked(password)) == keccak256(abi.encodePacked(pwd)), "Invalid access signature");

        uint256 totalAmount = 0;
        for (uint256 i = 0; i < recipients.length; i++) {
            totalAmount += amount;
        }
        require(msg.value >= totalAmount, "Insufficient Ether sent");

        // Traverse the array of recipient addresses and send Ether one by one.
        for (uint256 i = 0; i < recipients.length; i++) {
            recipients[i].transfer(amount);
        }
    }
}
