import { Actor, HttpAgent } from '@dfinity/agent';
import { myproject_backend } from '/src/myproject_backend/main.mo'; // Update the path

const canisterId = 'bw4dl-smaaa-aaaaa-qaacq-cai';

const agent = new HttpAgent();
const canister = Actor.createActor(myproject_backend, { agent, canisterId });

document.addEventListener("DOMContentLoaded", function () {
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

    // Event listener for the Vote button
    const voteButton = document.getElementById("voteButton");
    voteButton.addEventListener("click", handleVote);

    // Function to handle votes
    async function handleVote() {
        const selectedOption = document.querySelector('input[name="vote"]:checked');
        if (selectedOption) {
            const optionId = parseInt(selectedOption.value, 10);
            
            // Simulated vote submission (replace with actual logic)
            const result = await canister.voteFunction(optionId);
            console.log(result);

            // Update UI or perform additional actions based on the result
        } else {
            console.log("Please select an option before voting.");
        }
    }
});
