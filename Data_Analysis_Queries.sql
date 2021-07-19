CREATE DATABASE airbnb;
USE airbnb;

CREATE TABLE train_users_2 (
	id VARCHAR(20) PRIMARY KEY,
    date_account_created DATE,
    timestamp_first_active TIMESTAMP,
    date_first_booking DATE,
    gender VARCHAR(20),
    age INT,
    signup_method VARCHAR(20),
    signup_flow INT,
    languages VARCHAR(10),
    affiliate_channel VARCHAR(20),
    affiliate_provider VARCHAR(20),
    first_affiliate_tracked VARCHAR(20),
    signup_app VARCHAR(20),
    first_device_type VARCHAR(30),
    first_browser VARCHAR(30),
    country_destination VARCHAR(20)
);
-- FOR WINDOWS
-- run in MYSQL Prompt
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = true;  -- if it is OFF
 
-- open command prompt and run
-- cd C:\Program Files\MySQL\MySQL Server 8.0\bin
-- mysql --local-infile=1 -u root -p 
-- then the below query in that shell
USE airbnb;
LOAD DATA LOCAL INFILE 'F:/Github/MYSQL - Airbnb Data Analysis/Data/train_users_2.csv'   -- specify your FILE PATH HERE !!  USE FORWARD_SLASH("/") in WINDOWS
INTO TABLE train_users_2
FIELDS TERMINATED BY ','
ENCLOSED BY '"';

-- back to workbench!
CREATE TABLE sessions (
	user_id VARCHAR(20) PRIMARY KEY,
    action VARCHAR(30),
    action_type VARCHAR(30),
    action_detail VARCHAR(40),
    device_type VARCHAR(30),
    secs_elapsed INT
);

-- back to the prompt
LOAD DATA LOCAL INFILE 'F:/Github/MYSQL - Airbnb Data Analysis/Data/sessions.csv'   -- specify your FILE PATH HERE !!  USE FORWARD_SLASH("/") in WINDOWS
INTO TABLE sessions
FIELDS TERMINATED BY ','
ENCLOSED BY '"';

-- back to workbench!

-- SQL used in data cleaning
-- Check whether the data contains duplicate values
SELECT id, COUNT(id) AS count_id
FROM mysql.train_users_2
GROUP BY id
HAVING count_id > 1;

-- Query each column through the following SQL, and query the number of null values ​​contained in each column by replacing the conditions after where.
SELECT date_first_booking, COUNT(date_first_booking)
FROM mysql.train_users_2
WHERE date_first_booking IS NULL;

-- Judging whether there are abnormal values ​​in the data by checking whether the extreme value (maximum value, minimum value) of the data conforms to the actual situation.
SELECT min(age), max(age) 
FROM mysql.train_users_2;

-- Outlier processing: delete data whose age is not in the range of 7 to 75 (set to 0-empty value)
UPDATE mysql.train_users_2
SET age = 0
WHERE id NOT IN (
		SELECT id
		FROM (
			SELECT id
			FROM mysql.train_users_2
			WHERE age <= 75
				AND age >= 7
		) a
	);

-- SQL statements used in user profile analysis
-- Female users
SELECT COUNT(id) AS 'Number of female users'
FROM mysql.train_users_2
WHERE gender = 'MALE';

-- Number of male users
SELECT COUNT(id) AS 'Number of male users'
FROM mysql.train_users_2
WHERE gender = 'FEMALE';

-- Number of users of different ages
SELECT age, COUNT(id)
FROM mysql.train_users_2
GROUP BY age
HAVING age <> 0
ORDER BY age;

-- User distribution in different languages
SELECT language, COUNT(language) AS lg_num
FROM mysql.train_users_2
GROUP BY language
ORDER BY lg_num;

-- Chinese users go abroad to book regions
SELECT language, country_destination, COUNT(country_destination) AS cd_num
FROM mysql.train_users_2
GROUP BY language, country_destination
HAVING language = 'zh'
ORDER BY cd_num DESC;

-- SQL funnel analysis process
-- Total number of users: Group by user_id in the sessions table, and then count the number to get the number of all users in the sessions table.
SELECT COUNT(*) AS 'amount of users'
FROM (
			SELECT user_id
			FROM mysql.sessions
			GROUP BY user_id
) new_sessions;

-- Definition of active user: According to the total number of operations performed by the user, if the user operates the product 10 times or more, it can indicate that the user is a more active user. On the other hand, it indicates that the user is not a zombie user.
SELECT COUNT(*) AS 'Number of active users'
FROM (
			SELECT user_id
			FROM mysql.sessions
			GROUP BY user_id
			HAVING COUNT(user_id) >= 10
) active;

-- Registered users: through the internal association of users in the sessions table with the registered users table, count the number of registered users in the sessions table
SELECT COUNT(*) AS 'Total number of registered users'
FROM (
			SELECT user_id
			FROM mysql.sessions
			GROUP BY user_id
) new_sessions
			INNER JOIN mysql.train_users_2 tu
			ON new_sessions.user_id = tu.id;

-- Ordering users: "reservations" in user behavior is a reservation (ordering) operation. The number of users who have performed "reservations" (group by deduplication) is calculated to get the number of users who placed orders
SELECT COUNT(*) AS 'Number of users placing orders'
FROM (
			SELECT user_id
			FROM mysql.sessions
			WHERE action_detail = 'reservations'
			GROUP BY user_id
) booking;

-- Actual payment users: "payment_instruments" in user behavior is a payment operation, and the number of users who have performed "payment_instruments" is counted (group by deduplication) to get the actual number of users who paid
SELECT COUNT(*) AS  'Total number of actual paying users'
FROM (
	SELECT user_id
	FROM mysql.sessions
	WHERE action_detail = 'payment_instruments'
	GROUP BY user_id
) payed;

-- Repurchase users: By counting users who have performed "payment_instruments" operations more than 1 time (group by deduplication), the actual number of repurchase users is obtained
SELECT COUNT(*) AS  'Total number of repurchase payment users'
FROM (
	SELECT user_id
	FROM mysql.sessions
	WHERE action_detail = 'reservations'
	GROUP BY user_id
	HAVING COUNT(user_id) >= 2
) re_booking;

-- THE END!
