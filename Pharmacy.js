const ethers = require('ethers');

// Provider and signer
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');
const signer = new ethers.Wallet('YOUR_PRIVATE_KEY', provider);

// Contract address and ABI
const contractAddress = 'CONTRACT_ADDRESS';
const abi = [
  // Add the contract ABI here
];

// Connect to the contract
const contract = new ethers.Contract(contractAddress, abi, signer);

// Create a new drug
async function createDrug(name, quantity, owner) {
  const tx = await contract.createDrug(name, quantity, owner);
  await tx.wait();
  console.log(`New drug created with ID ${await contract.drugsCount()}`);
}

// Transfer a drug
async function transferDrug(id, to) {
  const tx = await contract.transferDrug(id, to);
  await tx.wait();
  console.log(`Drug ${id} transferred to ${to}`);
}

// Get drug details
async function getDrugDetails(id) {
  const drug = await contract.drugs(id);
  console.log(`Drug ID: ${drug.id}, Name: ${drug.name}, Quantity: ${drug.quantity}, Owner: ${drug.owner}`);
}

// Listen for DrugTransferred events
contract.on('DrugTransferred', (id, from, to) => {
  console.log(`Drug ${id} transferred from ${from} to ${to}`);
});
