import { executeSQL } from "./DatabaseHandler.js"

const area = document.getElementById('recent-activity-area');

const dateOffsetMap = new Map([
    ["today", 0],
    ["week", 7],
    ["month", 31],
    ["all", -1]
]);



const periodSelector = document.getElementById('period-selector')
periodSelector.addEventListener("change", () => {
    getRecentActivities(dateOffsetMap.get(periodSelector.value)) 
});


getRecentActivities(0) 


async function getRecentActivities(dateOffset) {
    while (area.firstChild) {
        area.removeChild(area.lastChild);
    }
    

    const sql = `
        SELECT
            SPACE.*,
            recent_comments.*
        FROM(
            SELECT
                USER_COMMENT.space_id AS space_id,
                USER_COMMENT.noise,
                USER_COMMENT.availability,
                USER_COMMENT.busyness,
                USER_COMMENT.user_remark,
                USER_COMMENT.user_id,
                MAX(USER_COMMENT.timestamp) AS recent_comment
            FROM
                USER_COMMENT
            GROUP BY
                USER_COMMENT.space_id
            ) AS recent_comments
        RIGHT JOIN 
            SPACE 
        ON 
            SPACE.id = recent_comments.space_id
        ORDER BY recent_comments.recent_comment DESC;
    `

    const response = await executeSQL(sql);



    let addedSpaces = 0;

    // Yeah I know this is super ugly, but it works
    const prevWeek = new Date(new Date().setDate(new Date().getDate() - dateOffset))

    for (const space of response) {
        const date = new Date(Date.parse(space.recent_comment))

        if (space.recent_comment === null) {
            continue;
        }
        
        
        if (dateOffset != -1 && date < prevWeek) {
            continue;
        }
        addedSpaces++;


        const html = `
            <div style="display: flex; padding: 10px">
                <img src="${space.image}" width="250" height="150" />
            
                <div style="padding: 15px" class='space-info'>
                    <h3 style='margin: 0; padding: 0;'><a style='text-decoration: none;' href='./space.php?id=${space.id}'>${space.name}</a></h3>
                    <p style='margin: 0; padding: 0;'>At ${date.toLocaleString()}: </p>
                    <div style='display: flex'>
                        <div style='padding-left: 35px; text-align: center'>
                            <p>Noise Level</p>
                            <h3>${space.noise}/5</h3>
                        </div>
                        <div style='padding-left: 35px; text-align: center'>
                            <p>Availability</p>
                            <h3>${space.availability}/5</h3>
                        </div>
                        <div style='padding-left: 35px; text-align: center'>
                            <p>Busyness</p>
                            <h3>${space.busyness}/5</h3>
                        </div>

                    <div>

                </div>
            
            </div>
        `;
        area.insertAdjacentHTML('beforeend', html);
    }
    
    if (addedSpaces === 0) {
        const html = `
            <h3>No recent activity for this period.</h3>
        `;
        area.insertAdjacentHTML('beforeend', html);
    }
}



