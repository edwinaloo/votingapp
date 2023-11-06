const options = [
  { text: "Pascal Omollo", votes: 0 },
  { text: "Emily Sarina", votes: 0 },
  { text: "Augastine Mwangi", votes: 0 },
];

const optionsContainer = document.getElementById("options");
const voteButton = document.getElementById("voteButton");

// Simulated user data (for educational purposes)
const users = [
  { username: "user1", hasVoted: false },
  { username: "user2", hasVoted: false },
];

let currentUser = null; // Represents the logged-in user

// Function to display options
function displayOptions() {
  optionsContainer.innerHTML = "";
  options.forEach((option, index) => {
      const optionDiv = document.createElement("div");
      optionDiv.innerHTML = `
          <label>
              <input type="radio" name="vote" value="${index}">
              ${option.text}
          </label>
      `;
      optionsContainer.appendChild(optionDiv);
  });
}

// Function to handle votes
function handleVote() {
  if (currentUser && !currentUser.hasVoted) {
      const selectedOption = document.querySelector('input[name="vote"]:checked');
      if (selectedOption) {
          const index = parseInt(selectedOption.value, 10);
          options[index].votes += 1;
          currentUser.hasVoted = true;
          displayOptions();
          voteButton.disabled = true; // Disable the button after voting
      }
  }
}

// Simulated login function (for educational purposes)
function login(username) {
  currentUser = users.find(user => user.username === username);
  if (currentUser) {
      voteButton.disabled = currentUser.hasVoted;
  }
}

// Add an event listener to the "Vote" button
voteButton.addEventListener("click", handleVote);

// Call the displayOptions function to initialize the options
displayOptions();
