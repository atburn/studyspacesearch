import { executeSQL } from "./DatabaseHandler.js"

function highlightPosWord(comment) {
    var origC = comment;
    let posWords = ['nice', 'great', 'good', 'wonderful', 'love', 'like']
    var posWordIndex = 0;
    var posWord = "";
    
    // Find where the positive word is
    for(var i = 0; i < posWords.length; i++){
        var index = origC.toLowerCase().indexOf(posWords[i])
        if (index !== -1) {
            posWordIndex = index;
            posWord = posWords[i];
            break;
        }
    }
    
    const highlightedC = origC.slice(0, posWordIndex) + '<span style="font-weight: bold;">' + origC.slice(posWordIndex, posWordIndex + posWord.length) + '</span>' + origC.slice(posWordIndex + posWord.length);

    return highlightedC;
}

async function getPraisedPlaces() {
    const spaceTable = document.getElementById('space-table-body');

    const sql = `SELECT
                    S.image,
                    S.id,
                    S.name,
                    S.address,
                    U.username,
                    UC.user_remark
                FROM
                    SPACE AS S
                JOIN USER_COMMENT AS UC
                ON
                    S.id = UC.space_id
                JOIN \`USER\` AS U
                ON
                    UC.user_id = U.id
                WHERE(
                        UC.user_remark LIKE '%nice%' 
                	OR UC.user_remark LIKE '%great%' 
                	OR UC.user_remark LIKE '%good%' 
                	OR UC.user_remark LIKE '%wonderful%' 
                	OR UC.user_remark LIKE '%love%' 
                	OR UC.user_remark LIKE '%like%'
                    ) AND UC.user_remark NOT IN(
                        SELECT
                            USER_COMMENT.user_remark
                        FROM
                            USER_COMMENT
                        WHERE
                            USER_COMMENT.user_remark LIKE '%not nice%' 
	                        OR USER_COMMENT.user_remark LIKE '%n\\'t nice%' 
	                        OR USER_COMMENT.user_remark LIKE '%not great%' 
	                        OR USER_COMMENT.user_remark LIKE '%n\\'t great%' 
	                        OR USER_COMMENT.user_remark LIKE '%not good%' 
	                        OR USER_COMMENT.user_remark LIKE '%n\\'t good%' 
	                        OR USER_COMMENT.user_remark LIKE '%not wonderful%' 
	                        OR USER_COMMENT.user_remark LIKE '%n\\'t wonderful%' 
	                        OR USER_COMMENT.user_remark LIKE '%not love%' 
	                        OR USER_COMMENT.user_remark LIKE '%n\\'t love%' 
	                        OR USER_COMMENT.user_remark LIKE '%not like%' 
	                        OR USER_COMMENT.user_remark LIKE '%n\\'t like%'
);
                `;
    const spaces = await executeSQL(sql);

    for (let i = 0; i < spaces.length; i++) {
        const space = spaces[i];
        const newRow = spaceTable.insertRow(spaceTable.rows.length);
        const highlightedComment = highlightPosWord(space.user_remark);

        // Note: While the variable is named "space", it's not the SPACE relation. It's actually referring
        // to the JSON object and contains the attributes stated in the SQL query.
        newRow.innerHTML = `
            <tr>
                <td><img src="${space.image}" width="250" height="150" /></td>
                <td><a href="./space.php?id=${space.id}">${space.name}</a></td>
                <td>${space.address}</td>
                <td>${space.username}</td>
                <td>${highlightedComment}</td>
            </tr>
        `;
    } 
}

// Run when page loads
getPraisedPlaces()




