----------------------------------------
-- exp of writing the data to a local file
select ride_id
from master_all
where member_casual = 'member'
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Season_member.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
;

-- exp of importing the data from a local file
LOAD DATA LOCAL INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\bike_times_all.csv"
INTO TABLE `bike_start_times`
COLUMNS TERMINATED BY ',' ENCLOSED BY '\"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';
-------------------------------------------


-- OBJECTIVE: Determine how annual members and casual riders use their bikes different? 
-- STEP 1 - Split the dataset into 2 separate tables, seperating members and casual riders.
-- STEP 2 - List different combinations of data points to compare and contrast with the 2 catagories.
-- Step 3 - Write queries to filter, the queries for use in data visualization.

-- # of casuals that ride classic
  SELECT COUNT(*) FROM rides_20 WHERE rideable_type = 'classic_bike' AND member_casual = 'casual' ;
  SELECT COUNT(*) FROM rides_21 WHERE rideable_type = 'classic_bike' AND member_casual = 'casual' ;

-- # of casuals that ride docked
  SELECT COUNT(*) FROM rides_20 WHERE rideable_type = 'docked_bike' AND member_casual = 'casual' ;
  SELECT COUNT(*) FROM rides_21 WHERE rideable_type = 'docked_bike' AND member_casual = 'casual' ;
    
--  # of casuals that ride electric 
  SELECT COUNT(*) FROM rides_20 WHERE rideable_type = 'electric_bike' AND member_casual = 'casual' ;
  SELECT COUNT(*) FROM rides_21 WHERE rideable_type = 'electric_bike' AND member_casual = 'casual' ;

-- Most popular start locations (Name, ID, Longitude, Latitude)
  SELECT start_station_name, COUNT(start_station_name) AS most_pop_start_locs  FROM rides_101_new_4 WHERE member_casual = 'member' GROUP BY start_station_name ORDER BY most_pop_start_locs DESC ; 

-- Most popular stop locations (Name, ID, Longitude, Latitude)
  SELECT DISTINCT(end_station_name), end_station_id, end_lat, COUNT(end_lat) FROM rides_20 WHERE member_casual = 'casual' GROUP BY end_station_id ORDER BY COUNT(end_lat) DESC ;
  SELECT DISTINCT(end_station_name), end_station_id, end_lat, COUNT(end_lat) FROM rides_21 WHERE member_casual = 'casual' GROUP BY end_station_id ORDER BY COUNT(end_lat) DESC ;

-- Most popular start times of the day
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE(' ', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE(' ', started_at))) - LENGTH(RIGHT(started_at,LOCATE(':', (REVERSE(started_at)))))) AS started_at_time,  COUNT(started_at), started_at FROM rides_21 WHERE started_at LIKE '___________01:%' AND member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;
  SELECT started_at_time, COUNT(started_at_time) AS most_used_time_of_day FROM bike_start_times GROUP BY started_at_time ORDER BY most_used_time_of_day DESC ;

-- Average trip duration
  SELECT TIMEDIFF(ended_at, started_at) AS difference FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference DESC

-- Longest trips by duration (0.001%, 1%, 5%) anomalies. Run 1st query get percentages then query with percentage values as query result limits
  SELECT  start_station_name, COUNT(TIMEDIFF(ended_at, started_at)) AS difference, TIMEDIFF(ended_at, started_at) AS difference,started_at, ended_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY start_station_name ORDER BY difference DESC ;
  SELECT start_station_name, TIMEDIFF(ended_at, started_at) AS difference,started_at, ended_at  FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference DESC LIMIT 1129 ;
  SELECT start_station_name, TIMEDIFF(ended_at, started_at) AS difference,started_at, ended_at  FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference DESC LIMIT 11299 ;
  SELECT start_station_name, TIMEDIFF(ended_at, started_at) AS difference,started_at, ended_at  FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference DESC LIMIT 56497 ;

