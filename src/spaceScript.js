import { executeSQL } from "./DatabaseHandler.js"

// ------------------------------ Header -------------------------
const userId = window.sessionStorage.getItem('userId');


const urlParams = new URLSearchParams(window.location.search);
const spaceId = urlParams.get('id');


if (userId) {
    // Attach slider events to the comments
    document.getElementById('comment-area').classList.toggle("hidden");

    const elementIds = [["noise-level", 3], ['availability', 3], ['busyness', 3]]

    for (const tuple of elementIds) {
        const id = tuple[0];
        const slider = document.getElementById(id + "-input");
        const label = document.getElementById(id + "-display");


        slider.oninput = () => {
            label.innerText = `${slider.value}/5`;
            tuple[1] = slider.value
        }
    }
    
    document.getElementById('comment-button').addEventListener('click', async () => {
        const noiseLevel = elementIds[0][1];
        const availability = elementIds[1][1];
        const busyness = elementIds[2][1];
        const comment = document.getElementById('comment-input').value.replace("\n", " ");

        const sql = `INSERT INTO USER_COMMENT VALUES ('${spaceId}', '${noiseLevel}', '${availability}', '${busyness}' , '${comment}', '${userId}', '${new Date().toISOString().substring(0, 16)}');`
    
        await executeSQL(sql);

        location.reload();
    })
}







// Load user comments
(async () => {
    const spaceName = await executeSQL(`SELECT name FROM SPACE WHERE id = '${spaceId}';`);

    document.title = "Study Space Search - " + spaceName[0].name;


    const commentBox = document.getElementById('recent-activity-box');

    const comments = await executeSQL(`SELECT * FROM USER_COMMENT JOIN USER ON USER.id = USER_COMMENT.user_id WHERE space_id = '${spaceId}' ORDER BY timestamp DESC;`);
    if (comments.length === 0) {
        const html = `<p>No recent activity.</p>`;
        commentBox.insertAdjacentHTML('beforeend', html);
        return;
    }

    

    let commentId = 0;
    for (const comment of comments) {
        
        let addedRemoveButton = false;
        const getRemovableButton = () => {
            if (comment.user_id === userId) {
                addedRemoveButton = true;
                commentId++;
                return `<h3 class='remove-comment-button' id='remove-button-${commentId}' style='text-align: right; width: 50%; display: inline-block;'>X<h3>`;
            }
            return '';
        }

        const date = new Date(Date.parse(comment.timestamp)).toLocaleString();

        const html = `
            <div class='comment'>
                <div>
                    <h3 style="text-align: left; width:49%; display: inline-block;">${comment.username}</h3>
                    ${getRemovableButton()}
                </div>

                <p>${date}</p>
                <br/>
                <p>${comment.user_remark}</p>
                <div class="comment-rating">
                    <div>
                        <h4>Noise Level</h4>
                        <h4>${comment.noise}/5</h4>
                    </div>
                    <div>
                        <h4>Availability</h4>
                        <h4>${comment.availability}/5</h4>
                    </div>
                    <div>
                        <h4>Busyness</h4>
                        <h4>${comment.busyness}/5</h4>
                    </div>
                </div>      
            </div>
        `;

        commentBox.insertAdjacentHTML('beforeend', html);
        
        if (addedRemoveButton) {
            const removeButton = document.getElementById(`remove-button-${commentId}`);
            removeButton.addEventListener("click", async () => {
                const sql = `DELETE FROM USER_COMMENT WHERE space_id = ${comment.space_id} AND user_id = '${comment.user_id}' AND timestamp = '${comment.timestamp}'`;
                await executeSQL(sql);
                location.reload();
            });
        }
    }
})();







(async () => {
    const saveButton = document.getElementById('save-button');

    if (userId) {
        const checkIfSaved = await executeSQL(`SELECT * FROM SAVED_SPACE WHERE user_id = '${userId}' and space_id = ${spaceId};`);
        if (checkIfSaved.length > 0) { // Not saved
            saveButton.innerText = "Unsave";
            saveButton.addEventListener('click', async () => {
                const sql = `DELETE FROM SAVED_SPACE WHERE user_id = '${userId}' AND space_id = '${spaceId}'`;

                const response = await executeSQL(sql);
                location.reload()
            });
            
            return;
        }
    }

    saveButton.addEventListener('click', async () => {
        if (!userId) { // User isn't logged in
            document.location.href = "login.html";
            return;
        }

        const sql = `INSERT INTO SAVED_SPACE VALUES ('${userId}', '${spaceId}');`;

        const response = await executeSQL(sql);
        location.reload()

    });


})();









