SELECT * FROM netflix
ORDER BY show_id

-- clean data
DELETE FROM netflix
WHERE show_id = 'Flying Fortress"'

SELECT DISTINCT TYPE FROM netflix

--Business Problems & Solutions

--1. Count the number of Movies vs TV Shows
SELECT 
	type,
	count(*) AS total_content
FROM netflix
GROUP BY type

--2. Find the most common rating for movies and TV shows
WITH top_rating AS 
(
SELECT 
	type,
	rating,
	count(*) AS total_content,
	RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rank
FROM netflix
GROUP BY rating, type
)
SELECT 
	type,
	rating,
	total_content
FROM top_rating
WHERE rank = 1

--3. List all movies released in a specific year (e.g., 2020)
SELECT * FROM netflix
WHERE 
	release_year ='2020'
	and 
	type ='Movie'

--4. Find the top 5 countries with the most content on Netflix
SELECT 
	--top 5 
	*
FROM 
(
SELECT 
    s.value AS country,
	COUNT(*) total_content
FROM netflix n
CROSS APPLY STRING_SPLIT(n.country, ',') s
GROUP BY s.value
) AS top_countries
WHERE country not in ('')
ORDER BY 2 DESC

--5. Identify the longest movie
SELECT TOP 1 *
	--type, 
	--duration 
FROM netflix
WHERE 
	type ='movie' 
	AND 
	LEN(duration) >= 7
ORDER BY duration DESC

--6. Find content added in the last 5 years
SELECT 
	*
	--date_added,
	--PARSE(date_added AS DATE USING 'en-US') AS ConvertedDate
FROM netflix
WHERE 
	date_added NOT IN ('')
	and 
	DATEDIFF(YEAR, PARSE(date_added AS DATE USING 'en-US'), GETDATE()) < 5
--order by 2

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'

--8. List all TV shows with more than 5 seasons
SELECT 
	*,
	CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) AS season
FROM netflix 
WHERE 
	type = 'TV Show'
	AND 
	CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) > 5
--order by season DESC

--9. Count the number of content items in each genre
SELECT 
	g.value AS genre,
	COUNT(*) total_content
FROM NETFLIX n
CROSS APPLY STRING_SPLIT(n.listed_in, ',') g
GROUP BY g.value
--ORDER BY count(*) desc


--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release! 
SELECT 
	--country,
	release_year,
	COUNT(show_id)
FROM netflix
WHERE country LIKE '%india%'
GROUP BY release_year
--blm kelar--ga ngerti soal---

--11. List all movies that are documentaries
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND 
	listed_in LIKE '%documentaries%'

--12. Find all content without a director
SELECT * FROM netflix
WHERE director IN ('')

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix
WHERE 
	type ='Movie'
	AND 
	cast LIKE '%Salman Khan%'
	AND 
	DATEDIFF(YEAR, release_year, GETDATE()) < 10

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
	TOP 10
	a.value AS actor,
	COUNT(*) total_movies
FROM netflix
CROSS APPLY STRING_SPLIT(CAST, ',') AS a
WHERE country LIKE '%india%'
GROUP BY a.value, country
HAVING a.value NOT IN ('') 
ORDER BY COUNT(*) DESC

--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
--Label content containing these keywords as 'Bad' and all other content as 'Good'. 
--Count how many items fall into each category.
SELECT 
 movie_label,
 COUNT(*) AS total_content
FROM 
(
SELECT 
	*,
	CASE
		WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'bad'
		ELSE 'good'
	END AS movie_label
FROM netflix 
) AS t1
GROUP BY movie_label
