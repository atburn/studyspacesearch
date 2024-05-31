
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

    <script defer src="discoverScript.js" type="module"></script>

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
            <h2>Filters</h2>
            <div style="display: flex; justify-content:space-around;">
                <div style="display: flex; flex-direction: column;">
                    <form method="GET" action="index.php">
                        <label for="filter-select-owner">Building owner</label>
                        <select id="filter-select-owner" name="owner-type">
                            <option selected>Select an owner</option>
                                <?php
                                $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
                                if (mysqli_connect_errno()){
                                    die(mysqli_connect_error());
                                }
                                $sql = "SELECT id, name FROM OWNER";
                                if ($result = mysqli_query($connection, $sql)) {
                                    while ($row = mysqli_fetch_assoc($result)) {
                                        echo '<option value="' . $row['id'] . '">';
                                        echo $row['name'];
                                        echo "</option>";
                                    }
                                    mysqli_free_result($result);
                                }
                            ?>
                        </select>
                    </form>
                </div>
                <div style="display: flex; flex-direction: column;">
                    <form>
                        <label for="filter-select-resource">Contains resource</label>
                        <select id="filter-select-resource" name="resource-type">
                            <option selected>Select a resource</option>
                            <?php
                            $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
                            if (mysqli_connect_errno()){
                                die(mysqli_connect_error());
                            }
                            $sql = "SELECT DISTINCT name FROM SPACE_RESOURCE";
                            if ($result = mysqli_query($connection, $sql)) {
                                while ($row = mysqli_fetch_assoc($result)) {
                                    echo '<option value="' . $row['name'] . '">';
                                    echo $row['name'];
                                    echo "</option>";
                                }
                                mysqli_free_result($result);
                            }
                            ?>
                        </select>
                    </form>
                </div>
                <button id="filter-search-b">
                    Apply Filters
                </button>
            </div>
        </div>
    
        <div class="centered-section">
            <h2>Study Spaces</h2>
            <table class="space-table" style="width: 100%">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Building</th>
                        <th>Hours</th>
                    </tr>
                </thead>
                <tbody id="space-table-body">
    
                </tbody>
            </table>
        </div>
	</main>
</body>
</html>
