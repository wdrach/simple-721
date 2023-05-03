// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @notice A simple ERC721 contract with on-chain SVGs
 */

// Specifying it's an ERC721 and Ownable gives us access
// to lots of convenience methods right off the bat. ERC721
// is what will allow us to call _mint and mint a marketplace-
// recognizable NFT, and Ownable gives access to modifiers that
// restrict calling to only the person who deployed the contract.
contract Simple is ERC721, Ownable {
    // for some reason ERC721 makes us specify what token we're
    // minting, so we keep track here.
    uint256 public nextTokenId = 1;

    // some placeholder vars for the price and supply
    // "constant" vars are more gas efficient, so use them
    // where possible
    uint256 public price = 0.0069 ether;
    uint256 public constant supply = 420;

    // structs are just arbitrary collections of things.
    // you can define whatever you want here, I'm just
    // using it to keep track of the NFT's attributes
    struct Attributes {
        string artist;
    }

    // The main token meat
    struct Token {
        string name;
        string description;
        string svg;
        Attributes attributes;
    }

    // this keeps track of tokens as we are setting the metadata
    // this way, we can just submit transactions without needing
    // to know which piece we are on.
    uint256 private _nextTokenToSetup = 1;

    // the storage for the token metadata. As you would expect,
    // a mapping just maps one parameter type to another.
    mapping(uint256 => Token) private tokens;

    // init the ERC721
    constructor() ERC721("Simple", "SMPL") {}

    function mint()
        // This means it can only be called outside of this contract
        external
        // This means this function can receive an ETH value
        payable
    {
        // simple assertions to check simple things
        require(msg.value == price, "Wrong value sent");
        require(nextTokenId <= supply, "SOLD OUT!");

        // this is the mint function inherited via the "is ERC721"
        _mint(msg.sender, nextTokenId);

        // unchecked stops solidity from checking for overflow here.
        // if you have an integer that isn't ever going to overflow
        // (this one's max is 420) then this saves a bit of gas.
        unchecked {
            nextTokenId++;
        }
    }

    function airdrop(address receiver)
        external
        // note that this is super similar to the mint function
        // but instead of "payable" we have the "onlyOwner"
        // modifier. This just means that the "owner" of the contract
        // (either the person who deployed it or the address that
        // had ownership transferred to it) can call it.
        onlyOwner
    {
        require(nextTokenId <= supply, "SOLD OUT!");

        _mint(receiver, nextTokenId);

        unchecked {
            nextTokenId++;
        }
    }

    // this is where we are setting our token metadata. Pretty straightforward.
    function createToken(
        string calldata name,
        string calldata description,
        string calldata svg,
        Attributes calldata attributes)

        external
        onlyOwner
    {
        tokens[_nextTokenToSetup].name = name;
        tokens[_nextTokenToSetup].description = description;
        tokens[_nextTokenToSetup].svg = svg;
        tokens[_nextTokenToSetup].attributes = attributes;

        unchecked {
            _nextTokenToSetup++;
        }
    }

    // this is what provides the marketplaces with the "data"
    // for a given token
    function tokenURI(uint256 id)
        public
        // view just means you can read it from a node,
        // you don't have to submit a transaction
        view
        // override because we are replacing the default
        // implementation of this provided by ERC721.
        override
        // All arraylike parameters need to have a source
        // attached to them. In this case, "memory" just means
        // we will assemble it in this function, not read it from
        // storage.
        returns (string memory)
    {
        // string(abi.encodePacked(x, y, z)) just concatenates
        // x, y, and z.
        return string(
            abi.encodePacked(
                'data:application/json;utf8,{"name":"',
                tokens[id].name,
                '","description":"',
                tokens[id].description,
                '","image":"data:image/svg+xml;utf8,',
                tokens[id].svg,
                '","attributes":[{"trait_type":"artist","value":"',
                tokens[id].attributes.artist,
                '"}]}'
            )
        );
    }

    // we gotta get our moneys out somehow, right?
    function withdraw()
        external
        onlyOwner
    {
        // just send the contract's balance to the owner address
        (bool s,) = owner().call{value: (address(this).balance)}("");
        require(s, "Withdraw failed.");
    }

    // pretty straightforward, just set a new price
    function setPrice(uint256 newPrice)
        external
        // (but don't forget to make it only owner!)
        onlyOwner
    {
        price = newPrice;
    }
}