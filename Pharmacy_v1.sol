pragma solidity >=0.4.22 <0.9.0;

contract Pharmacy {

    // Structure to define the drug properties
    struct Drug {
        uint id;
        string name;
        uint quantity;
        address owner;
    }

    // Mapping to store the drugs
    mapping(uint => Drug) public drugs;
    uint public drugsCount;

    // Events to emit drug creation and transfer
    event DrugCreated(uint id, string name, uint quantity, address owner);
    event DrugTransferred(uint id, address from, address to);

    // Function to create a drug
    function createDrug(string memory _name, uint _quantity, address _owner) public {
        drugsCount ++;
        drugs[drugsCount] = Drug(drugsCount, _name, _quantity, _owner);
        emit DrugCreated(drugsCount, _name, _quantity, _owner);
    }

    // Function to transfer a drug
    function transferDrug(uint _id, address _to) public {
        Drug memory _drug = drugs[_id];
        address _from = _drug.owner;
        require(_from == msg.sender, "You are not the owner of this drug");
        require(_to != address(0), "Invalid address");
        _drug.owner = _to;
        drugs[_id] = _drug;
        emit DrugTransferred(_id, _from, _to);
    }
}
