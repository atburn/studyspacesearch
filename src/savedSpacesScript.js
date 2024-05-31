import { executeSQL } from "./DatabaseHandler.js"

const userId = window.sessionStorage.getItem('userId');


if (!userId) {
    document.location.href = "login.html";
}


async function getSavedUserSpaces() {
    const sql = `SELECT * FROM SAVED_SPACE JOIN SPACE ON SAVED_SPACE.space_id = SPACE.id WHERE SAVED_SPACE.user_id = '${userId}';`
    const savedSpaces = await executeSQL(sql);
    
    
    const savedSpaceDisplay = document.getElementById('saved-space-display');

    if (savedSpaces.length === 0) {
        const html = `
            <h3>No saved spaces.x</h3>
        `;
        savedSpaceDisplay.insertAdjacentHTML('beforeend', html);


    }


    for (let i = 0; i < savedSpaces.length; i++) {
        const space = savedSpaces[i];
        const html = `
            <div style="display: flex; padding: 10px">
                <img src="${space.image}" width="250" height="150" />

                <div style="padding: 15px" class='space-info'>
                    <h3><a style='text-decoration: none' href='./space.php?id=${space.id}'>${space.name}</a></h3>
                    <p>${space.building}</p>                    
                    <p>${space.address}</p>
                    <button class='loginB' style='margin: 0; font-size: 1em; margin-top: 10px' id='remove-button-${i}'>Remove</button>
                </div>

            </div>
        `;
        savedSpaceDisplay.insertAdjacentHTML('beforeend', html);

        const removeButton = document.getElementById(`remove-button-${i}`);
        
        removeButton.addEventListener("click", async () => {
            const sql = `DELETE FROM SAVED_SPACE WHERE user_id = '${userId}' AND space_id = '${space.id}'`;

            await executeSQL(sql);

            window.location.reload();

        })
    }
}
getSavedUserSpaces();