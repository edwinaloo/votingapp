// Function to display options
function displayOptions() {
    // Simulated data for options
    const optionsData = [
        { id: 1, text: "Option 1", votes: 0 },
        { id: 2, text: "Option 2", votes: 0 },
        { id: 3, text: "Option 3", votes: 0 },
    ];

    const optionsContainer = document.getElementById("options");

    optionsData.forEach((option) => {
        const optionDiv = document.createElement("div");
        optionDiv.innerHTML = `
            <label>
                <input type="radio" name="vote" value="${option.id}">
                ${option.text}
            </label>
        `;
        optionsContainer.appendChild(optionDiv);
    });
}

// Function to handle votes
function handleVote() {
    const selectedOption = document.querySelector('input[name="vote"]:checked');
    if (selectedOption) {
        const optionId = parseInt(selectedOption.value, 10);
        // Simulated vote submission (replace with actual logic)
        console.log(`Voted for option ${optionId}`);
    } else {
        console.log("Please select an option before voting.");
    }
}

// Function to display user comments and discussions
function displayComments() {
    // Simulated data for comments
    const commentsData = [
        { username: "User1", comment: "This is great!" },
        { username: "User2", comment: "I love it!" },
        { username: "User3", comment: "Not bad." },
    ];

    const commentsContainer = document.getElementById("comments");

    commentsData.forEach((comment) => {
        const commentDiv = document.createElement("div");
        commentDiv.innerHTML = `<strong>${comment.username}:</strong> ${comment.comment}`;
        commentsContainer.appendChild(commentDiv);
    });
}

// Function to display the leaderboard
function displayLeaderboard() {
    // Simulated data for the leaderboard
    const leaderboardData = [
        { rank: 1, option: "Option 1", votes: 10 },
        { rank: 2, option: "Option 2", votes: 8 },
        { rank: 3, option: "Option 3", votes: 5 },
    ];

    const leaderboardContainer = document.getElementById("leaderboard");

    leaderboardData.forEach((entry) => {
        const entryDiv = document.createElement("div");
        entryDiv.innerHTML = `<strong>${entry.rank}. ${entry.option}:</strong> ${entry.votes} votes`;
        leaderboardContainer.appendChild(entryDiv);
    });
}

// Event listener for the Vote button
const voteButton = document.getElementById("voteButton");
voteButton.addEventListener("click", handleVote);

// Initialize the UI with options, comments, and leaderboard
displayOptions();
displayComments();
displayLeaderboard();
