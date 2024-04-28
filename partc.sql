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

-- SQL Query 2: Uses nested queries with the IN, ANY or ALL operator and uses a GROUP BY clause
	-- Purpose: Calculate the average noise level for each space, then compare the average noise level of each  
	-- 	space to the overall average noise level for all spaces. Returns the spaces that have a below-average 
	--	noise level.
	-- Expected: A table with the spaces (with details) whose average noise level is less than the total average 
	-- 	noise level from all spaces.
SELECT SPACE.image "Image", 
	SPACE.name "Space Name", 
	SPACE.address "Address", 
	SPACE.building "Building", 
	SPACE.room "Room", 
	avg(USER_COMMENT.noise) "Avg Noise Level"
FROM USER_COMMENT 
	JOIN SPACE 
	ON USER_COMMENT.space_id = SPACE.id
GROUP BY USER_COMMENT.space_id
HAVING avg(USER_COMMENT.noise) < (
	SELECT avg(USER_COMMENT.noise)
	FROM USER_COMMENT
);

-- SQL Query 3: A correlated nested query with proper aliasing applied
	-- Purpose: List the spaces that have a Whiteboard resource.
	-- Expected: A table of spaces that have a whiteboard and their details.
SELECT SP.id, SP.name
FROM SPACE AS SP 
WHERE EXISTS (
	SELECT *
	FROM SPACE_RESOURCE AS SR
	WHERE SR.space_id = SP.id AND SR.name = 'Whiteboard'
);

-- SQL Query 4: Uses a FULL OUTER JOIN
    -- Purpose: List locations for all spaces and any associated resources
    -- Expected: A table of location information for study spaces and their resources
    -- Union of left and right joins is used because MySQL does not support full join
SELECT S.name, address, building, room, R.name AS 'resource'
FROM SPACE AS S
LEFT JOIN SPACE_RESOURCE AS R 
ON S.id = R.space_id
UNION ALL
SELECT S.name, address, building, room, R.name AS 'resource'
FROM SPACE AS S
RIGHT JOIN SPACE_RESOURCE AS R 
ON S.id = R.space_id;

-- SQL Query 5: Uses nested queries with any of the set operations UNION, EXCEPT, or INTERSECT
    -- Purpose: List all spaces that have a TV and a high average availability
        -- Could be useful to those looking for a TV to use
        -- Similar queries could be used for filtering spaces based on different criteria
    -- Expected: A table of the names of spaces with a TV and high availability
SELECT name FROM SPACE 
WHERE id IN (
    SELECT space_id 
    FROM SPACE_RESOURCE 
    WHERE name = 'TV' 
    EXCEPT 
    SELECT space_id 
    FROM USER_COMMENT 
    GROUP BY space_id 
    HAVING AVG(availability) < 3
);

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


-- SQL Query 8: Create your own non-trivial SQL query (must use at least two tables in FROM clause)
    -- Purpose: Return a table of all spaces and their most recent comment
    -- Expected: A table containing details about spaces and their most recent comment, if any
SELECT
    space.*,
    recent_comments.*
FROM
    (
    SELECT
        user_comment.space_id AS space_id,
        user_comment.noise,
        user_comment.availibity,
        user_comment.busyness,
        user_comment.user_remark,
        user_comment.user_id,
        MAX(user_comment.timestamp) AS recent_comment
    FROM
        user_comment
    GROUP BY
        user_comment.space_id
) AS recent_comments
RIGHT JOIN SPACE ON space.id = recent_comments.space_id

-- SQL Query 9: Create your own non-trivial SQL query (must use at least three tables in FROM clause)
    -- Purpose: Retrieve all owners with a space that has a higher than average number of comments
        -- Could be used to determine which owners' spaces have the highest activity
    -- Expected: A table containing owner names with more than the average number of comments on their space(s)
SELECT DISTINCT O.name
FROM SPACE AS S, OWNER AS O, USER_COMMENT
WHERE space_id = S.id AND owner_id = O.id
GROUP BY space_id
HAVING COUNT(space_id) > (SELECT AVG(count)
                          FROM (SELECT COUNT(space_id) AS count 
                                FROM USER_COMMENT
                            	GROUP BY space_id) AS counts);