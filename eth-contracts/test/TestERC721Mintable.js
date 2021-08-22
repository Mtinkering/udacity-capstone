const ERC721MintableComplete = artifacts.require("ERC721MintableComplete");
const { expectRevert } = require("@openzeppelin/test-helpers");

contract("TestERC721Mintable", (accounts) => {
  const account_one = accounts[0];
  const account_two = accounts[1];

  describe("match erc721 spec", function () {
    beforeEach(async function () {
      this.contract = await ERC721MintableComplete.new(
        "ERC721MintableToken",
        "TKN",
        {
          from: account_one,
        }
      );

      // TODO: mint multiple tokens
      await this.contract.mint(account_two, "123");
      await this.contract.mint(account_two, "456");
    });

    it("should return total supply", async function () {
      const total = await this.contract.totalSupply();
      assert.equal(total, 2);
    });

    it("should get token balance", async function () {
      const balance = await this.contract.balanceOf(account_two);
      assert.equal(balance, 2);
    });

    // token uri should be complete i.e: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1
    it("should return token uri", async function () {
      const tokenURI = await this.contract.tokenURI("123");
      assert.equal(
        tokenURI,
        "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/123"
      );
    });

    it("should transfer token from one owner to another", async function () {
      await this.contract.transferFrom(account_two, accounts[2], "123", {
        from: account_two,
      });
    });
  });

  describe("have ownership properties", function () {
    beforeEach(async function () {
      this.contract = await ERC721MintableComplete.new(
        "ERC721MintableToken",
        "TKN",
        { from: account_one }
      );
    });

    it("should fail when minting when address is not contract owner", async function () {
      await expectRevert(
        this.contract.mint(account_two, "123", {
          from: account_two,
        }),
        "Only owner"
      );
    });

    it("should return contract owner", async function () {
      assert.equal(await this.contract.getOwner(), account_one);
    });
  });
});
