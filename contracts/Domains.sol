//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract Domains {
    // "mapping" to store names
    mapping(string => address) public domains;

    constructor() {
        console.log("Console log from the domain contract!!");
    }

    // Register function to add names to our mapping
    function register(string calldata name) public {
        domains[name] = msg.sender;
        console.log("%s has register a domain %s.gmi!!",msg.sender,name);
    }

    function getAddress(string calldata name) public view returns (address) {
        return domains[name];
    }
}