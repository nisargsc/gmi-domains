//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { StringUtils } from "./libraries/StringUtils.sol";
import { Base64 } from "./libraries/Base64.sol";
import "hardhat/console.sol";

contract Domains is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Top level domain
    string public tld;

    string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#B)" d="M0 0h270v270H0z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M91.7,3.9c-0.2-2-1.7-3.5-3.7-3.7c-25.3-2-43.4,10.3-54.7,25.7c-6.2-2-12.9-1.3-19,2.1 c-5.9,3.3-10.8,8.9-14,15.7c-0.7,1.6-0.4,3.4,0.9,4.6c1.2,1.2,3.1,1.4,4.6,0.6c6.4-3.4,13.6-2.7,17.9,1.6l17.6,17.6 c0,0,0.1,0.1,0.1,0.1c4.3,4.3,5,11.5,1.6,17.9c-0.8,1.5 0.5,3.4,0.6,4.6c0.8,0.8,1.8,1.2,2.9,1.2c0.6,0,1.2-0.1,1.7-0.4 c6.8-3.2,12.4-8.2,15.7-14c3.5-6.1,4.2-12.8,2.1-19.1c4.5-3.3,8.6-6.9,12-10.9C88.6,35.4,93.2,20.7,91.7,3.9z M13.4,38.8 c4.3-4.2,9.7-6.8,15.4-5.8c-1.6,2.8-2.9,5.6 4.1,8.4C21.3,39.5,17.4,38.6,13.4,38.8z M53.3,78.6c0.1-4.1-0.8-8-2.6-11.4 c2.9-1.2,5.7-2.6,8.4-4.1C60.1,68.8,57.6,74.3,53.3,78.6z M45.3,60.7L31.2,46.6C38.3,27.7,55.9,7.5,84,8 C84.9,41.5,57.3,56,45.3,60.7z M71.2,20.8c1.2,1.2,1.9,2.9,1.9,4.6s-0.7,3.4-1.9,4.6s 2.9,1.9-4.6,1.9S63.2,31.3,62,30 s-1.9-2.9-1.9-4.6s0.7-3.4,1.9-4.6c1.2-1.2,2.9-1.9,4.6-1.9S70,19.6,71.2,20.8z M14.9,62.4C10.3,67,10.1,76.2,10.1,78 c0,2.2,1.8,4,4,4c0,0,0.1,0,0.1,0c2.1,0,10.9-0.3,15.4-4.8c2.8-2.8,3.4-5.7,3.4-7.6c0-2.7-1.1-5.3-3.2-7.4 C24.8,57.1,18.5,58.7,14.9,62.4z M24,71.5c-1,1-3.2,1.7-5.5,2c0.4-2.3,1.1-4.5,2-5.4c0.7-0.7,1.3-1.1,2-1.1c0.5,0,1.1,0.3,1.7,0.9 c0.6,0.6,0.9,1.2,0.9,1.7C25,70.2,24.5,71,24,71.5z" fill="#fff"/><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#cb5eee"/><stop offset="1" stop-color="#0cd7e4" stop-opacity=".99"/></linearGradient></defs><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = '</text></svg>';

    // "mapping" to store names
    mapping(string => address) public domains;

    // mapping to store records
    mapping(string => string) public records;

    constructor(string memory _tld) payable ERC721("GMI Name Service","gmiNS"){
        tld = _tld;
        console.log("%s name service deployed!!", _tld);
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

        uint256 _price = price(name);
        require(msg.value >= _price, "Not enough Matic paid");

        string memory _name = string(abi.encodePacked(name,".",tld));
        string memory finalSvg = string(abi.encodePacked(svgPartOne,_name,svgPartTwo));
        uint256 newRecordId = _tokenIds.current();
        uint256 length = StringUtils.strlen(name);
        string memory strLen = Strings.toString(length);

        console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);
            // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
        string memory json = Base64.encode(
            bytes(
            string(
                abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "A domain on the Ninja name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                strLen,
                '"}'
                )
            )
            )
        );
        string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));     
        
        console.log("\n--------------------------------------------------------");
        console.log("Final tokenURI", finalTokenUri);
        console.log("--------------------------------------------------------\n");

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[name] = msg.sender;

        _tokenIds.increment();
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