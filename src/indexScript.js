
const userId = window.sessionStorage.getItem('userId')
console.log(userId)

document.getElementById('signOutButton').addEventListener('click', () => {
    window.sessionStorage.removeItem('userId');
    window.location.reload();
});




// If the user is already signed in, show "Logged in as:" instead of login/signup buttons
document.getElementById(userId !== null ? 'notSignedInButtons' : "signedInButtons").hidden = true;

if (userId) {
    const loggedInText = document.getElementById('loggedInAsText');
    // const userName = TODO: Query database for user name.


    loggedInText.innerHTML = "Logged in as: " + userId;
    // loggedInText.innerHTML = "Logged in as: " + userName;
}

