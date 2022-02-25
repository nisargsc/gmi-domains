//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import { StringUtils } from "./libraries/StringUtils.sol";
import "hardhat/console.sol";

contract Domains {
    // Top level domain
    string public tld;

    // "mapping" to store names
    mapping(string => address) public domains;

    // mapping to store records
    mapping(string => string) public records;

    constructor(string memory _tld) payable {
        _tld = _tld;
        console.log("Console log from the domain contract!!");
    }

    function price(string calldata name) public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len > 0);
        if(len==3) {
            return 5*10**17; // 0.5 MATIC | 1 MATIC = 10^18
        } else if (len == 4) {
            return 3*10**17;
        } else {
            return 1*10**17;
        }
    }

    // Register function to add names to our mapping
    function register(string calldata name) public payable {
        // name must point to "the zero address" meaning it should be unregistered
        require(domains[name] == address(0));

        uint _price = price(name);
        require(msg.value >= _price, "Not enough Matic paid");

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