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
                        " SELECT S.*, O.name AS owner_name
                          FROM SPACE AS S, OWNER AS O 
                          WHERE S.id = {$_GET['id']} AND S.owner_id = O.id";
                    if ($result = mysqli_query($connection, $sql))
                    {
                        $row = mysqli_fetch_assoc($result);

        ?>
        <main>
            <div class="centered-section">
                <a href="./discover.php">Back to space finder</a>
                <h2><?php echo $row['name'] ?></h2>
                <table class="space-table" style="width: 100%">
                    <tbody>
                        <tr>
                            <td><img src="<?php echo $row['image'] ?>" height="300" /></td>
                            <td>
                                <h4>Hours</h4>
                                <p><?php echo $row['hours'] ?></p>

                                <h4>Space Type</h4>
                                <p><?php echo $row['type'] ?></p>

                                <h4>Owner</h4>
                                <p>
                                    <a href="./owner.php?id=<?php echo $row['owner_id'] ?>">
                                        <?php echo $row['owner_name'] ?>
                                    </a>
                                </p>

                                <br/>

                                <button id='save-button' class='signupB' style='margin: 0;'>Save</button>
                            </td>
                            <td>
                                <h4>Address</h4>
                                <p><?php echo $row['address'] ?></p>

                                <?php
                                    if ($row["building"])
                                    {
                                ?>
                                <h4>Building</h4>
                                <p><?php echo $row['building'] ?></p>

                                <?php
                                    }
                                    if ($row["room"])
                                    {
                                ?>
                                <h4>Room</h4>
                                <p><?php echo $row['room'] ?></p>
                                <?php
                                    }
                                ?>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Comment area. Hidden if the user isn't logged in.--->
            <div  id='comment-area' class='centered-section hidden' >
                <h2>Leave a comment:</h2>
                <label>Comment:</label>

                <!-- Yes, this supports multiple lines,but new lines are replaced with spaces before sent into the db.-->
                <textarea id='comment-input' rows="5" style='border-radius: 2px; font-family: "Raleway", sans-serif;'></textarea>

                <br/>
                <div class='comment-rating'>
                    <div>
                        <p>Noise Level</p>
                        <input type="range" min="1" max="5" id='noise-level-input'>
                        <h4 id='noise-level-display'>3/5</h4>
                    </div>

                    <div>
                        <p>Availability</p>
                        <input type="range" min="1" max="5" id='availability-input'>
                        <h4 id='availability-display'>3/5</h4>
                    </div>

                    <div>
                        <p>Busyness</p>
                        <input type="range" min="1" max="5" id='busyness-input'>
                        <h4 id='busyness-display'>3/5</h4>
                    </div>

                </div>
                <br/>
                <div style='text-align: center'>
                    <button id='comment-button' class='loginB'>Comment</button>
                </div>

            </div>

            
            <div class="centered-section">

                <h2>Recent Activity</h2>
                <div id='recent-activity-box'>


                </div>
                

            </div>
        </main>
        <?php


                    // release the memory used by the result set
                    mysqli_free_result($result);
                }
            } // end if (isset)
} // end if ($_SERVER)

        ?>
    </body>
</html>