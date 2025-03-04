// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FusionNFT is Ownable {
    // Soul nft contract address
    address private SOUL_ADDRESS = 0x1111111111111111111111111111111111111111;
    // can fusion sbt list
    mapping (address => bool) private FUSION_ADDRESS;
    // fusion need count
    mapping (address => uint256) private NEED_SOUL_COUNTS;

    event FusionStarted(address indexed user, address indexed constantAddress);

    constructor(address soulAddress) Ownable (msg.sender) {
        SOUL_ADDRESS = soulAddress;
    }

    // update soul nft contract address
    function setSoulAddress(address soulAddress) public onlyOwner {
        SOUL_ADDRESS = soulAddress;
    }

    // query soul nft contract address
    function getSoulAddress() public view returns (address) {
        return SOUL_ADDRESS;
    }

    // query sbt fusion info
    function fusionInfo(address sbtContract) public view returns (uint256) {
        return NEED_SOUL_COUNTS[sbtContract];
    }

    // set nft fusion info
    function setNftFusion(address sbtContract, uint256 needCount) public onlyOwner {
        FUSION_ADDRESS[sbtContract] = true;
        NEED_SOUL_COUNTS[sbtContract] = needCount;
    }

    // cancel nft fusion
    function cancleNftFusion(address sbtContract) public onlyOwner {
        FUSION_ADDRESS[nftContract] = false;
        NEED_SOUL_COUNTS[nftContract] = 99999;
    }

    function fusionBurn(
        address sbtContract,
        uint256 tokenId,
        uint256[] calldata soulTokenIds
    ) external {
        require(FUSION_ADDRESS[sbtContract] == true, "NFTs cannot be fused.");
        require(soulTokenIds.length == NEED_SOUL_COUNTS[sbtContract], "There aren't enough souls.");

        _burnNFT(sbtContract, tokenId);
         for (uint256 i = 0; i < soulTokenIds.length; i++) {
            _burnNFT(SOUL_ADDRESS, soulTokenIds[i]);
         }
         
         emit FusionStarted(msg.sender, sbtContract);
    }

    /**
     * @dev Internal logic for destroying a single NFT
     * @param nftContract NFT contract address
     * @param tokenId burn tokenId
     */
    function _burnNFT(address nftContract, uint256 tokenId) private {
        // check NFT
        require(
            IERC721(nftContract).getApproved(tokenId) == address(this),
            "Not NFT owner"
        );

        // execute burn
        (bool success, ) = nftContract.call(
                abi.encodeWithSignature("burn(uint256)", tokenId)
            );
        require(success, "Burn failed");
    }
}
