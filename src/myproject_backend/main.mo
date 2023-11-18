import Principal "mo:base/Principal";
import Identity "dfx:mo:identity/Identity";
import Optional "mo:base/Optional";
import Result "mo:base/Result";
import Candid;

// Define your data structures
struct Voter {
    name: Text;
    age: Nat;
    voted: Bool;
};

struct VoterRegistry {
    voters: Map Principal Voter;
    polls: Map Nat Poll;
};

struct Choice {
    id: int;
    name: string;
    voteCount: int;
};

struct Poll {
    name: Text;
    choices: Map Nat Choice;
};

// Define the Error type
type Error = { #voterAlreadyVoted; #otherError };

// Initialize the voter registry
public shared(VoterRegistry) func initVoterRegistry() : async VoterRegistry {
    return VoterRegistry { voters = Map Principal Voter; polls = Map Nat Poll };
};

// Function to verify a voter's identity
public shared(Optional Bool) func verifyVoterIdentity() : async Optional Bool {
    // Get the current principal
    let principal: Principal = Identity.getPrincipal();

    // If the principal is not registered, return false
    if (!canister.state.voterRegistry.voters.contains(principal)) {
        return Optional.some(false);
    }

    // Verify the principal's identity using the Internet Identity Client Library
    if (!Identity.verifyPrincipal(principal)) {
        return Optional.some(false);
    }

    // If the principal's identity is verified, return true
    return Optional.some(true);
};

// Function to create a new poll
public shared(Unit) func createPoll(poll: Poll) : async Unit {
    // Get the current state of the voter registry
    let voterRegistry = canister.state.voterRegistry;

    // Add the new poll to the state
    voterRegistry.polls[poll.name] = poll;

    // Update the state
    canister.state.voterRegistry := voterRegistry;
};

// Function to get all registered voters
public query func getAllRegisteredVoters() : [Voter] {
    // Get the current state of the voter registry
    let voterRegistry = canister.state.voterRegistry;

    // Return a list of all registered voters
    return Array.from(voterRegistry.voters.values());
};

// Function to register a vote for a given poll and choice
public shared(Result Unit Error) func registerVote(pollName: Text, choiceId: Nat) : async Result Unit Error {
    // Verify the voter's identity
    let verificationResult: Optional Bool = verifyVoterIdentity();

    if (!verificationResult.unwrap()) {
        return Err(#otherError);
    }

    // Get the current state of the voter registry
    let voterRegistry: VoterRegistry = canister.state.voterRegistry;

    // Get the current principal
    let principal: Principal = Identity.getPrincipal();

    // Get the voter
    let voter: Voter = voterRegistry.voters[principal];

    // Ensure that the voter has not already voted in this poll
    if (voter.voted) {
        return Err(#voterAlreadyVoted);
    }

    // Get the poll
    let poll: Poll = voterRegistry.polls[pollName];

    // Update the vote count for the chosen option
    poll.choices[choiceId].voteCount += 1;

    // Mark the voter as having voted
    voter.voted = true;

    // Update the state
    canister.state.voterRegistry := voterRegistry;

    return Ok();
};

// Function to get the votes casted for each option in a poll
public query func getPollVoteCounts(pollName: Text) : Map Nat Nat {
    // Get the poll
    let poll = canister.state.voterRegistry.polls[pollName];

    // Check if the poll exists
    if (!poll) {
        return Map Nat Nat {};
        // Error: Poll not found
    }

    // Create a map to store the vote counts
    let voteCounts: Map Nat Nat = Map Nat Nat {};

    // Iterate over the poll choices and get the vote count for each
    for (let choiceId in poll.choices) {
        voteCounts[choiceId] := poll.choices[choiceId].voteCount;
    }

    // Return the map of vote counts
    return voteCounts;
};

// Export the functions
export {
    initVoterRegistry,
    verifyVoterIdentity,
    createPoll,
    getAllRegisteredVoters,
    registerVote,
    getPollVoteCounts
};
