-- MANY TO MANY RELATIONSHIP
----------------------------

-- create Database
CREATE DATABASE IF NOT EXISTS tv_review_app DEFAULT CHARACTER SET utf8;

-- create tables
  --- reviewers table
  CREATE TABLE IF NOT EXISTS reviewers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(55) NOT NULL DEFAULT 'unknown',
    last_name VARCHAR(55) NOT NULL DEFAULT 'unknown'
  );

  -- series table
  CREATE TABLE IF NOT EXISTS series (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    release_year YEAR(4),
    genre VARCHAR(55)
  );

  -- reviews table
  CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rating DECIMAL(2,1),
    series_id INT,
    reviewer_id INT,
    FOREIGN KEY (series_id) REFERENCES series(id),
    FOREIGN KEY (reviewer_id) REFERENCES reviewers(id)
    ON DELETE CASCADE
  );


-- populate data into tables
  -- reviewers table
  INSERT INTO reviewers (first_name, last_name)
  VALUES
    ('Joe', 'Gitau'),
    ('Mason', 'Gitau'),
    ('Xabi', 'Alonso'),
    ('Sadio', 'Mane'),
    ('Bobby', 'Firmino');

  -- series table
  INSERT INTO series (title, release_year, genre)
  VALUES
    ('Californication', 2001, 'Comedy'),
    ('Entourage', 2008, 'Comedy'),
    ('Justified', 2009, 'Drama'),
    ('Prison Break', 2010, 'Crime'),
    ('The Good Wife', 2009, 'Drama'),
    ('Suits', 2015, 'Drama'),
    ('The Blacklist', 2012, 'Crime'),
    ('Madam Secretary', 2013, 'Drama'),
    ('Godless', 2019, 'Drama'),
    ('Power', 2016, 'Crime');

  -- reviews table
  INSERT INTO reviews (rating, series_id, reviewer_id)
  VALUES
    (9.8, 3, 1), (9.8, 2, 5), (7, 1, 4),
    (8.8, 8, 3), (9.8, 5, 4), (8, 7, 2),
    (9, 3, 2), (7, 3, 1), (9, 5, 2), (6, 7, 1),
    (6, 5, 1), (9, 6, 3), (8.5, 2, 5),
    (7, 9, 5), (6, 10, 3), (9.8, 3, 1),
    (9.8, 2, 5), (7, 1, 4), (8.8, 8, 1),
    (9.8, 5, 4), (8, 8, 3), (9.4, 9, 4),
    (7.2, 2, 1), (9, 10, 2), (9, 10, 1),
    (6, 9, 1), (9, 8, 3), (8.5, 2, 5),
    (7, 1, 5), (6, 2, 2);
  
--------------------------------------
-- RELATIONSHIPS
--------------------------------------

-- LEFT JOIN
------------
-- JOIN SERIES with its respective REVIEW and include CASE OPTIONS
SELECT  
  title, 
  IFNULL(AVG(rating), 0) AS avg_rating,
  CASE 
    WHEN AVG(rating) IS NULL THEN 'NOT RATED'
    WHEN AVG(rating) <= 6 THEN '***'
    ELSE '*****'
  END AS stars
FROM series
LEFT JOIN reviews
  ON series.id = reviews.series_id
GROUP BY series.id;

-- fetch only un-REVIEWED SERIES
SELECT 
  title,
  rating
FROM series
LEFT JOIN reviews
  ON series.id != reviews.series_id
WHERE rating IS NULL;

-- REVIEWER stats
SELECT 
  first_name, last_name,
  COUNT(rating) AS 'COUNT',
  MIN(rating) AS 'MIN',
  MAX(rating) AS 'MAX',
  ROUND(AVG(rating), 2) AS 'AVG'
FROM reviewers
LEFT JOIN reviews
  ON reviewers.id = reviews.reviewer_id
GROUP BY reviewers.id;

-------------
-- INNER JOIN
-------------
 -- JOIN SERIES with respective RATING
SELECT 
  title, 
  rating,
  ROUND(AVG(rating), 2) AS avg_rating
FROM series
INNER JOIN reviews
  ON series.id = reviews.series_id
GROUP BY reviews.id
ORDER BY avg_rating DESC;

  -- JOIN RATINGS with relevant REVIEWER
SELECT 
  last_name,
  first_name,
  AVG(rating) AS avg_rating
FROM reviewers
INNER JOIN reviews
  ON reviewers.id = reviews.reviewer_id
GROUP BY reviewers.id
ORDER BY avg_rating DESC;