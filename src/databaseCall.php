<?php 

$post_body = file_get_contents('php://input');
$post_data = json_decode($post_body, true);

if (!isset($post_data['sql'])) {
    die();
}

$sql = $post_data['sql'];

require_once("config.php");

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);

if (mysqli_connect_errno()) {
    die(json_encode(array("error" => mysqli_connect_error())));
}

$result = mysqli_query($connection, $sql);

if ($result === false) {
    echo json_encode(array("error" => mysqli_error($connection)));
} else {
    // Check if the query is a SELECT
    if (is_object($result)) {
        $rows = array();
        while ($row = mysqli_fetch_assoc($result)) {
            $rows[] = $row;
        }
        echo json_encode($rows);
        mysqli_free_result($result);
    } else {
        // For non-SELECT queries, return a success message
        echo json_encode(array("success" => true));
    }
}

mysqli_close($connection);

?>