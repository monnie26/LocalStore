// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LocalStore {
    address public owner;
    mapping(string => uint256) private prices;
    mapping(string => uint256) private inventory;

    constructor() {
        owner = msg.sender;
    }

    // Function to add items
    function addItem(string memory itemName, uint256 itemPrice, uint256 itemQuantity) public {
        require(msg.sender == owner, "Only the owner can add items");
        require(itemPrice > 0, "Item price must be greater than zero");
        require(itemQuantity > 0, "Item quantity must be greater than zero");

        prices[itemName] = itemPrice;
        inventory[itemName] += itemQuantity;
    }

    // Function to purchase an item
    function purchaseItem(string memory itemName, uint256 quantity) public payable {
        require(prices[itemName] > 0, "Item does not exist");
        require(inventory[itemName] >= quantity, "Not enough items in stock");
        uint256 totalPrice = prices[itemName] * quantity;
        require(msg.value >= totalPrice, "Insufficient funds sent");

        inventory[itemName] -= quantity;
        payable(owner).transfer(totalPrice);
        
        // Refund excess Ether sent
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
    }

    //to check the inventory of an item
    function checkInventory(string memory itemName) public view returns (uint256) {
        assert(inventory[itemName] >= 0); 
        return inventory[itemName];
    }

    //to forcefully revert a transaction (for testing purposes)
    function forceRevert() public pure {
        revert("This function always reverts");
    }
}
