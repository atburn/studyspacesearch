const emailField = document.getElementById('emailField');
const passwordField = document.getElementById('passwordField');

document.getElementById("loginButton").addEventListener('click', async () => {
    if (emailField.checkValidity() === false) {
        return;
    }

    // Don't think we need to check the password field

    const response = await signInUser(emailField.value, passwordField.value);
    if (response === null) {
        // Handle incorrect email/password, or no account
        // probably display an error message
        return;
    }

    const userID = response.localId;

    window.sessionStorage.setItem("userId", userID);
    document.location.href = "index.html";

});

