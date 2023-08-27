pragma solidity >=0.4.22 <0.9.0;

contract Pharmacy {

    // Structure to define the drug properties
    struct Drug {
        uint id;
        string name;
        uint quantity;
        address owner;
        uint price; // Add price property to the Drug struct
    }

    // Mapping to store the drugs
    mapping(uint => Drug) public drugs;
    uint public drugsCount;

    // Events to emit drug creation and transfer
    event DrugCreated(uint id, string name, uint quantity, address owner, uint price); // Add price parameter to DrugCreated event
    event DrugTransferred(uint id, address from, address to);

    // Function to create a drug
    function createDrug(string memory _name, uint _quantity, address _owner, uint _price) public {
        drugsCount ++;
        drugs[drugsCount] = Drug(drugsCount, _name, _quantity, _owner, _price); // Add price parameter to Drug struct initialization
        emit DrugCreated(drugsCount, _name, _quantity, _owner, _price); // Add price parameter to emit statement
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

    // Function to set the price of a drug
    function setDrugPrice(uint _id, uint _price) public {
        Drug memory _drug = drugs[_id];
        address _owner = _drug.owner;
        require(_owner == msg.sender, "You are not the owner of this drug");
        _drug.price = _price;
        drugs[_id] = _drug;
    }

    // Function to get the price of a drug
    function getDrugPrice(uint _id) public view returns (uint) {
        return drugs[_id].price;
    }

    // Function to get the list of drugs owned by an address
    function getDrugsByOwner(address _owner) public view returns (uint[] memory) {
        uint[] memory result = new uint[](drugsCount);
        uint counter = 0;
        for (uint i = 1; i <= drugsCount; i++) {
            if (drugs[i].owner == _owner) {
                result[counter] = i;
                counter ++;
            }
        }
        uint[] memory ownedDrugs = new uint[](counter);
        for (uint j = 0; j < counter; j++) {
            ownedDrugs[j] = result[j];
        }
        return ownedDrugs;
    }
}
