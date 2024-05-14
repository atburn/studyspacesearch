
const WEB_API_KEY = 'AIzaSyDQMRSzvVDZyoZxvfDWaKoeX-cfADfamfo'; // This should be fine to leave out? Not 100% sure




// This is what Firebase returns when signing-in an EXISTING user.f
// Only the localId field is important.
const EXAMPLE_SIGNIN_RESPONSE_BODY = {
    displayName: "",
    email: "atburn@uw.edu",
    idToken: "<long irrelevent string>",
    kind: "identitytoolkit#VerifyPasswordResponse",
    localId: "M8L2A4YtHBQOkV9NODqjo2mmbTJ2", // IMPORTANT
    refreshToken: "<long irrelevent string>",
    registered: true
}



/**
 * Signs in the user.
 * 
 * Currently, returns the whole response body. We can change it 
 *  to only return the userId, or null if there is an error if we feel
 *  that is important.
 * 
 * @see EXAMPLE_SIGNIN_RESPONSE_BODY
 * @param {*} email 
 * @param {*} password 
 * @returns A response body. See EXAMPLE_SIGNIN_RESPONSE_BODY. 
 */
async function signInUser(email, password) {
    const loginEndpoint = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${WEB_API_KEY}`;
    const rawResponse = await fetch(loginEndpoint, {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            email: email,
            password: password,
            returnSecureToken: true
        })
    });
    const content = await rawResponse.json();
    return content
}

/**
 * Registers a new user.
 * 
 * Currently, returns the whole response body;
 *  however, we may not need the whole body later.
 * 
 * @see EXAMPLE_SIGNUP_RESPONSE_BODY
 * @param {*} userName 
 * @param {*} email 
 * @param {*} passsword 
 * @returns the response body.
 */
async function registerUser(userName, email, passsword) {
    const response = await _registerUserInFirebase(email, passsword);
    if (response.error !== undefined) {
        // Handle different errors here? 

        console.error(response)

        // if (response.message === "EMAIL_EXISTS") {
        //     return null;
        // }
        return null
    }



    const userId = response.localId;

    const sql = `INSERT INTO USER VALUES (${userId}, ${userName}, "Some hash", "Salt", ${email});`;
    // TODO: Insert into database


    return response // or something
}



// This is what Firebase returns when signing up a new user.
// Realistically, only the localId field is important.
const EXAMPLE_SIGNUP_RESPONSE_BODY = {
    email: "test@test.com",
    expiresIn: "3600",
    idToken: "<long irrelevent string>",
    kind: "identitytoolkit#SignupNewUserResponse",
    localId: "J8WMcojlpngJhmTYgRaFEqf0Y7f1", // IMPORTANT
    refreshToken: "<long irrelevent string>"
}

/**
 * Registers the user in Firebase. Should not be called directly, as
 *  a row needs to be inserted into the database when this is called.
 * 
 * @see EXAMPLE_SIGNUP_RESPONSE_BODY
 * @param {*} email 
 * @param {*} password 
 * @returns 
 */
async function _registerUserInFirebase(email, password) {
    const signUpEndpoint = `https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${WEB_API_KEY}`;
    const rawResponse = await fetch(signUpEndpoint, {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            email: email,
            password: password,
            returnSecureToken: true
        })
    });
    const content = await rawResponse.json();

    return content
}



// To verify this works:
// Uncomment the next couple lines and check dev console.

// signInUser("atburn@uw.edu", "123456").then(response => {
//     console.log(response)
// });

// registerUser("testUser", "test@test.com", "123456").then(response => {
//     console.log(response)
// })




