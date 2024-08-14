// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract JoMe {
    struct Admin {
        Verification[] releaserStatus;
    }

    struct Verification {
        address releaserIdentifier;
        string[] documentLinks;
        bool verified;
    }

    struct Item {
        string name;
        string description;
        string[] categories;
        uint256 price;
        uint256 amount;
        uint256 viewCount;
        address seller;
        address[] buyers;
        Manufacturer manufacturer;
    }

    struct Manufacturer {
        string name;
        string description;
        string location;   
        string[] peopleInCharge;
        string email;
        string phone;
        uint256[] itemManufacturedId;
    }

    struct Releaser {
        string name;
        uint256 releaserId;
        address identifier;
        string description;
        string location;
        string email;
        string phone;
        uint8 rating;
        Item[] items;
    }

    struct Receiver {
        string name;
        address identifier;
        Item[] itemsOrdered;
        Item[] itemsViewed;
    }

    mapping(uint256=>Releaser) public releasers;
    mapping(uint256=>Receiver) public receivers;
    mapping(address=>bool) public releaserBoolean;
    mapping(uint256=>Item) public items;
    uint256 public itemCount;
    uint256 public releaserCount;

    event ReleaserCreated(uint256 releaserId, address indexed owner);
    event ItemAddedToReleaser(uint256 itemId, address indexed owner);
    event ItemOrderedByReceiver(address indexed user, uint256 indexed itemId);
    event ReleaserInfoUpdated(uint256 indexed releaserId);
    event ItemUpdated(uint256 indexed itemId);

    modifier onlyReleaserOwner(uint256 releaserId) {
        require(releasers[releaserId].identifier==msg.sender, "Not the valid owner");
        _;
    }

    function registerReleaser(string memory name, string memory description, string memory email, string memory phone) public {
        Releaser storage releaser = releasers[releaserCount];
        releaser.name = name;
        releaser.description = description;
        releaser.email = email;
        releaser.phone = phone;
        releaser.rating = 0;
        releaserCount++;
        emit ReleaserCreated(releaserCount - 1, msg.sender);
    }

    function updateReleaser(uint256 releaserId, string memory name, string memory description, string memory email, string memory phone) public onlyReleaserOwner(releaserId) {
        Releaser storage releaser = releasers[releaserId];
        releaser.name = name;
        releaser.description = description;
        releaser.email = email;
        releaser.phone = phone;
        emit ReleaserUpdated(releaserId);
    }

    function addItem(
        uint256 releaserId,
        string memory name,
        string memory description,
        string[] memory categories,
        uint256 price,
        uint256 amount,
        string memory location,
        string memory manufacturingInfo
    ) public onlyReleaserOwner(releaserId) {
        Item storage item = items[itemCount];
        item.name = name;
        item.description = description;
        item.categories = categories;
        item.price = price;
        item.amount = amount;
        item.location = location;
        item.manufacturingInfo = manufacturingInfo;
        item.owner = msg.sender;

        releasers[releaserId].itemIds.push(itemCount);
        itemCount++;
        emit ItemAddedToReleaser(itemCount - 1, msg.sender);
    }

    function viewItem(uint256 itemId) public {
        require(itemId < itemCount, "Item does not exist");
        Item storage item = items[itemId];

        if (!users[msg.sender].viewedItems[itemId]) {
            item.viewCount++;
            users[msg.sender].viewedItems[itemId] = true;
        }
    }

    function orderItem(uint256 itemId) public {
        require(itemId < itemCount, "Item does not exist");
        Item storage item = items[itemId];
        require(item.amount > 0, "Item out of stock");

        item.amount--;
        users[msg.sender].orderedItems.push(itemId);
        emit ItemOrdered(msg.sender, itemId);
    }

    function getReleaserItems(uint256 releaserId) public view returns (Item[] memory) {
        uint256[] storage itemIds = releasers[releaserId].itemIds;
        Item[] memory releaserItems = new Item[](itemIds.length);

        for (uint256 i = 0; i < itemIds.length; i++) {
            releaserItems[i] = items[itemIds[i]];
        }

        return releaserItems;
    }

    function getTopViewedItems(uint256 topN) public view returns (Item[] memory) {
        require(topN <= itemCount, "Request exceeds total items");

        Item[] memory sortedItems = new Item[](topN);
        uint256[] memory viewCounts = new uint256[](topN);

        for (uint256 i = 0; i < topN; i++) {
            sortedItems[i] = items[i];
            viewCounts[i] = items[i].viewCount;
        }

        // Simple sorting logic to get top N viewed items
        for (uint256 i = 0; i < topN; i++) {
            for (uint256 j = i + 1; j < topN; j++) {
                if (viewCounts[j] > viewCounts[i]) {
                    uint256 tempViewCount = viewCounts[i];
                    viewCounts[i] = viewCounts[j];
                    viewCounts[j] = tempViewCount;

                    Item memory tempItem = sortedItems[i];
                    sortedItems[i] = sortedItems[j];
                    sortedItems[j] = tempItem;
                }
            }
        }

        return sortedItems;
    }

    function deleteItems(uint256 releaserId, uint256[] memory itemIds) public onlyReleaserOwner(releaserId) {
        for (uint256 i = 0; i < itemIds.length; i++) {
            require(items[itemIds[i]].owner == msg.sender, "Cannot delete others' items");
            delete items[itemIds[i]];
        }
    }

    function updateItem(
        uint256 itemId,
        string memory name,
        string memory description,
        string[] memory categories,
        uint256 price,
        uint256 amount,
        string memory location,
        string memory manufacturingInfo
    ) public {
        Item storage item = items[itemId];
        require(item.owner == msg.sender, "Cannot update others' items");

        item.name = name;
        item.description = description;
        item.categories = categories;
        item.price = price;
        item.amount = amount;
        item.location = location;
        item.manufacturingInfo = manufacturingInfo;

        emit ItemUpdated(itemId);
    }
}