// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GreenGold is ERC721, Ownable { 

    enum TreeN{
        MAHOGANY,
        ODUM,
        SAPELE,
        TEAK,
        ACACIA,
        WAWA
    }

    struct Tree{
        uint id;
        uint age;
        uint height;
        address owner;
        string treeName;
        string description;
        string location;
        uint plantingDate;
        uint maturityDate;
        uint maturityAmount;
        bool isSold;
    }

    uint public treeID;
    string [] public  treeNames;
    mapping (uint => Tree ) public  trees;
    mapping (address => Tree []) public treesByOwner;

    constructor(address initialOwner) ERC721("GreenGold", "TREE") Ownable(initialOwner) {}

    function plantTree(uint _age, uint _height, uint treeNameIndex, string memory _description,  string memory _location) public  {
        treeID++;
        Tree memory newTree = Tree({
            id: treeID, 
            age: _age, 
            height: _height,
            owner: msg.sender,
            treeName: treeNames[treeNameIndex],
            description: _description, 
            location: _location,
            plantingDate: block.timestamp,
            maturityDate: block.timestamp + (5 * 365 * 24 * 60 * 60), // 5 years from now,
            maturityAmount: _height * (_age /3), 
            isSold: false
            });

             trees[treeID] = newTree;
             treesByOwner[msg.sender].push(newTree);

             _mint(msg.sender, newTree.id);
    }

    function updatePlantTree(uint _treeId, uint _height) public {
        trees[_treeId].height = _height;
        //  treesByOwner[msg.sender][0].id = 165493728 + (_treeId);
    }

    // function buyTree(uint _treeId) public  {
    //     require(!trees[_treeId].isSold, "This tree is already sold!");
    //      trees[_treeId].isSold = true;
    // }

    function treeName(string memory _treeName) public  returns (string[] memory) {
        treeNames.push(_treeName);
        return treeNames;
    }

    function getTreenames() public view  returns(string []memory){
        return treeNames;
     }

     function transferTree(address _to, uint _treeId) public {
        require(msg.sender == trees[_treeId].owner,"You do not own this Tree");
        _transfer(trees[_treeId].owner, _to, _treeId);
        // treesByOwner[_to][0] = trees[_treeId];
      //   delete trees[_treeId];
     }

     function getTreesByOwner(address _owner) public view  returns(Tree []memory){
        return treesByOwner[_owner];
    }

    // function buyTree(uint _id) public {
    //     require(_id > 0, "Invalid ID!");
    //    require(!trees[_id].isSold,"This Tree is already sold"); 
    //     treesByOwner[msg.sender][1] = trees[_id];
    //     delete trees[_id];
    // }
    
}

