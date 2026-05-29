// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NftCollection {

    string public name;
    string public symbol;

    uint256 public maxSupply;
    uint256 public totalSupply;

    address public admin;

    string private _baseTokenURI = "https://example.com/metadata/";

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply
    ) {
        name = _name;
        symbol = _symbol;
        maxSupply = _maxSupply;
        admin = msg.sender;
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Token does not exist");
        return owner;
    }

    function safeMint(address to, uint256 tokenId) public onlyAdmin {
        require(totalSupply < maxSupply, "Max supply reached");
        _mint(to, tokenId);
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "Mint to zero");
        require(_owners[tokenId] == address(0), "Already minted");

        _owners[tokenId] = to;
        _balances[to] += 1;
        totalSupply += 1;
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved");
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory
    ) public {
        transferFrom(from, to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "Not owner");
        require(to != address(0), "Zero address");

        delete _tokenApprovals[tokenId];

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
    }

    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "Not authorized"
        );
        _tokenApprovals[tokenId] = to;
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
    }

    function isApprovedForAll(address owner, address operator)
        public
        view
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        address owner = ownerOf(tokenId);
        return (
            spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender)
        );
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return string(
            abi.encodePacked(_baseTokenURI, _toString(tokenId), ".json")
        );
    }

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + value % 10));
            value /= 10;
        }
        return string(buffer);
    }
}