-- Shortest trips by duration (0.001%, 1%, 5%) anomalies. 
  SELECT start_station_name, TIMEDIFF(ended_at, started_at) AS difference,started_at, ended_at  FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference DESC LIMIT 1129 ;
  SELECT start_station_name, TIMEDIFF(ended_at, started_at) AS difference,started_at, ended_at  FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference LIMIT 11299 ;
  SELECT start_station_name, TIMEDIFF(ended_at, started_at) AS difference,started_at, ended_at  FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference LIMIT 56497 ;

-- Average trip length by distance, Has to go into R
-- Longest trips by distance (0.001%, 1%, 5%) anomalies, Has to go into R
-- Shortest trips by distance (0.001%, 1%, 5%) anomalies, Has to go into R

-- Most popular months of usage (desc)
  SELECT rides_21.started_at FROM rides_20 LEFT JOIN rides_21 ON rides_20.started_at=rides_20.started_at  ;

-- Most popular usage times of year grouped by season (desc)
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE(' ', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE(' ', started_at))) - LENGTH(RIGHT(started_at,LOCATE(':', (REVERSE(started_at)))))) AS started_at_time,  COUNT(started_at), started_at FROM rides_21 WHERE started_at LIKE '___________01:%' AND member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;

-- Month & Duration correlation
  SELECT TIMEDIFF(ended_at, started_at) AS difference FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference DESC
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;

-- Season & Duration correlation
  SELECT TIMEDIFF(ended_at, started_at) AS difference FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference DESC
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;

-- Bike Type & Duration correlation
  SELECT TIMEDIFF(ended_at, started_at) AS difference FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference DESC
  SELECT COUNT(*) FROM rides_21 WHERE rideable_type = 'docked_bike' AND member_casual = 'casual' ;   430355

-- Location & Duration correlation
  SELECT TIMEDIFF(ended_at, started_at) AS difference FROM rides_21 WHERE member_casual = 'casual' ORDER BY difference DESC
  SELECT DISTINCT(start_station_name), start_station_id, start_lat, COUNT(end_lat) FROM rides_21 WHERE member_casual = 'casual' GROUP BY start_station_id ORDER BY COUNT(end_lat) DESC ;
  SELECT DISTINCT(end_station_name), end_station_id, end_lat, COUNT(end_lat) FROM rides_21 WHERE member_casual = 'casual' GROUP BY end_station_id ORDER BY COUNT(end_lat) DESC ;

-- Month & Bike Type correlation
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;
  SELECT COUNT(*) FROM rides_21 WHERE rideable_type = 'docked_bike' AND member_casual = 'casual' ;

-- Month & Location correlation
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;
  SELECT start_station_name FROM rides_21 WHERE member_casual = 'casual' LIMIT 78;

-- Month & Trip Length (distance) correlation
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;
  SELECT start_lat, start_lng, end_lat, end_lng FROM rides_21 LIMIT 78;

-- Location & Bike Type correlation 
  SELECT start_lat, start_lng FROM rides_21 WHERE member_casual = 'casual';
  SELECT COUNT(*) FROM rides_20 WHERE rideable_type = 'docked_bike' AND member_casual = 'casual' ;   70642

-- Location & Season correlation
  SELECT start_lat, start_lng FROM rides_21 WHERE member_casual = 'casual';
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;

-- Anomalies & Location correlation
  SELECT start_station_name FROM rides_21 WHERE member_casual = 'casual';

--   Longest trips by duration (0.001%, 1%, 5%) anomalies
--   Shortest trips by duration (0.001%, 1%, 5%) anomalies
--   Longest trips by distance (0.001%, 1%, 5%) anomalies
--     Has to go into R
--   Shortest trips by distance (0.001%, 1%, 5%) anomalies
--     Has to go into R
-- Anomalies (distance) & Season correlation
--   Longest trips by distance (0.001%, 1%, 5%) anomalies
--     Has to go into R
--   Shortest trips by distance (0.001%, 1%, 5%) anomalies
--     Has to go into R
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;

