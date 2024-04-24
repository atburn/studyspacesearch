-- SQL Query 2: Uses nested queries with the IN, ANY or ALL operator and uses a GROUP BY clause
-- SQL Query 2: A correlated nested query with proper aliasing applied
-- SQL Query 4: Uses a FULL OUTER JOIN
-- SQL Query 5: Uses nested queries with any of the set operations UNION, EXCEPT, or INTERSECT*
-- SQL Query 8: Create your own non-trivial SQL query (must use at least two tables in FROM clause)
-- SQL Query 9: Create your own non-trivial SQL query (must use at least three tables in FROM clause)
-- SQL Query 10: Create your own non-trivial SQL query
--     must use at least three tables in FROM clause
--     must use aliasing or renaming for at least once throughout SQL query


-- SQL Query 1: Computes a join of at least three tables (must use JOIN ON)
    -- Purpose: Returns a table of the most user-relevent information of each space.
    -- Expected: A table containing details for each space
SELECT
    space.id,
    space.name,
    space.address,
    space.building,
    space.room,
    space.hours,
    concat_resources.resources,
    owner_info.owner_id,
    owner_info.owner_name,
    owner_info.owner_website,
    owner_info.owner_email,
    owner_info.owner_phone
FROM
    SPACE
JOIN(
    SELECT
        space_id,
        GROUP_CONCAT(NAME) AS resources
    FROM
        space_resource
    GROUP BY
        space_id
) AS concat_resources
ON
    concat_resources.space_id = space.id
JOIN(
    SELECT OWNER.id AS owner_id,
        OWNER.name AS owner_name,
        OWNER.website AS owner_website,
        OWNER.email AS owner_email,
        OWNER.phone AS owner_phone
    FROM OWNER
) AS owner_info
ON
    owner_info.owner_id = space.id;


-- SQL Query 6: Create your own non-trivial SQL query (must use at least two tables in FROM clause)
    -- Purpose: Returns a table of information about each user and the spaces they have reserved.
    --      May be useful from an admin perspective
    -- Expected: A table containing details about each user (excluding sensitive information), including reserved spaces 
SELECT
    user.id,
    user.username,
    user.email,
    saved_space.saved
FROM
    USER
JOIN(
    SELECT
        user_id,
        GROUP_CONCAT(space_id) AS saved
    FROM
        saved_space
    GROUP BY
        user_id
) AS saved_space
ON
    saved_space.user_id = user.id;




-- SQL Query 7: Create your own non-trivial SQL query (must use at least two tables in FROM clause)
    -- Purpose: Returns a table of all owners and the buildings they own, if any
    -- Expected: A table containing details about all owners, including buildings they own.
SELECT 
	OWNER.id AS owner_id,
    OWNER.name,
    OWNER.website,
    OWNER.email,
    OWNER.phone,
    spaces.owned_spaces
FROM OWNER
LEFT JOIN(
    SELECT
        space.owner_id AS space_owner,
        GROUP_CONCAT(space.id) AS owned_spaces
    FROM
        SPACE
    JOIN OWNER ON 
            OWNER.id = space.owner_id
GROUP BY
    space.owner_id
) AS spaces
ON
    spaces.space_owner = OWNER.id;