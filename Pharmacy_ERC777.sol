pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Pharmacy is ERC777, Ownable {

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
    event DrugTransferred(uint id, address from, address to, uint price);
    event DrugPriceChanged(uint id, uint oldPrice, uint newPrice);

    constructor() ERC777("Pharmacy Token", "PHARM", new address[](0)) {}

    // Function to create a drug
    function createDrug(string memory _name, uint _quantity, uint _price) public onlyOwner {
        drugsCount ++;
        _mint(msg.sender, drugsCount, _quantity, "");
        drugs[drugsCount] = Drug(drugsCount, _name, _quantity, msg.sender, _price);
        emit DrugCreated(drugsCount, _name, _quantity, msg.sender, _price);
    }

    // Function to transfer a drug
    function transferDrug(uint _id, address _to) public {
        require(_to != address(0), "Invalid address");
        Drug memory _drug = drugs[_id];
        uint _price = _drug.price;
        address _from = _drug.owner;
        require(_from == msg.sender, "You are not the owner of this drug");
        _operatorSend(_from, _to, _id, _drug.quantity, "", "");
        _drug.owner = _to;
        drugs[_id] = _drug;
        emit DrugTransferred(_id, _from, _to, _price);
    }

    // Function to change the price of a drug
    function setDrugPrice(uint _id, uint _newPrice) public {
        Drug memory _drug = drugs[_id];
        require(msg.sender == _drug.owner, "You are not the owner of this drug");
        emit DrugPriceChanged(_id, _drug.price, _newPrice);
        _drug.price = _newPrice;
        drugs[_id] = _drug;
    }
}
