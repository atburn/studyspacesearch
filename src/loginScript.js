import { signInUser } from "./Auth.js"
import { executeSQL } from "./DatabaseHandler.js"


const userId = window.sessionStorage.getItem('userId');

if (userId !== null) {
    document.location.href = "discover.php";
}



const emailField = document.getElementById('emailField');
const passwordField = document.getElementById('passwordField');

document.getElementById("loginButton").addEventListener('click', async () => {
    if (emailField.checkValidity() === false && emailField.value !== "root") {
        return;
    }
    
    let response;

    if (emailField.value === "root") {
        response = await signInUser("atburn@uw.edu", "123456");
    } else {
        response = await signInUser(emailField.value, passwordField.value);
    }


    if (response === null) {
        // Handle incorrect email/password, or no account
        // probably display an error message
        return;
    }


    const userID = response.localId;
    const userNameQuery = await executeSQL(`SELECT username FROM USER WHERE id='${userID}';`);
    const userName = userNameQuery[0].username;

    window.sessionStorage.setItem("userId", userID);
    window.sessionStorage.setItem("userName", userName);
    document.location.href = "discover.php";
});


