// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./CowlDaoTokenOne.sol";

/**
 * @title CowlDaoToken
 * @dev This contract manages the staking, proposals, delegations, and governance levels of the token holders.
 */
contract CowlDaoTokenTwo is CowlDaoTokenOne {
    // ** Administrative Functions **
    function setMinStakeToPropose(
        uint256 _minStakeToPropose
    ) external onlyAdmin {
        minStakeToPropose = _minStakeToPropose;
        emit MinStakeToProposeChanged(_minStakeToPropose);
    }

    function setGovernanceLevel(
        address holder,
        GovernanceLevel newLevel
    ) external onlyAdmin {
        governanceLevels[holder] = newLevel;
        emit GovernanceLevelChanged(holder, newLevel);
    }

    // ** Staking and Reward Distribution Functions **

    function stake(uint256 amount) external nonReentrant stopInEmergency {
        _burn(msg.sender, amount); // Remove the staked tokens from circulation
        stakers[msg.sender].amount += amount;
        stakers[msg.sender].timestamp = block.timestamp;

        // Reward users based on stake amount and duration
        uint256 reward = calculateReward(msg.sender);
        _mint(msg.sender, reward); // Mint new tokens as rewards
        rewardPool -= reward; // Reduce the rewardPool balance

        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external nonReentrant stopInEmergency {
        require(stakers[msg.sender].amount >= amount, "Not enough staked");

        uint256 penalty = 0;
        if (block.timestamp < stakers[msg.sender].timestamp + lockPeriod) {
            penalty = amount / 10; // 10% penalty if within lock period
        }

        uint256 amountAfterPenalty = amount - penalty;
        _mint(msg.sender, amountAfterPenalty); // Return the unstaked tokens to circulation
        stakers[msg.sender].amount -= amount;

        emit Unstaked(msg.sender, amountAfterPenalty);
    }

    function calculateReward(address staker) internal view returns (uint256) {
        StakeInfo memory info = stakers[staker];
        uint256 timeElapsed = block.timestamp - info.timestamp;
        uint256 reward = (info.amount * timeElapsed) / 31536000;
        return reward;
    }

    // ** Proposal Creation and Execution Functions **
    function propose(
        address _contractAddress,
        bytes memory _callData,
        string memory description
    ) external {
        require(
            stakers[msg.sender].amount >= minStakeToPropose,
            "Insufficient staked amount"
        );

        Proposal memory newProposal = Proposal({
            contractAddress: _contractAddress,
            callData: _callData,
            description: description,
            forVotes: 0,
            againstVotes: 0,
            endTime: block.timestamp + proposalVotingDuration,
            executed: false
        });

        proposals.push(newProposal);
        emit ProposalCreated(proposals.length - 1, msg.sender, description);
    }

    function vote(uint256 proposalId, bool support) external stopInEmergency {
        require(!voters[proposalId][msg.sender], "Already voted");
        voters[proposalId][msg.sender] = true;

        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp < proposal.endTime, "Voting period ended");

        uint256 weight = votingPower[msg.sender];
        if (support) proposal.forVotes += weight;
        else proposal.againstVotes += weight;

        emit Voted(msg.sender, proposalId, support);
    }

    function executeProposal(uint256 proposalId) external stopInEmergency {
        Proposal storage proposal = proposals[proposalId];
        require(
            block.timestamp >= proposal.endTime,
            "Voting period not over yet"
        );
        require(!proposal.executed, "Prop has already been exec");
        require(proposal.forVotes > proposal.againstVotes, "Prop did not pass");

        (bool success, ) = proposal.contractAddress.call(proposal.callData);
        require(success, "Execution failed");

        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }

    // ** Delegation and Governance Level Functions **

    function delegate(address delegatee) external stopInEmergency {
        require(msg.sender != delegatee, "Cannot del to self");
        require(delegates[msg.sender] != delegatee, "Already del to this addr");

        // Delegation logic here (updating delegatee's voting power etc.)

        emit DelegateChanged(msg.sender, delegatee, balanceOf(msg.sender));
    }

    function delegateRequest(address delegatee) external stopInEmergency {
        require(msg.sender != delegatee, "Cannot delegate to self");
        delegateRequests[msg.sender] = delegatee;
        emit DelegateRequest(msg.sender, delegatee);
    }

    function acceptDelegateRequest(address delegator) external stopInEmergency {
        require(
            delegateRequests[delegator] == msg.sender,
            "No del req from this addr"
        );

        delegates[delegator] = msg.sender;
        delete delegateRequests[delegator];

        emit DelegateChanged(delegator, msg.sender, balanceOf(delegator));
    }

    function getProposal(
        uint256 proposalId
    ) external view returns (Proposal memory) {
        return proposals[proposalId];
    }

    function totalProposals() external view returns (uint256) {
        return proposals.length;
    }

    function isDelegatee(
        address delegator,
        address delegatee
    ) external view returns (bool) {
        return delegates[delegator] == delegatee;
    }

    receive() external payable {}
}
