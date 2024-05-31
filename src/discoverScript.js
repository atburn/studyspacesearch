import { executeSQL } from "./DatabaseHandler.js"


document.getElementById('filter-search-b').addEventListener('click', () => {
    getOption();
});

async function getOption() {
    const selectOwner = document.getElementById('filter-select-owner');
    const owner = selectOwner.value;
    var sqlQueryExt = "";

    if(!owner.includes("Select")){
        sqlQueryExt = " WHERE owner_id = " + owner;
    }

    const selectResource = document.getElementById('filter-select-resource');
    const resource = selectResource.value;

    if(!resource.includes("Select")){
        if(sqlQueryExt.includes(" WHERE")) {
            sqlQueryExt += " AND EXISTS( SELECT * FROM SPACE_RESOURCE AS SR WHERE SR.space_id = SPACE.id AND SR.name = '" + resource + "');";
        } else{
            sqlQueryExt += " WHERE EXISTS( SELECT * FROM SPACE_RESOURCE AS SR WHERE SR.space_id = SPACE.id AND SR.name = '" + resource + "');";
        }
    }
    
    const spaceTable = document.getElementById('space-table-body');
    
    // While loop taken from Adam's answer on the question "Delete all rows in an HTML table except for header with JS":
    // https://stackoverflow.com/questions/48468672/delete-all-rows-in-an-html-table-except-for-header-with-js
    while (spaceTable.firstChild) {
        spaceTable.removeChild(spaceTable.firstChild);
    }

    const sql = `SELECT * FROM SPACE` + sqlQueryExt;
    const spaces = await executeSQL(sql);

    for (let i = 0; i < spaces.length; i++) {
        const space = spaces[i];
        const newRow = spaceTable.insertRow(spaceTable.rows.length);
        newRow.innerHTML = `
            <tr>
                <td><a href="./space.php?id=${space.id}">${space.name}</a></td>
                <td>${space.address}</td>
                <td>${space.building}</td>
                <td>${space.hours}</td>  
            </tr>
        `;
    } 
}

getOption()




