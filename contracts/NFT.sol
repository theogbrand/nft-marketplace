// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

// NFT standard
contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;

    // set NFT address as marketplace address
    // so MP address accessible throughout contract 
    constructor(address marketplaceAddress) ERC721("Metaverse", "MTV") {
        contractAddress = marketplaceAddress;
    }

    // minting new tokens 
    function createToken(string memory tokenURI) public returns (uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        // the current value of counter
        _setTokenURI(newItemId, tokenURI);

        // allow contractAddress (marketplace) to transact NFTs
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }
}