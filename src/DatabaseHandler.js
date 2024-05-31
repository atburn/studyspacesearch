

export async function executeSQL(query) {
    const response = await fetch("databaseCall.php", { 
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            sql: query
        })
    });

    
    let content;
    try {
        content = await response.json();

        if (content.success !== undefined) {
            console.log(`Successfully executed '${query}'.`)
        } else {
            console.log(`Response for '${query}':`);
            console.log(content)
        }

    } catch (err) {
        console.log(`Error executing '${query}'`)
    }

    return content

}
