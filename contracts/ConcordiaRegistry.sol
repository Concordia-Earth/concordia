// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ConcordiaRegistry {
    struct Proposal {
        uint256 id;
        string ipfsMetadataHash;
        uint256 startTime;
        uint256 endTime;
        bool active;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    event ProposalCreated(uint256 indexed id, string ipfsMetadataHash, uint256 startTime, uint256 endTime);

    function createProposal(string memory _ipfsMetadataHash, uint256 _startTime, uint256 _endTime) external {
        require(_startTime < _endTime, "El tiempo de inicio debe ser anterior al final");
        
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            ipfsMetadataHash: _ipfsMetadataHash,
            startTime: _startTime,
            endTime: _endTime,
            active: true
        });

        emit ProposalCreated(proposalCount, _ipfsMetadataHash, _startTime, _endTime);
    }
}
