// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Inherit ERC721 and Ownable. ERC721 is used to create NFTs, and Ownable is used for permission management (controlling the owner).
contract BadgeSbt is ERC721, Ownable {
    string public uri;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Constructor: Set the contract name and symbol
    constructor(
        string memory name,
        string memory symbol,
        string memory tokenUri
    ) ERC721(name, symbol) Ownable(msg.sender){
        uri = tokenUri;
    }

    // Batch mint SBTs: Mint multiple SBTs at once, and all SBTs are minted to the contract owner
    function mintBatchToOwner(uint256 quantity) public onlyOwner {
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _mint(owner(), tokenId); 
            _tokenIdCounter.increment(); // add tokenId
        }
    }

    // Mint to the specified wallet
    function mintAndTransferFrom(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _mint(to, tokenId);
        _tokenIdCounter.increment();
    }

    // The owner can call this function to delete the specific NFT of the specified user.
    function deleteNFT(address user, uint256 tokenId) public onlyOwner {
        _burn(tokenId);
    }

    // Disable users from using the transferFrom function to transfer SBTs.
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(from == owner(), "Soulbound: Only owner can transfer");
        super.transferFrom(from, to, tokenId); // Call the _transfer implementation of the parent contract.
    }

    // Get the total number of current SBTs.
    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function setURI(string calldata newUri) public onlyOwner {
        uri = newUri;
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        return uri;
    }

    function approve(address to, uint256 tokenId) public virtual override {
        revert("Soulbound: Approve not allowed");
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        revert("Soulbound: SetApprovalForAll not allowed");
    }
}
