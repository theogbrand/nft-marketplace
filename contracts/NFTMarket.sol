// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
// security mechanism prevent reentry attacks when interacting with other contracts
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

contract NFTMarket is ReentrancyGuard {
    using Counters for Counters.Counter;

    // new items minted
    Counters.Counter private _itemIds;

    // keeping track of items, no dynamic arrays in sol
    Counters.Counter private _itemsSold;

    // payable is modifier indicating ability to process transactions
    // here only owner can process transactions with non-zero value
    address payable owner;
    // 18 DP
    uint256 listingPrice = 0.025 ether;

    constructor() {
    owner = payable(msg.sender);
    }

    // custom data type within contract to represent a record
    struct MarketItem {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        // seller and owner of MarketItem can proccess payments
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    // key-value pair like hashtable to keep track of ids to NFTs
    mapping(uint256 => MarketItem) private idToMarketItem;

    // emit event when item is created to access data on FE 
    event MarketItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    /* Returns the listing price of the contract */
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }
  // CRUD operations for managing items on MP


    /* Places an item for sale on the marketplace */
    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    // nonReentrant is an access modifier for security
    ) public payable nonReentrant {
        require(price > 0, "Price must be at least 1 wei");
        require(msg.value == listingPrice, "Price must be equal to listing price");

    _itemIds.increment();
    uint256 itemId = _itemIds.current();

    // creating entry in hash table keeping track of NFTs
    idToMarketItem[itemId] =  MarketItem(
        itemId,
        nftContract,
        tokenId,
        payable(msg.sender),
        // means empty address aka AddressZero
        payable(address(0)),
        price,
        false
    );

    // actually transfer the ownership
    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

    // emit event
    emit MarketItemCreated(
        itemId,
        nftContract,
        tokenId,
        msg.sender,
        address(0),
        price,
        false
    );
    }


    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function createMarketSale(
        address nftContract,
        uint256 itemId
        ) public payable nonReentrant {
            uint price = idToMarketItem[itemId].price;
            uint tokenId = idToMarketItem[itemId].tokenId;
            require(msg.value == price, "Please submit the asking price in order to complete the purchase, current submitted price does not match price of item");

            idToMarketItem[itemId].seller.transfer(msg.value);
            IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);

            // transfering ownership
            idToMarketItem[itemId].owner = payable(msg.sender);
            idToMarketItem[itemId].sold = true;
            _itemsSold.increment();
        payable(owner).transfer(listingPrice);
    }


    /* Returns all UNSOLD market items */
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint itemCount = _itemIds.current();
        uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
        // for looping through itemCount and find IDs of unsold items
        uint currentIndex = 0;

    MarketItem[] memory items = new MarketItem[](unsoldItemCount);

    for (uint i = 0; i < itemCount; i++) {
        // if NFT's owner is AddressZero, it is not sold
        // start from index=1 by design not by convention when minting NFTs (see test for example)
        if (idToMarketItem[i + 1].owner == address(0)) {
            uint currentId = i + 1;

            // access hash table containing items
            MarketItem storage currentItem = idToMarketItem[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;
        }
    }
    // return array
    return items;
    }


    /* Returns onlyl items that a user has purchased */
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
        if (idToMarketItem[i + 1].owner == msg.sender) {
            itemCount += 1;
        }
    }

    // solidity has no dynamic arrays
    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint i = 0; i < totalItemCount; i++) {
        // address == owner means sender OWNS the NFT
        if (idToMarketItem[i + 1].owner == msg.sender) {
            uint currentId = i + 1;
            MarketItem storage currentItem = idToMarketItem[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;
        }
    }
    return items;
    }


    /* Returns only items a user has created */
    function fetchItemsCreated() public view returns (MarketItem[] memory) {
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
        // address == seller means sender CREATED the NFT
        if (idToMarketItem[i + 1].seller == msg.sender) {
            itemCount += 1;
        }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint i = 0; i < totalItemCount; i++) {
        if (idToMarketItem[i + 1].seller == msg.sender) {
            uint currentId = i + 1;
            MarketItem storage currentItem = idToMarketItem[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;
        }
    }
    return items;
    }
}