-- Anomalies (distance) & Month correlation
--   Longest trips by distance (0.001%, 1%, 5%) anomalies
--     Has to go into R
--   Shortest trips by distance (0.001%, 1%, 5%) anomalies
--     Has to go into R
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;

-- Anomalies (duration) & Season correlation
--   Longest trips by duration (0.001%, 1%, 5%) anomalies
--   Shortest trips by duration (0.001%, 1%, 5%) anomalies
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;

-- Anomalies (duration) & Month correlation)
--   Longest trips by duration (0.001%, 1%, 5%) anomalies
--   Shortest trips by duration (0.001%, 1%, 5%) anomalies
  SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at FROM rides_21 WHERE member_casual = 'casual' GROUP BY started_at ORDER BY started_at_time DESC ;

-- Anomalies & Bike Type Correlation
--   Longest trips by duration (0.001%, 1%, 5%) anomalies
--   Shortest trips by duration (0.001%, 1%, 5%) anomalies
--   Longest trips by distance (0.001%, 1%, 5%) anomalies
--     Has to go into R
--   Shortest trips by distance (0.001%, 1%, 5%) anomalies
--     Has to go into R
  SELECT COUNT(*) FROM rides_20 WHERE rideable_type = 'electric_bike' AND member_casual = 'casual' ; 82989

-- AFTER QUERYING DATA POINT COMBINATIONS, USE THE RESULTS OF THOSE QUERIES TO CREATE SMALLER RESULTS LISTS AND PREP FOR VISUALIZATION

CREATE TABLE Bike_Start_Times
(started_at_time varchar(100)
,started_at varchar(100)
);

##Load local data into sql faster than using sqls ui.

LOAD DATA LOCAL INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\bike_times_all.csv"
INTO TABLE `bike_start_times`
COLUMNS TERMINATED BY ',' ENCLOSED BY '\"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';

SELECT started_at_time, COUNT(started_at_time) AS most_used_time_of_day
FROM bike_start_times
GROUP BY started_at_time
ORDER BY most_used_time_of_day DESC
;

CREATE TABLE distance_casual
(entry_position varchar(100), 
mnth varchar(100),
distance varchar(100)
);

LOAD DATA LOCAL INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Distance_Month_Casual.csv"
INTO TABLE `distance_casual`
COLUMNS TERMINATED BY ',' ENCLOSED BY '\"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';

select rideable_type
from rides_101_new_3
where rideable_type NOT LIKE 'docked_bike';

SELECT 
    COUNT(*)
FROM
    member_all;


CREATE TABLE longest_trips_001
(started_at_time varchar(100)
,started_at varchar(100)
);

create table member_all
AS
(select * 
from master_all
where member_casual = 'member');

select ride_id
from master_all
where member_casual = 'member';

SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE(' ', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE(' ', started_at))) - LENGTH(RIGHT(started_at,LOCATE(':', (REVERSE(started_at)))))) AS started_at_time,  COUNT(started_at), started_at
FROM rides_101_new_4
WHERE started_at LIKE  '___________00:%' AND member_casual = 'member'
GROUP BY started_at
ORDER BY started_at_time DESC
;



SELECT start_station_name, TIMEDIFF(ended_at, started_at) AS difference, started_at, ended_at
FROM rides_101_new_4
WHERE member_casual = 'casual'
ORDER BY difference DESC
LIMIT 78348;


SELECT started_at, SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS test
FROM rides_101_new_4
WHERE member_casual = 'member'
GROUP BY started_at
ORDER 

SELECT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS month_of_trip, start_lat, start_lng, end_lat, end_lng
from rides_101_new_4
where member_casual = 'member'
order by month_of_trip
;

select count(start_station_name), start_station_name, rideable_type
from rides_101_new_4
where member_casual = 'member' and rideable_type = 'electric_bike'
group by start_station_name
order by count(start_station_name) desc
;BY test DESC
;

CREATE TABLE rideID_Casual
(ride_id varchar(100)
);

