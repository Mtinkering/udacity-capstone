// migrating the appropriate contracts
const SolnSquareVerifier = artifacts.require("SolnSquareVerifier");
const SquareVerifier = artifacts.require("./Verifier.sol");

module.exports = async function (deployer, _network, accounts) {
  await deployer.deploy(SquareVerifier);
  const verifier = await SquareVerifier.deployed();

  await deployer.deploy(
    SolnSquareVerifier,
    "ERC721MintableToken",
    "TKN",
    verifier.address
  );
};
