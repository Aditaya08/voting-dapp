module test::voting {
    use std::signer;
    use std::vector;

    struct Vote {
        voter: address,
        candidate: u64,
    }

    struct VotingSystem {
        votes: vector<Vote>,
        candidates: vector<u64>,
    }

    public fun initialize(candidates: vector<u64>): VotingSystem {
        VotingSystem {
            votes: vector::empty<Vote>(),
            candidates,
        }
    }

    public fun cast_vote(voting_system: &mut VotingSystem, signer: &signer, candidate: u64) {
        let voter = signer::address_of(signer);
        let vote = Vote { voter, candidate };
        vector::push_back(&mut voting_system.votes, vote);
    }

    public fun tally_votes(voting_system: &VotingSystem): vector<u64> {
        let results = vector::empty<u64>();
        let num_candidates = vector::length(&voting_system.candidates);
        let i = 0;
        while (i < num_candidates) {
            vector::push_back(&mut results, 0);
            i = i + 1;
        };

        let num_votes = vector::length(&voting_system.votes);
        let j = 0;
        while (j < num_votes) {
            let vote = vector::borrow(&voting_system.votes, j);
            let candidate_index = vote.candidate;
            let count = vector::borrow_mut(&mut results, candidate_index);
            *count = *count + 1;
            j = j + 1;
        };

        results
    }
}