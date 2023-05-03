const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const hre = require("hardhat");

describe("Simple", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployContract() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Simple = await ethers.getContractFactory("Simple");
    const simple = await Simple.deploy();

    return { simple, Simple, owner, otherAccount };
  }

  describe("Creation", function () {
    it("Should create a token without issue", async function () {
      const { simple } = await loadFixture(deployContract);
      await simple.createToken(
        "hello world!",
        "A hello world token.",
        "<svg>hello, world!</svg>",
        { artist: "buzzy" }
      );
    });

    it("Should mint a token without issue", async function () {
      const { simple } = await loadFixture(deployContract);

      await simple.mint({
        value: hre.ethers.utils.parseEther(".0069"),
      });
    });

    it("Should return valid URI encoded JSON", async function () {
      const { simple } = await loadFixture(deployContract);

      await simple.createToken(
        "hello world!",
        "A hello world token.",
        "<svg>hello, world!</svg>",
        { artist: "buzzy" }
      );

      const uri = await simple.tokenURI(1);

      expect(uri).to.equal(
        'data:application/json;utf8,{"name":"hello world!","description":"A hello world token.","image":"data:image/svg+xml;utf8,<svg>hello, world!</svg>","attributes":[{"trait_type":"artist","value":"buzzy"}]}'
      );

      expect(JSON.parse(uri.replace("data:application/json;utf8,", ""))).to.eql(
        {
          name: "hello world!",
          image: "data:image/svg+xml;utf8,<svg>hello, world!</svg>",
          description: "A hello world token.",
          attributes: [
            {
              trait_type: "artist",
              value: "buzzy",
            },
          ],
        }
      );
    });
  });
});
