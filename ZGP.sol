// File: contracts/oft.sol

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

/// @notice OFT is an ERC-20 token that extends the OFTCore contract.
// MINT ZGP
contract ZGP is ERC20, EIP712 {

    struct Mint{
        address account;
        uint256 amount;
    }

    bytes32 public constant MINT_TYPEHASH = keccak256("Mint(address account,uint256 amount)");

    address public expectedSigner; 

    constructor(string memory name, string memory symbol) ERC20(name, symbol) EIP712 ("ZGP", "1") {
        expectedSigner = msg.sender;
    }

    function verify(Mint calldata mintData, bytes calldata signature) public returns (bool) {
        bytes32 structHash = keccak256(
            abi.encode(
                MINT_TYPEHASH,
                mintData.account,
                mintData.amount
            )
        );
        bytes32 digest = _hashTypedDataV4(structHash);
        bool isValid = SignatureChecker.isValidSignatureNow(expectedSigner, digest, signature);
        return isValid;
    }

    function mintZGP(Mint calldata mintData, bytes calldata signature) external {
        require(verify(mintData, signature), "Invalid access signature");
        _mint(mintData.account, mintData.amount);
    }


     function transfer(address to, uint256 amount) public virtual override returns (bool) {
        revert("do not support");
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        revert("do not support");
    }

}
