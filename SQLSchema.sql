CREATE DATABASE StudySpaceSearch; 
USE StudySpaceSearch;
CREATE TABLE OWNER(
    id INT(5) NOT NULL,
    name VARCHAR(50) NOT NULL,
    website VARCHAR(100),
    email VARCHAR(254),
    phone VARCHAR(20),
    PRIMARY KEY(id)
); CREATE TABLE SPACE(
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
); CREATE TABLE SPACE_RESOURCE(
    space_id INT(5) NOT NULL,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY(space_id, name),
    FOREIGN KEY(space_id) REFERENCES SPACE(id) ON DELETE CASCADE ON UPDATE CASCADE
); CREATE TABLE `USER`(
    id INT(5) NOT NULL,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(254) NOT NULL,
    PRIMARY KEY(id)
); CREATE TABLE USER_COMMENT(
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
); CREATE TABLE SAVED_SPACE(
    user_id INT(5) NOT NULL,
    space_id INT(5) NOT NULL,
    PRIMARY KEY(user_id, space_id),
    FOREIGN KEY(user_id) REFERENCES `USER`(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(space_id) REFERENCES SPACE(id) ON DELETE CASCADE ON UPDATE CASCADE
);

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

INSERT INTO USER VALUES
(1, 'user', 'user@email.com'),
(2, 'aaron', 'atburn@uw.edu'),
(3, 'megumi', 'minven@uw.edu'),
(4, 'trae', 'tclaar@uw.edu'),
(5, 'bob', 'bob@email.com'),
(6, 'user2', 'some@email.com'),
(7, 'user3', 'some-other@email.com'),
(8, 'user4', 'user4@email.com'),
(9, 'another_user', 'another@email.com'),
(10, 'user5', 'ok@email.com');

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
