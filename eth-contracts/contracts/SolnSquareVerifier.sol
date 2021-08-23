pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './ERC721Mintable.sol';
import './Verifier.sol';

// TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>


// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is ERC721MintableComplete {

  Verifier private squareVerifier;

  struct Solution {
    uint index;
    address addr;
  }
  Solution[] private solutions;

  function getSols() external view returns (Solution[] memory) {
    return solutions;
  }
  mapping(uint => bool) solMap;

  event solAdded(Solution sol);

  function addSol(Solution memory sol) public {
    solutions.push(sol);
    solMap[sol.index] = true;
    emit solAdded(sol);
  }

  constructor (string memory name, string memory symbol, address verifierAddress) ERC721MintableComplete(name, symbol) public {
    squareVerifier = Verifier(verifierAddress);
  }

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


// TODO define a solutions struct that can hold an index & an address


// TODO define an array of the above struct


// TODO define a mapping to store unique solutions submitted



// TODO Create an event to emit when a solution is added



// TODO Create a function to add the solutions to the array and emit the event



// TODO Create a function to mint new NFT only after the solution has been verified
//  - make sure the solution is unique (has not been used before)
//  - make sure you handle metadata as well as tokenSuplly

  


























