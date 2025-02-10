// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Election {
    // Structure to store candidate details
    struct Candidate {
        uint256 id; 
        string name; 
        uint256 voteCount; 
    }

    struct Voter {
        bool authorized; 
        bool voted; 
        uint256 vote; 
    }

    mapping(uint256 => Candidate) public candidates;
    mapping(address => Voter) public voters;
    uint256 public candidatesCount;
    address public owner;

    event CandidateAdded(uint256 indexed candidateId, string name);
    event VoterAuthorized(address indexed voter);
    event VoteCast(address indexed voter, uint256 indexed candidateId);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }
    function addCandidate(string memory _name) external onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);

        emit CandidateAdded(candidatesCount, _name);
    }
    function authorizeVoter(address _voter) external onlyOwner {
        require(!voters[_voter].authorized, "Voter is already authorized");
        voters[_voter].authorized = true;

        emit VoterAuthorized(_voter);
    }
    function vote(uint256 _candidateId) external {
        Voter storage sender = voters[msg.sender];
        require(sender.authorized, "You are not authorized to vote");
        require(!sender.voted, "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate");

        sender.voted = true;
        sender.vote = _candidateId;

        candidates[_candidateId].voteCount++;

        emit VoteCast(msg.sender, _candidateId);
    }
    function getCandidateCount() external view returns (uint256) {
        return candidatesCount;
    }
    function getCandidate(uint256 _candidateId) external view returns (uint256, string memory, uint256) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }
}