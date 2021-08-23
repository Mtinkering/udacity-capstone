pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './ERC721Mintable.sol';
import './Verifier.sol';

// TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>


// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is ERC721MintableComplete {

  Verifier private squareVerifier;

  // TODO define a solutions struct that can hold an index & an address
  struct Solution {
    uint index;
    address addr;
  }

  // TODO define an array of the above struct
  Solution[] private solutions;

  function getSols() external view returns (Solution[] memory) {
    return solutions;
  }

  // TODO define a mapping to store unique solutions submitted
  mapping(uint => bool) solMap;

  // TODO Create an event to emit when a solution is added
  event solAdded(Solution sol);

  // TODO Create a function to add the solutions to the array and emit the event
  function addSol(Solution memory sol) public {
    solutions.push(sol);
    solMap[sol.index] = true;
    emit solAdded(sol);
  }

  constructor (string memory name, string memory symbol, address verifierAddress) ERC721MintableComplete(name, symbol) public {
    squareVerifier = Verifier(verifierAddress);
  }

  // TODO Create a function to mint new NFT only after the solution has been verified
  //  - make sure the solution is unique (has not been used before)
  //  - make sure you handle metadata as well as tokenSuplly
  function mintNft(
    address to,
    uint tokenId,
    uint[2] memory a,
    uint[2][2] memory b,
    uint[2] memory c,
    uint[2] memory input
    ) public returns(bool result){
    require(to != address(0), "invalid address");
    require(squareVerifier.verifyTx(a, b, c, input) == true, "Verification failed");
    require(solMap[tokenId] == false, "Solution existed");

    addSol(Solution(tokenId, to));

    result = mint(to, tokenId);
    require(result == true, "Could not mint the token");
  }
}
























