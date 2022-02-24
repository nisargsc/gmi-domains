//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract Domains {
    // "mapping" to store names
    mapping(string => address) public domains;

    // mapping to store records
    mapping(string => string) public records;

    constructor() {
        console.log("Console log from the domain contract!!");
    }

    // Register function to add names to our mapping
    function register(string calldata name) public {
        // name must point to "the zero address" meaning it should be unregistered
        require(domains[name] == address(0));
        domains[name] = msg.sender;
        console.log("%s has register a domain %s.gmi!!",msg.sender,name);
    }

    function getAddress(string calldata name) public view returns (address) {
        return domains[name];
    }

    function setRecord(string calldata name, string calldata record) public {
        require(domains[name] == msg.sender);
        records[name] = record;
    }

    function getRecord(string calldata name) public view returns(string memory) {
        return records[name];
    }
}