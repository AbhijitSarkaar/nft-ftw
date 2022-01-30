// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from './libraries/Base64.sol';

contract MyNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
  string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ['Eating', 'Sleeping', 'Resting', 'Relaxing', 'Chilling'];
  string[] secondWords = ['Burger', 'Sandwich', 'Pizza', 'Lasagna', 'Fries'];
  string[] thirdWords = ['Neil', 'Vidit', 'Magnus', 'Pragg', 'Anish'];

  string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

  event newNFTMinted(address sender, uint256 tokenId);
  event NFTMintedcount(address sender, uint256 count);

  function random(string memory input) internal pure returns (uint256) {  
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    uint256 r_key = rand % firstWords.length;
    return firstWords[r_key];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    uint256 r_key = rand % firstWords.length;
    return secondWords[r_key];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    uint256 r_key = rand % firstWords.length;
    return thirdWords[r_key];
  }

   function pickRandomColor(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
    rand = rand % colors.length;
    return colors[rand];
  }

  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("NFT contract Constructor");
  }

  function getCurrentNFTMintedcount() public {
    emit NFTMintedcount(msg.sender, _tokenIds.current());
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();
    require(newItemId <= 50);
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    string memory randomColor = pickRandomColor(newItemId);
    string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n------------------");
    console.log(finalTokenUri);
    console.log("\n------------------");

    _safeMint(msg.sender, newItemId);
    _setTokenURI(newItemId, finalTokenUri);
    _tokenIds.increment();

    emit newNFTMinted(msg.sender, newItemId);
  }
}