LOAD DATA LOCAL INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Ride_Casual.csv"
INTO TABLE `rideID_Casual`
COLUMNS TERMINATED BY ',' ENCLOSED BY '\"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';

select *
from distance_casual1
WHERE distance_traveled NOT LIKE 'NA'
order by distance_traveled desc
;

select substring(started_at,6,2) as start_month, start_lat, start_lng, end_lat, end_lng
from casual_all
;


show variables like "secure_file_priv";

SELECT TIMEDIFF(ended_at, started_at) AS difference
FROM casual_all
ORDER BY difference DESC;

select * from casual_all limit 20;

SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE('-', started_at))) - LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at)))))) AS started_at_time, started_at
FROM rides_21
WHERE member_casual = 'casual'
GROUP BY started_at
ORDER BY started_at_time DESC
;

SELECT DISTINCT SUBSTRING(started_at,
LENGTH(LEFT(started_at,LOCATE('-', started_at)+1)),LENGTH(started_at) - 
LENGTH(LEFT(started_at,LOCATE('-', started_at))) - 
LENGTH(RIGHT(started_at,LOCATE('-', (REVERSE(started_at))))))
from casual_all;

SELECT LEFT(started_at,LOCATE('/', started_at) -1) AS mnth, started_at
from casual_all
limit 100;

SELECT substring(started_at,6,2) as mydate
FROM casual_all
limit 15;

select *
from casual_all
limit 5;

CREATE TABLE ts (mytimestamp DATETIME)
INSERT INTO ts SELECT started_at FROM casual_all LIMIT 5;


SELECT mytimestamp, hour(mytimestamp) FROM ts;

select * from casual_all limit 10;

select distinct (rideable_type) from casual_all;

select * from casual_all where rideable_type = 'classic_bike';

SELECT distinct rideable_type, newtype FROM (
SELECT rideable_type, 
CASE WHEN  rideable_type = 'classic_bike' THEN '1'
	WHEN rideable_type = 'docked_bike' THEN '2'
    ELSE '3'
END AS newtype 
FROM casual_all) newtable
LIMIT 5;			

USE project2;


SELECT started_at_month
FROM casual_all
WHERE started_at_month = 01, 02, 12;
(SELECT substring(started_at,6,2) as started_at_month
FROM casual_all) newtable
;

select * ;

SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE(' ', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE(' ', started_at))) - LENGTH(RIGHT(started_at,LOCATE(':', (REVERSE(started_at)))))) AS started_at_time,  COUNT(started_at), started_at
FROM rides_21
WHERE started_at LIKE '___________01:%' AND member_casual = 'casual'
GROUP BY started_at
ORDER BY started_at_time DESC;

SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE(' ', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE(' ', started_at))) - LENGTH(RIGHT(started_at,LOCATE(':', (REVERSE(started_at)))))) AS started_at_time,  COUNT(started_at), started_at
FROM rides_21
WHERE started_at LIKE '___________01:%' AND member_casual = 'casual'
GROUP BY started_at
ORDER BY started_at_time DESC
;

create table combined1 AS 
select ride_id, ride_season from 
(select ROW_NUMBER() OVER() AS seqnum, ride_id from rideid_casual) ride 
INNER JOIN
(select ROW_NUMBER() OVER() AS seqnum, 
	CASE
		WHEN ride_month = 9 THEN "fall" 
        WHEN ride_month = 10 THEN "fall"
        WHEN ride_month = 11 THEN "fall"
		WHEN ride_month = 12 THEN "winter"
		WHEN ride_month = 1 THEN "winter"
		WHEN ride_month = 2 THEN "winter"
		WHEN ride_month = 6 THEN "summer"
		WHEN ride_month = 7 THEN "summer"
		WHEN ride_month = 8 THEN "summer"
		WHEN ride_month = 3 THEN "spring"
        WHEN ride_month = 4 THEN "spring"
		WHEN ride_month = 5 THEN "spring"
        ELSE "question"
	   END AS ride_season
       FROM (
			select month(started_at) as ride_month
			from casual_all
            	) newtable) season ;
                
