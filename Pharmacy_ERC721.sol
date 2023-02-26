// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Pharmacy is ERC721 {
    
    // Structure to define the drug properties
    struct Drug {
        uint id;
        string name;
        uint quantity;
        address owner;
        uint price;
    }

    // Mapping to store the drugs
    mapping(uint => Drug) public drugs;
    uint public drugsCount;

    // Events to emit drug creation and transfer
    event DrugCreated(uint id, string name, uint quantity, address owner, uint price);
    event DrugTransferred(uint id, address from, address to);
    event DrugPriceSet(uint id, uint price);

    // Constructor to initialize the contract and set the name and symbol for NFTs
    constructor() ERC721("Pharmacy", "DRUG") {}

    // Function to create a drug
    function createDrug(string memory _name, uint _quantity, uint _price) public {
        drugsCount ++;
        drugs[drugsCount] = Drug(drugsCount, _name, _quantity, msg.sender, _price);
        _mint(msg.sender, drugsCount);
        emit DrugCreated(drugsCount, _name, _quantity, msg.sender, _price);
    }

    // Function to transfer a drug
    function transferDrug(uint _id, address _to) public {
        require(ownerOf(_id) == msg.sender, "You are not the owner of this drug");
        require(_to != address(0), "Invalid address");
        _transfer(msg.sender, _to, _id);
        drugs[_id].owner = _to;
        emit DrugTransferred(_id, msg.sender, _to);
    }

    // Function to set the price of a drug
    function setDrugPrice(uint _id, uint _price) public {
        require(ownerOf(_id) == msg.sender, "You are not the owner of this drug");
        drugs[_id].price = _price;
        emit DrugPriceSet(_id, _price);
    }

    // Function to get the price of a drug
    function getDrugPrice(uint _id) public view returns (uint) {
        return drugs[_id].price;
    }
}
