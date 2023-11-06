const options = [
  { text: "Pascal Omollo", votes: 0 },
  { text: "Edwin Aloo", votes: 0 },
  { text: "Augastine mwangi", votes: 0 },
];

const optionsContainer = document.getElementById("options");
const voteButton = document.getElementById("voteButton");

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
  const selectedOption = document.querySelector('input[name="vote"]:checked');
  if (selectedOption) {
      const index = parseInt(selectedOption.value, 10);
      options[index].votes += 1;
      displayOptions();
      selectedOption.checked = false;
  }
}

displayOptions();
voteButton.addEventListener("click", handleVote);
