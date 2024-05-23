const nameField = document.getElementById('nameField');
const emailField = document.getElementById('emailField');
const passwordField = document.getElementById('passwordField');

document.getElementById('signUpButton').addEventListener('click', async () => {
    if (!nameField.checkValidity() || !emailField.checkValidity()) {
        return;
    }

    const response = await registerUser(nameField.value, emailField.value, passwordField.value);
    if (response === null) {
        // Handle some error.
        // probably display an error message
        return;
    }

    const userID = response.localId;

    window.sessionStorage.setItem("userId", userID);
    document.location.href = "index.html";
});