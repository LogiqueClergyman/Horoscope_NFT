//SPDX-License-Identifier: unlicensed

pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

contract horoscopeNFT is ERC721URIStorage {
    constructor() ERC721("HoroscopeNFT", "HORT") {}

    uint256 private _tokenIds;
    string baseSvg =
        "<svg xmlns='<http://www.w3.org/2000/svg>' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    function mintNFT(
        address recipient,
        string memory zodiacSign
    ) public returns (uint256) {
        _tokenIds += 1;
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, zodiacSign, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        zodiacSign,
                        '",',
                        '"description": "On-chain Zodiac Sign NFTs",',
                        '"attributes": [{"trait type": "Zodiac Sign", "value": "',
                        zodiacSign,
                        '"}],',
                        '"image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        uint256 newItemId = _tokenIds;
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        return newItemId;
    }
}
