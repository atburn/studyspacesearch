<?php
require_once ("config.php")
?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Space Study Search</title>
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="spaceStyles.css">

        <style>
            @import url('https://fonts.googleapis.com/css2?family=Amaranth:ital,wght@0,400;0,700;1,400;1,700&display=swap');
        </style>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Amaranth:ital,wght@0,400;0,700;1,400;1,700&family=Raleway:ital,wght@0,100..900;1,100..900&display=swap');
        </style>
        
        <script defer src="spaceScript.js" type='module'></script>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
        <script>
            $(function () {
                $("#header").load("header.html");
            });
        </script>
    </head>
    <body>
        
        <div id='header'></div>

        <?php
            $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
            if ($_SERVER["REQUEST_METHOD"] == "GET")
            {

                if (isset($_GET['id']) )
                {

                    if ( mysqli_connect_errno() )
                    {
                        die( mysqli_connect_error() );
                    }

                    $sql = 
                        " SELECT *
                          FROM OWNER
                          WHERE id = {$_GET['id']}";
                    if ($result = mysqli_query($connection, $sql))
                    {
                        $row = mysqli_fetch_assoc($result);

                        // sorry for the indentation 
                        $space_sql =
                            "SELECT s.id,
                                s.image 'Image',
                                s.name 'Space Name',
                                s.address 'Address',
                                s.building 'Building',
                                s.room 'Room', 
                                COUNT(ss.user_id) AS 'Total Times Saved by Users'
                            FROM SPACE s
                            JOIN SAVED_SPACE ss ON s.id = ss.space_id
                            WHERE s.owner_id IN (SELECT id FROM OWNER WHERE id = {$row['id']})
                            GROUP BY s.id
                            HAVING COUNT(ss.user_id) = (
                                SELECT MAX(save_count)
                                FROM (
                                    SELECT COUNT(ss.user_id) AS save_count
                                    FROM SPACE s
                                    JOIN SAVED_SPACE ss ON s.id = ss.space_id
                                    WHERE s.owner_id IN (SELECT id FROM OWNER WHERE id = {$row['id']})
                                    GROUP BY s.id
                                ) AS max_saved_count
                            );";
                        if ($space_result = mysqli_query($connection, $space_sql))
                        {
                            $space_row = mysqli_fetch_assoc($space_result);


        ?>
        <main>
            <div class="centered-section">
                <a href="./discover.php">Back to space finder</a>
                <h2><?php echo $row['name'] ?></h2>
                <table class="space-table" style="width: 100%">
                    <tbody>
                        <tr>

                            <td>

                                <?php
                                    if ($row["website"])
                                    {
                                ?>
                                <h4>Website</h4>
                                <a href="<?php echo $row['website'] ?>"><?php echo $row['website'] ?></a>

                                <?php
                                    }
                            if ($row["email"])
                            {
                                ?>
                                <h4>Email</h4>
                                <p><?php echo $row['email'] ?></p>
                                <?php
                            }
                            if ($row["phone"])
                            {
                                ?>
                                <h4>Phone</h4>
                                <p><?php echo $row['phone'] ?></p>
                                <?php
                            }
                                ?>



                            </td>
                            <td>
                                <h3>Most Saved Space</h3>
                                <br/>
                                <img src="<?php echo $space_row['Image'] ?>" height="100" />
                                <p>
                                    <a href="./space.php?id=<?php echo $space_row['id'] ?>">
                                        <?php echo $space_row['Space Name'] ?>
                                    </a>
                                </p>
                                <br/>
                                <p>
                                    <?php echo $space_row['Total Times Saved by Users'] ?> Saves
                                </p>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </main>
        <?php
                            mysqli_free_result($space_result);
                    }
                    // release the memory used by the result set
                    mysqli_free_result($result);
                }
            } // end if (isset)
} // end if ($_SERVER)

        ?>
    </body>
</html>