SELECT 
    end_station_name
FROM
    master_all
WHERE
    ((start_station_id IN (SELECT DISTINCT
            start_station_id
        FROM
            master_all
        WHERE
            member_casual = 'casual'))
        OR (start_station_id IN (SELECT 
            start_station_id
        FROM
            master_all
        WHERE
            ridealble_type = 'docked_bike'
                AND start_station_name LIKE '%Milwaukee')))
        AND (start_lat BETWEEN 41.8 AND 41.9);

drop table temp1;
drop table temp2;

create table temp1 AS 
select start_station_name, start_station_id  from master_all limit 5;
create table temp2 AS 
select start_station_id, end_station_name  from master_all where start_station_id NOT IN ('36','340') limit 3;

select * from temp1;
select * from temp2;
insert into temp2 values ('100', 'tampa');

select temp1.start_station_name, temp1.start_station_id, temp2.end_station_name
  from temp1 LEFT JOIN temp2
    ON temp1.start_station_id = temp2.start_station_id;
    
    select temp1.start_station_name, temp1.start_station_id, temp2.end_station_name
  from temp2 LEFT JOIN temp1 
    ON temp1.start_station_id = temp2.start_station_id;
    
    select temp1.start_station_name, temp1.start_station_id, temp2.end_station_name, temp2.start_station_id
  from temp2 LEFT JOIN temp1 
    ON temp1.start_station_id = temp2.start_station_id;
    
        select temp1.start_station_name, temp1.start_station_id, temp2.start_station_id, 
        temp2.end_station_name
  from temp1 LEFT OUTER JOIN temp2 
    ON temp1.start_station_id = temp2.start_station_id
    WHERE temp2.start_station_id IS NULL
   UNION
   select temp1.start_station_name, temp1.start_station_id, temp2.start_station_id, 
        temp2.end_station_name
  from temp1 RIGHT OUTER JOIN temp2 
    ON temp1.start_station_id = temp2.start_station_id
    WHERE temp1.start_station_id IS NULL;
    
    select month(started_at), started_at from 
    (select * from member_all) newtable
    where month(started_at) IS NULL
    ;
    
    create table ready AS;
    
    select month_casual_1000.ride_id, month_of_year, season
    from month_casual_1000
    FULL OUTER JOIN seasons_casual1000
    ON month_casual_1000.ride_id = seasons_casual1000.ride_id;

select month_casual_1000.ride_id, month_casual_1000.month_of_year, seasons_casual.ride_id, seasons_casual1000.season 
  from month_casual_1000 LEFT OUTER JOIN seasons_casual1000
    ON month_casual_1000.ride_id = seasons_casual1000.ride_id;
   UNION
   select temp1.start_station_name, temp1.start_station_id, temp2.start_station_id, 
        temp2.end_station_name
  from temp1 RIGHT OUTER JOIN temp2 
    ON temp1.start_station_id = temp2.start_station_id
    WHERE temp1.start_station_id IS NULL;
    
    select * from distance_member1000
    limit 200;
    
    SELECT * FROM t1
LEFT JOIN t2 ON t1.id = t2.id
UNION
SELECT * FROM t1
RIGHT JOIN t2 ON t1.id = t2.id

CREATE TABLE rideid_member
(ride_id varchar(100)
);

LOAD DATA LOCAL INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Ride_member.csv"
INTO TABLE `rideid_member`
COLUMNS TERMINATED BY ',' ENCLOSED BY '\"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';


select ride_id, started_at, ended_at, start_statioon_id, end_station_id
from casual_all
;

select started_at, ended_at, start_station_id, end_station_id, ride_id
from member_all
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Member_Casual.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
;

select * from distance_member1;


SELECT TIMEDIFF(ended_at, started_at) AS difference, ride_id
FROM member_all
;

SELECT TIMEDIFF(ended_at, started_at) AS difference, ride_id
FROM casual_all
;

select * from trip_time_member1;
use project2;

SELECT *
FROM distance_casual1000
;



