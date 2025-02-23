CREATE DATABASE metrics;

USE metrics;
-- create table digits
CREATE TABLE digits ( id int primary key );
INSERT into digits values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

-- amplify counts from 000 to 999
CREATE TABLE counters ( id CHAR(3) NOT NULL PRIMARY KEY );
INSERT into counters SELECT concat(d1.id, d2.id, d3.id) as n from digits as d1, digits as d2, digits as d3;

-- create table topics
CREATE TABLE topics (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255), 
    parent_id INT NULL,
    type SMALLINT NOT NULL,
    FOREIGN KEY (parent_id) REFERENCES topics(id), 
    INDEX idx_type (type)
);

-- inserting categories
INSERT INTO topics (name,parent_id,type)
SELECT CONCAT("cat-",id),NULL,1 FROM (
SELECT id FROM counters LIMIT 50) t;

-- inserting sub-categories
INSERT INTO topics (name,parent_id,type)
SELECT CONCAT("subcat-",category_id, counter_id),category_id,2 FROM (
    SELECT categories.id as category_id,counters.id as counter_id FROM(
    	(SELECT id from topics where type = 1) categories,
		(SELECT id FROM counters LIMIT 100) counters
       )
) t;

-- inserting topics
INSERT INTO topics (name,parent_id,type)
SELECT CONCAT("topic-",subcategory_id, counter_id),subcategory_id,3 FROM (
    SELECT subcategories.id as subcategory_id,counters.id as counter_id FROM(
    	(SELECT id from topics where type = 2) subcategories,
		(SELECT id FROM counters LIMIT 1000) counters
       )
) t;

-- adds 5 mil rows in under 100s
-- learnt this from a very awesome mentor - Arpit Bhayani