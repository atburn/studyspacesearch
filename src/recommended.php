
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
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Amaranth:ital,wght@0,400;0,700;1,400;1,700&display=swap');
    </style>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Amaranth:ital,wght@0,400;0,700;1,400;1,700&family=Raleway:ital,wght@0,100..900;1,100..900&display=swap');
    </style>

    <script defer src="recommendedScript.js" type="module"></script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script>
        $(function () {
            $("#header").load("header.html");
        });
    </script>

</head>
<body>
    <div id="header"></div>

    <main>
        <div class="centered-section">
            <h2>Recommended Spaces</h2>
            <p>See which spaces are being praised by other users.</p>
            <table class="space-table" style="width: 100%">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Address</th>
                        <th>User</th>
                        <th>Comment</th>
                    </tr>
                </thead>
                <tbody id="space-table-body">

                </tbody>
            </table>
        </div>
    </main>
    </body>
</html>
