import Principal "mo:base/Principal";
import Identity "dfx:mo:identity/Identity";
import Optional "mo:base/Optional";
import Tuple "dfx:mo/base/Tuple";

//define a voter structure
struct Voter {
    name:string;
    age:int;
    voted:bool;
}

//define a voter registry struct
struct VoterRegistry {
    voters: map<Principal, Voter>;
}

// define a choice structure
struct Choice {
    id:int;
    name: string;
    voteCount: int;
}

// define a poll structure
struct Poll {
    id:int;
    name: string;
    choices: map<int, Choice> ;
}

type Error = { #voterAlreadyVoted; #otherError };

//  function to verify a voter's identity
func verifyVoterIdentity(): Optional<bool> {
    // Get the current principal
    let principal: Principal = Identity.getPrincipal();

    //If the principal is not registered, return false
    if (!canister.state.VoterRegistry.voters.contains(principal)) {
        return Optional.some(false);
    }

    // Verify the principal's identity using the Internet Identity Client Library
    if (!Identity.verifyPrincipal(principal)) {
        return Optional.some(false);
    }

    // if the principal's identity is verified, return true;
    return Optional.some(true);
};

//function to create a new poll
func createPoll(poll: Poll): Unit {
    // Get the current state of the voter registry
    let voterRegistry = canister.state.voterRegistry;

    // Add the new poll to the state
    voterRegistry.polls[poll.id] = poll;

    //Update the state
    canister.state.voterRegistry = voterRegistry;
}

// Define a function to get all registered voters
func getAllRegisteredVoters(): []Voter {
    // Get the current state of the voter registry
    let voterRegistry = canister.state.voterRegistry;

    // Return a list of all registered voters
    return voterRegistry.voters.values;
}

//function to register a vote for a given poll and choice
func registerVote(pollId : int, choiceId: int) : Result<Unit, Error> {
    //verify the voter's identity
    let verificationResult: Optional<bool> = verifyVoterIdentity();

    if (!verificationResult.unwrap()) {
        return #err(#otherError);
    }

    // Get the current state of the voter registry
    let voterRegistry: VoterRegistry = canister.state.voterRegistry;

    // Get voter
    let voter: Voter = canister.state.voterRegistry.voters[Identity.getPrincipal()];

    //Ensure that the voter has not already voted in this poll
    if (voter.voted) {
        return #err(#voterAlreadyVoted);

    }

    // Get the poll
    let poll: Poll = voterRegistry.polls[pollId];

    // Update the vote count fpr the chosen option
    poll.choices[choiceId].voteCount++;

    // mark voter as having voted
    voter.voted = true;

    //update the state
    canister.state.voterRegistry = voterRegistry;

    return #ok();
};

// function to get the votes casted for each option in a poll
func getPollVoteCounts(pollId : int) : map<int, int> {

    // get the poll
    let poll = canister.state.voterRegistry.polls[pollId];

    // check if the poll exists
    if(!poll) {
        return {};
        // error: poll not found 
    }

    // create a map to store the vote counts
    let voteCounts: map<int, int> = {};

    // iterate over the poll choices and get te vote count for each
    for (let choiceId in poll.choices) {
        voteCounts[choiceId] = poll.choices[choiceId].voteCount;
    }

    // return map of vote counts
    return voteCounts;
    
};

export {verifyVoterIdentity, createPoll, getAllRegisteredVoters, registerVote, getPollVoteCounts }
