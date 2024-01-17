// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    address owner;
    mapping(address => bool) public voters;
    //creates map to check if the voter has voted 

    uint256 public votingStart;
    uint256 public votingEnd;

constructor(string[] memory _candidateNames, uint256 _durationInMinutes) {
    for (uint256 i = 0; i < _candidateNames.length; i++) {
        candidates.push(Candidate({
            name: _candidateNames[i],
            voteCount: 0
        }));
    }
    owner = msg.sender;
    votingStart = block.timestamp;  //timestamp of a particular block in blockchain 
    votingEnd = block.timestamp + (_durationInMinutes * 1 minutes);
}
//only the owner of the contract can execute the function.
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

   
 // allow candidate to vote 
    function vote(uint256 _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateIndex < candidates.length, "Invalid candidate index.");

        candidates[_candidateIndex].voteCount++;
        voters[msg.sender] = true;
    }
     // retrives all candidates and votecount 
    function getAllVotesOfCandiates() public view returns (Candidate[] memory){
        return candidates;
    }
// check if voting is open 
    function getVotingStatus() public view returns (bool) {
    return (block.timestamp >= votingStart && block.timestamp < votingEnd);
}

    function getRemainingTime() public view returns (uint256) {
        require(block.timestamp >= votingStart, "Voting has not started yet.");
        if (block.timestamp >= votingEnd) {
            return 0;
        }
        return votingEnd - block.timestamp;
}
}


