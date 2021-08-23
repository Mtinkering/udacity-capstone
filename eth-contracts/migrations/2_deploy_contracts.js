// migrating the appropriate contracts
// var SquareVerifier = artifacts.require("./SquareVerifier.sol");
// var SolnSquareVerifier = artifacts.require("./SolnSquareVerifier.sol");
const SolnSquareVerifier = artifacts.require("SolnSquareVerifier");
const SquareVerifier = artifacts.require("./Verifier.sol");
const Proof = require("../../zokrates/code/square/proof.json");

module.exports = async function (deployer, _network, accounts) {
  await deployer.deploy(SquareVerifier);
  const verifier = await SquareVerifier.deployed();

  await deployer.deploy(
    SolnSquareVerifier,
    "ERC721MintableToken",
    "TKN",
    verifier.address
  );

  const solnSquareVerifier = await SolnSquareVerifier.deployed();

  const { proof, inputs } = Proof;
  await solnSquareVerifier.mintNft.call(
    accounts[0],
    "12345678",
    proof.a,
    proof.b,
    proof.c,
    inputs
  );

  // const mintToken = (addr, P, id, contract) => {
  //   const { proof, inputs } = P;
  //   return contract.mintNft.call(addr, id, proof.a, proof.b, proof.c, inputs);
  // };
  // const promises = [];
  // for (let i = 0; i < 1; i++) {
  //   let p = mintToken(firstAddress, Proof, i, solnSquareVerifier);
  //   promises.push(p);
  // }

  // await Promise.all(promises);
};
