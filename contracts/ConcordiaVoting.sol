// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ConcordiaRegistry.sol";

contract ConcordiaVoting {
    ConcordiaRegistry public registry;

    // Mapping para registrar si un nullifier ya ha votado en una propuesta específica: proposalId => (nullifierHash => bool)
    mapping(uint256 => mapping(bytes32 => bool)) public hasVoted;

    // Mapping para contabilizar los votos por opción: proposalId => (optionId => voteCount)
    mapping(uint256 => mapping(uint256 => uint256)) public votes;

    event VoteCast(uint256 indexed proposalId, uint256 indexed optionId);

    constructor(address _registryAddress) {
        registry = ConcordiaRegistry(_registryAddress);
    }

    function castVote(
        uint256 _proposalId, 
        uint256 _optionId, 
        bytes32 _nullifierHash, 
        bytes calldata _proof
    ) external {
        // Verificar que la propuesta existe y está en plazo
        (uint256 id, , uint256 startTime, uint256 endTime, bool active) = registry.proposals(_proposalId);
        require(id != 0, "La propuesta no existe");
        require(active, "La propuesta no esta activa");
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Fuera del periodo de votacion");

        // Evitar doble voto mediante el nullifier único generado en el cliente (ZKP)
        require(!hasVoted[_proposalId][_nullifierHash], "El votante ya ha emitido su voto");

        // TODO: Validar la prueba ZKP (_proof) utilizando un Verifier externo generado por circom/snarkjs

        // Registrar el voto
        hasVoted[_proposalId][_nullifierHash] = true;
        votes[_proposalId][_optionId]++;

        emit VoteCast(_proposalId, _optionId);
    }
}
