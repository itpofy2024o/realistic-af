// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract JoMe {
    struct Item {
        string name;
        string description;
        string[] categories;
        uint256 price;
        uint256 amount;
        uint256 viewCount;
        address seller;
        address[] buyers;
    }

    struct Releaser {
        string name;
        string description;
        string email;
        string phone;
        uint8 rating;
        Item[] items;
        mapping(address =>string[]) comments;
    }

    struct Receiver {
        string name;
        mapping(uint256=>bool) viewedProducts;
        uint256[] orderedProducts;
    }

    mapping(address=>Releaser) public releasers;
    mapping(address=>Receiver) public receivers;
    mapping(uint256=>Item) public items;
    uint256 public itemCount;

    event ItemOrder(address indexed receiver, uint256 indexed itemId);
    event ReleaserUpdated(address indexed releaser);
    event ItemUpdated(uint256 indexed itemId);

    modifier onlyReleaserOwner() {
        require(bytes(releasers[msg.sender].name).length != 0,"");
        _;
    }

    function registerAReleaser(string memory name,string memory description, string memory email, string memory phone) public {
    }
}