select a.*, month(casual_all.started_at) as ride_month
from duration_casual1000 a INNER JOIN casual_all
ON a.ride_id = casual_all.ride_id
WHERE month(casual_all.started_at) IN (12, 1, 2)
;

select *
from casual_all
limit 500;

select CASE
		WHEN ride_month = 11 THEN "fall"
		WHEN ride_month = 12 THEN "winter"
		ELSE "summer or winter"
	   END AS ride_season
       FROM (
			select month(started_at) as ride_month
			from casual_all
			where month(started_at) IN (11,12,7)
			limit 1000000) newtable
            ;

select * 
FROM docked_casual
;

select distinct started_at, substring(started_at,5,4),
substring(started_at,1,1),
substring(started_at,3,1),
substring(started_at,10,5)
from (
select started_at 
			from casual_all
            where month(started_at) IS null
			) newtable limit 15
            ;
select *, substring(started_at,s2+1,4),
substring(started_at,1,s1-1),
substring(started_at,s1+1,s2-s1-1),
 substring(started_at, s0+1, length(started_at)-s0+1) as hhmm
##substring(started_at,s2+1,)
from (
        select started_at, length (started_at) as _length, locate(" ", started_at) as S0,
        locate("/", started_at) as s1, locate("/", started_at, 4) as s2
        ##substring(started_at, s0+1, length(started_at)-s0+1) as hhmm
        from (
            select started_at 
			from casual_all
            where month(started_at) IS null
			) newtable ) newtable2 limit 15000;
            
select started_at from casual_all limit 1;


SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE(' ', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE(' ', started_at))) - LENGTH(RIGHT(started_at,LOCATE(':', (REVERSE(started_at)))))) AS started_at_time,  COUNT(started_at), started_at, ride_id
FROM casual_all
WHERE started_at IN (___________01:%

);

SELECT DISTINCT SUBSTRING(started_at,LENGTH(LEFT(started_at,LOCATE(' ', started_at)+1)),LENGTH(started_at) - LENGTH(LEFT(started_at,LOCATE(' ', started_at))) - LENGTH(RIGHT(started_at,LOCATE(':', (REVERSE(started_at)))))) AS started_at_time, started_at, ride_id
FROM rides_21
WHERE started_at LIKE '___________01:%' 
OR started_at LIKE '___________02:%'
GROUP BY started_at
ORDER BY started_at_time DESC
;

select CASE
		WHEN ride_month = 9 THEN "fall" 
        WHEN ride_month = 10 THEN "fall"
        WHEN ride_month = 11 THEN "fall"
		WHEN ride_month = 12 THEN "winter"
		WHEN ride_month = 1 THEN "winter"
		WHEN ride_month = 2 THEN "winter"
		WHEN ride_month = 6 THEN "summer"
		WHEN ride_month = 7 THEN "summer"
		WHEN ride_month = 8 THEN "summer"
		WHEN ride_month = 3 THEN "spring"
        WHEN ride_month = 4 THEN "spring"
		WHEN ride_month = 5 THEN "spring"
        ELSE "question"
	   END AS ride_season
       FROM (
			select month(started_at) as ride_month
			from member_all
            	)newtable 
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Season_Member.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select count(*) from seasons_casual where seasons = 'spring';

  use project2;          
 SELECT ride_id from member_all
 INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\rideid_member.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT DISTINCT ride_id, seasons
FROM rideid_casual, seasons_casual
WHERE seasons = 'spring'
limit 3333;

create table seasons_member AS 
select ride_id, season from 
(select ROW_NUMBER() OVER() AS seqnum, ride_id from rideid_member) ride 
INNER JOIN
(select ROW_NUMBER() OVER() AS seqnum, season from seasons_member1000) season 
ON ride.seqnum = season.seqnum;

select * from seasons_member;

create table temp AS
select * 
from seasons_casual 
INNER JOIN rideid_casual 
ON seasons_casual.rownum = rideid_casual.rownum;

select * from seasons_member;
