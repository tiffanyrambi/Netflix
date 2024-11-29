# Netflix Movies and TV Shows Data Analysis 
using SQL Server Management Studio

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
	type,
	count(*) AS total_content
FROM netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * FROM netflix
WHERE 
	release_year ='2020'
	and 
	type ='Movie';
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
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
WHERE country NOT IN ('')
ORDER BY 2 DESC
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT TOP 1 * FROM netflix
WHERE 
	type ='movie' 
	AND 
	LEN(duration) >= 7
ORDER BY duration DESC
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
FROM netflix
WHERE 
	date_added NOT IN ('')
	AND 
	DATEDIFF(YEAR, PARSE(date_added AS DATE USING 'en-US'), GETDATE()) < 5
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT 
	*,
	CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) AS season
FROM netflix 
WHERE 
	type = 'TV Show'
	AND 
	CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) > 5
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
	g.value AS genre,
	COUNT(*) total_content
FROM NETFLIX n
CROSS APPLY STRING_SPLIT(n.listed_in, ',') g
GROUP BY g.value
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql

```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND 
	listed_in LIKE '%documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * FROM netflix
WHERE director IN ('')
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * FROM netflix
WHERE 
	type ='Movie'
	AND 
	cast LIKE '%Salman Khan%'
	AND 
	DATEDIFF(YEAR, release_year, GETDATE()) < 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT TOP 10
	a.value AS actor,
	COUNT(*) total_movies
FROM netflix
CROSS APPLY STRING_SPLIT(CAST, ',') AS a
WHERE country LIKE '%india%'
GROUP BY a.value, country
HAVING a.value NOT IN ('') 
ORDER BY COUNT(*) DESC;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
GROUP BY movie_label;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
