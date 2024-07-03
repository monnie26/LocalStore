# LocalStore: Smart Contract
This project implements a basic smart contract for a local store using Solidity. The contract allows the owner to add items to the store, customers to purchase items, and anyone to check the inventory of items.

## Features
- Add items to the store (only by the owner)
- Purchase items from the store
- Check the inventory of specific items
- Force revert transactions (for testing purposes)

## Prerequisites
- [Remix IDE](https://remix.ethereum.org/)

## Contract Code

```solidity
    // Function to add items to the store
    function addItem(string memory itemName, uint256 itemPrice, uint256 itemQuantity) public {
        require(msg.sender == owner, "Only the owner can add items");
        require(itemPrice > 0, "Item price must be greater than zero");
        require(itemQuantity > 0, "Item quantity must be greater than zero");

        prices[itemName] = itemPrice;
        inventory[itemName] += itemQuantity;
    }

    // Function to purchase an item from the store
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

    // Function to check the inventory of an item
    function checkInventory(string memory itemName) public view returns (uint256) {
        assert(inventory[itemName] >= 0); // This should always be true

        return inventory[itemName];
    }

    // Function to forcefully revert a transaction (for testing purposes)
    function forceRevert() public pure {
        revert("This function always reverts");
    }
}
```
## Author
Monnie Sharma

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
