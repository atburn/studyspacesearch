/* ********************************
Project Phase II
Group 7 (MySQL)
This SQL script was designed for 
and tested on MySQL. 
******************************** */


-- ***************************
-- ***************************
-- Part A
-- ***************************

CREATE DATABASE StudySpaceSearch; 
USE StudySpaceSearch;

-- OWNER: store data for study space owners
CREATE TABLE OWNER(
    id INT(5) NOT NULL,
    name VARCHAR(50) NOT NULL,
    website VARCHAR(100),
    email VARCHAR(254),
    phone VARCHAR(20),
    PRIMARY KEY(id)
); 
-- SPACE: store study space data
CREATE TABLE SPACE(
    id INT(5) NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    building VARCHAR(50) NOT NULL,
    room VARCHAR(50),
    owner_id INT(5) NOT NULL,
    type VARCHAR(50) NOT NULL,
    image VARCHAR(150) DEFAULT ('https://images.pexels.com/photos/259239/pexels-photo-259239.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
    hours VARCHAR(128) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(owner_id) REFERENCES OWNER(id) ON DELETE NO ACTION ON UPDATE CASCADE
); 
-- SPACE_RESOURCE: store study space resource information
CREATE TABLE SPACE_RESOURCE(
    space_id INT(5) NOT NULL,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY(space_id, name),
    FOREIGN KEY(space_id) REFERENCES SPACE(id) ON DELETE CASCADE ON UPDATE CASCADE
); 
-- USER: store user data
CREATE TABLE `USER`(
    id INT(5) NOT NULL,
    username VARCHAR(50) NOT NULL,
    `password` VARCHAR(50) NOT NULL,
    salt VARCHAR(50) NOT NULL,
    email VARCHAR(254) NOT NULL,
    PRIMARY KEY(id)
); 
-- USER_COMMENT: store data associated with user comments
CREATE TABLE USER_COMMENT(
    space_id INT(5) NOT NULL,
    noise INT(1) NOT NULL DEFAULT (1) CHECK (noise > 0 AND noise < 6),
    availability INT(1) NOT NULL DEFAULT (1) CHECK (availability > 0 AND availability < 6),
    busyness INT(1) NOT NULL DEFAULT (1) CHECK (busyness > 0 AND busyness < 6),
    user_remark VARCHAR(50) NOT NULL CHECK (CHAR_LENGTH(user_remark) > 0 AND CHAR_LENGTH(user_remark) < 51), 
    user_id INT(5),
    timestamp VARCHAR(20),
    PRIMARY KEY(space_id, user_id, timestamp),
    FOREIGN KEY(space_id) REFERENCES SPACE(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(user_id) REFERENCES `USER`(id) ON DELETE CASCADE ON UPDATE CASCADE
); 
-- SAVED_SPACE: list IDs of saved spaces and the users who saved them
CREATE TABLE SAVED_SPACE(
    user_id INT(5) NOT NULL,
    space_id INT(5) NOT NULL,
    PRIMARY KEY(user_id, space_id),
    FOREIGN KEY(user_id) REFERENCES `USER`(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(space_id) REFERENCES SPACE(id) ON DELETE CASCADE ON UPDATE CASCADE
);



-- ***************************
-- ***************************
-- Part B
-- ***************************

-- Sample data for OWNER
-- Summary: info for 10 study space owners, including id, name, and contact info
INSERT INTO OWNER VALUES
(1, 'UW Tacoma', 'https://www.tacoma.uw.edu/', 'uwtinfo@uw.edu', '2536924000'),
(2, 'Metro Coffee', 'https://www.facebook.com/p/Metro-Coffee-100057155092844/', 'MetroCoffeeManager@gmail.com', '2536278152'),
(3, 'Metro Parks Tacoma', 'https://www.metroparkstacoma.org/', 'info@tacomaparks.com', '2533051000'),
(4, 'WSDOT', 'https://wsdot.wa.gov/', NULL, NULL),
(5, 'Anthem Coffee', 'https://www.myanthemcoffee.com/', NULL, '2535729705'),
(6, 'Campfire Coffee', 'https://www.welovecampfire.com/', 'goodies@welovecampfire.com', NULL),
(7, 'Subway', 'https://www.subway.com/', NULL, '2533835207'),
(8, 'Abella Pizzeria', 'https://www.abellapizzeria.com/', 'abellapizzeria@gmail.com', '2537790769'),
(9, 'Dancing Goats Coffee', 'https://www.dancinggoats.com/', 'info@dancinggoats.com', '8009555282'),
(10, 'Starbucks', 'https://www.starbucks.com/', NULL, '2535731789');
-- Sample data for SPACE
-- Summary: data for 10 study spaces, containing name, location, hours, and other info
INSERT INTO SPACE VALUES
(1, 'TPS Ground Floor', '1735 Jefferson Ave, Tacoma, WA 98402', 'Tacoma Paper & Stationery', NULL, 1, 'Common Area', 'https://www.tacoma.uw.edu/sites/default/files/2020-10/45621795401_b0e6fa9652_c.jpg', '8:00 AM - 5:00 PM Monday - Friday<br />Closed Saturday - Sunday'),
(2, 'Metro Coffee', '1901 Jefferson Ave, Tacoma, WA 98402', NULL, NULL, 2, 'Business', 'https://assets.simpleviewinc.com/simpleview/image/upload/crm/tacoma/Metro-Coffee-3-bf46302d5056a34_bf4630f7-5056-a348-3ad304fc52b40b28.jpg', '7:30 AM - 3:00 PM Monday - Thursday<br />7:30 AM - 1:00 PM Friday<br />Closed Saturday - Sunday'),
(3, 'Anthem Coffee & Tea', '1911 Pacific Ave, Tacoma, WA 98402', NULL, NULL, 5, 'Business', 'https://media-cdn.tripadvisor.com/media/photo-s/09/93/7b/b6/anthem-coffee-and-tea.jpg', '7:00 AM - 4:00 PM Monday - Friday<br />8:00 AM - 4:00 PM Saturday - Sunday'),
(4, 'Don Pugnetti Park', '2085 Pacific Ave, Tacoma, WA 98402', NULL, NULL, 4, 'Park', 'https://www.thenewstribune.com/latest-news/5y95r7/picture285397562/alternates/FREE_1140/02DonPugnettiPark.jpg', 'All day'),
(5, 'BHS 101', '1740 Pacific Ave, Tacoma, WA 98402', 'Birmingham Hay & Speed', '101', 1, 'Reservable Breakout Room', 'https://25live.collegenet.com/25live/data/washington/run/image?image_id=1035', '8:00 AM - 5:00 PM Monday - Friday<br />Closed Saturday - Sunday'),
(6, 'BHS 105', '1740 Pacific Ave, Tacoma, WA 98402', 'Birmingham Hay & Speed', '105', 1, 'Reservable Breakout Room', 'https://25live.collegenet.com/25live/data/washington/run/image?image_id=1074', '8:00 AM - 5:00 PM Monday - Friday<br />Closed Saturday - Sunday'),
(7, 'MDS 102', '1932 Pacific Avenue, Tacoma, WA 98402', 'McDonald Smith', '102', 1, 'Reservable Breakout Room', 'https://25live.collegenet.com/25live/data/washington/run/image?image_id=47', '8:00 AM - 5:00 PM Monday - Friday<br />Closed Saturday - Sunday'),
(8, 'MDS 202', '1932 Pacific Avenue, Tacoma, WA 98402', 'McDonald Smith', '202', 1, 'Reservable Breakout Room', 'https://25live.collegenet.com/25live/data/washington/run/image?image_id=48', '8:00 AM - 5:00 PM Monday - Friday<br />Closed Saturday - Sunday'),
(9, 'MDS 302', '1932 Pacific Avenue, Tacoma, WA 98402', 'McDonald Smith', '302', 1, 'Reservable Breakout Room', 'https://25live.collegenet.com/25live/data/washington/run/image?image_id=49', '8:00 AM - 5:00 PM Monday - Friday<br />Closed Saturday - Sunday'),
(10, 'CP 3A', '1922 Pacific Avenue, Tacoma, WA 98402', 'Cherry Parkes', '3A', 1, 'Reservable Study Space', 'https://25live.collegenet.com/25live/data/washington/run/image?image_id=948', '8:00 AM - 5:00 PM Monday - Friday<br />Closed Saturday - Sunday');
-- Sample data for USER
-- Summary: sample data for 10 users
INSERT INTO USER VALUES
(1, 'user', 'not a real hash', 'not a real salt', 'user@email.com'),
(2, 'aaron', 'not a real hash', 'not a real salt', 'atburn@uw.edu'),
(3, 'megumi', 'not a real hash', 'not a real salt', 'minven@uw.edu'),
(4, 'trae', 'not a real hash', 'not a real salt', 'tclaar@uw.edu'),
(5, 'bob', 'not a real hash', 'not a real salt', 'bob@email.com'),
(6, 'user2', 'not a real hash', 'not a real salt', 'some@email.com'),
(7, 'user3', 'not a real hash', 'not a real salt', 'some-other@email.com'),
(8, 'user4', 'not a real hash', 'not a real salt', 'user4@email.com'),
(9, 'another_user', 'not a real hash', 'not a real salt', 'another@email.com'),
(10, 'user5', 'not a real hash', 'not a real salt', 'ok@email.com');
-- Sample data for SPACE_RESOURCE
-- Summary: resources associated with the 10 sample SPACE tuples
INSERT INTO SPACE_RESOURCE VALUES
(1, 'Microwave'),
(5, 'TV'),
(5, 'Whiteboard'),
(6, 'TV'),
(6, 'Whiteboard'),
(7, 'TV'),
(7, 'Whiteboard'),
(8, 'TV'),
(8, 'Whiteboard'),
(9, 'TV'),
(9, 'Whiteboard');
-- Sample data for USER_COMMENT
-- Summary: 10 sample user comments on study spaces with numerical ratings, text comments, and timestamps
INSERT INTO USER_COMMENT VALUES
(1, 2, 5, 1, 'pretty nice', 4, '2024-04-11T14:11'),
(1, 3, 3, 2, 'comment', 8, '2024-04-19T10:46'),
(4, 1, 5, 1, 'lovely', 5, '2024-03-05T01:32'),
(8, 4, 3, 2, 'it was loud', 6, '2024-02-26T13:23'),
(10, 3, 1, 4, 'ok', 1, '2023-12-15T07:48'),
(7, 3, 1, 5,'someone else was there', 7, '2023-05-30T14:34'),
(1, 2, 1, 3, 'no comment', 6, '2024-03-12T09:17'),
(5, 1, 5, 1, 'sick', 10, '2024-01-20T16:02'),
(9, 1, 2, 4, 'I have nothing to say', 9, '2023-01-26T11:30'),
(2, 3, 5, 1, 'hello world', 7, '2024-02-29T12:15');
-- Sample data for SAVED_SPACE
-- Summary: sample saved space tuples, each with user and space ID
INSERT INTO SAVED_SPACE VALUES
(4, 1),
(4, 9), 
(1, 6),
(1, 3),
(1, 8),
(8, 3),
(9, 7),
(5, 2),
(5, 7),
(10, 3);



-- ***************************
-- ***************************
-- Part C
-- ***************************

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
    -- Purpose: List of all users and any associated text comments
    -- Expected: A table of users' public information and their text comments
    -- Union of left and right joins is used because MySQL does not support full join
SELECT id, username, email, space_id as space, user_remark AS comment, timestamp
FROM USER AS U
LEFT JOIN USER_COMMENT AS UC
ON U.id = UC.user_id
UNION
SELECT id, username, email, space_id as space, user_remark AS comment, timestamp
FROM USER AS U
RIGHT JOIN USER_COMMENT AS UC
ON U.id = UC.user_id
ORDER BY id;

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
        user_comment.availability,
        user_comment.busyness,
        user_comment.user_remark,
        user_comment.user_id,
        MAX(user_comment.timestamp) AS recent_comment
    FROM
        user_comment
    GROUP BY
        user_comment.space_id
) AS recent_comments
RIGHT JOIN SPACE ON space.id = recent_comments.space_id;

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

-- SQL Query 10: Create your own non-trivial SQL query
	-- Purpose: Get spaces with a positive comment. The comment includes the word(s) "nice", 
	-- 	"great", "good", "wonderful", "love", or "like". The result set could be used to help 
	-- 	recommend users a random study space.
	-- Expected: A table listing the space's name, the space's building, the username of the user 
	-- 	who made the comment, and the comment itself.
SELECT
    S.name, 
    S.building,
    U.username,
    UC.user_remark
FROM SPACE AS S 
    JOIN USER_COMMENT AS UC
    ON S.id = UC.space_id
    JOIN `USER` AS U
    ON UC.user_id = U.id
WHERE (UC.user_remark LIKE '%nice%' 
    OR UC.user_remark LIKE '%great%' 
    OR UC.user_remark LIKE '%good%' 
    OR UC.user_remark LIKE '%wonderful%'
    OR UC.user_remark LIKE '%love%'
    OR UC.user_remark LIKE '%like%')
    AND UC.user_remark NOT IN (
        SELECT USER_COMMENT.user_remark
        FROM USER_COMMENT
        WHERE USER_COMMENT.user_remark LIKE '%not nice%' 
        	OR USER_COMMENT.user_remark LIKE '%n\'t nice%'
            	OR USER_COMMENT.user_remark LIKE '%not great%' 
        	OR USER_COMMENT.user_remark LIKE '%n\'t great%'
            	OR USER_COMMENT.user_remark LIKE '%not good%' 
        	OR USER_COMMENT.user_remark LIKE '%n\'t good%'
            	OR USER_COMMENT.user_remark LIKE '%not wonderful%'
        	OR USER_COMMENT.user_remark LIKE '%n\'t wonderful%'
        	OR USER_COMMENT.user_remark LIKE '%not love%'
        	OR USER_COMMENT.user_remark LIKE '%n\'t love%'
        	OR USER_COMMENT.user_remark LIKE '%not like%'
        	OR USER_COMMENT.user_remark LIKE '%n\'t like%'
    )
;