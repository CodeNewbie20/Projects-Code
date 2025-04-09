USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select table_name, table_rows
from information_schema.tables
where table_schema = "imdb";








-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select column_name 
from information_schema.columns
where table_schema = "imdb" and table_name = "movie" and is_nullable = "yes";









-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select year(date_published) as year, count(*) as number_of_movies
from movie
group by year(date_published)
order by year;


select year(date_published) as year,
month(date_published) as month_num,
count(*) as number_of_movies
from movie
group by year(date_published), month(date_published)
order by year, month_num;






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


select count(*) as number_of_movies
from movie
where year(date_published) = 2019
and country in('USA','India');








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


select distinct genre from genre;






/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select g.genre, count(m.id) as number_of_movies
from movie m 
join genre g on m.id = g.movie_id
group by g.genre
order by number_of_movies desc
limit 1;


desc movie;
desc genre;




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(movie_id) as single_genre_movies
from(
    select movie_id
	from genre  
    group by movie_id
    having count(genre) = 1
    ) as single_genre_movies_list;








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre,
    AVG(m.duration) AS average_duration
FROM 
    genre g
JOIN 
    movie m ON g.movie_id = m.id
GROUP BY 
    g.genre
ORDER BY 
    g.genre;




/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select genre, movie_count, genre_rank
from(
	select genre, count(*) as movie_count,
	rank() over (order by count(*) desc) as genre_rank
    from genre
    group by genre
    ) as ranked_genres
    where genre = 'thriller';







/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select min(avg_rating) as min_avg_rating,
max(avg_rating) as max_avg_rating,
min(total_votes) as min_total_votes,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating,
max(median_rating) as max_median_rating
from ratings;







    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

select title, avg_rating,
rank() over (order by avg_rating desc) as movie_rank
from ratings
join movie on ratings.movie_id = movie.id
order by avg_rating desc limit 10;






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating,
count(*) as movie_count
from ratings
group by median_rating
order by median_rating;









/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company,
count(*) as movie_count,
rank() over (order by count(*) desc) as prod_company_rank
from movie m
join
ratings r on m.id = r.movie_id
where avg_rating > 8
group by m.production_company;







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre,
    COUNT(m.id) AS movie_count
FROM 
    movie m
JOIN 
    genre g ON m.id = g.movie_id
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.date_published >= '2017-03-01' AND 
    m.date_published < '2017-04-01' AND 
    m.country = 'USA' AND 
    r.total_votes > 1000
GROUP BY 
    g.genre
ORDER BY 
    movie_count DESC;







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select 
    m.title,
    r.avg_rating,
    g.genre
from
    movie m
join 
    ratings r on m.id = r.movie_id
join 
    genre g on m.id = g.movie_id
where 
    m.title like 'The%' and 
    r.avg_rating > 8
order by 
    g.genre, m.title;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select
    count(*) as movie_count
from 
    movie m
join 
    ratings r on m.id = r.movie_id
where 
    m.date_published >= '2018-04-01' and 
    m.date_published < '2019-04-01' and 
    r.median_rating = 8;








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select 
    country,
    sum(r.total_votes) as total_votes
from 
    movie m
join 
    ratings r on m.id = r.movie_id
where 
    country in ('Germany', 'Italy')
group by 
    country;






-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
	count(case when name is null then 1 end) as name_nulls,
    count(case when height is null then 1 end) as height_nulls,
    count(case when date_of_birth is null then 1 end) as date_of_birth_nulls,
    count(case when known_for_movies is null then 1 end) as known_for_movies_nulls
from names;





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genre AS (
    SELECT 
        g.genre
    FROM genre g
    JOIN 
        movie m ON g.id = m.genre_id
    JOIN 
        ratings r ON m.id = r.movie_id
    WHERE 
        r.avg_rating > 8
    GROUP BY 
        g.genre
    ORDER BY 
        COUNT(*) DESC
    LIMIT 3
)

SELECT 
    n.name AS director_name,
    COUNT(*) AS movie_count
FROM 
    movie m
JOIN 
    director_mapping dm ON m.id = dm.movie_id
JOIN 
    names n ON dm.name_id = n.id
JOIN 
    genre g ON g.genre = m.genre
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    r.avg_rating > 8
    AND g.genre IN (SELECT genre FROM top_genre)
GROUP BY 
    n.name
ORDER BY 
    movie_count DESC
LIMIT 3;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select n.name as actor_name,
count(*) as movie_count
from role_mapping rm
join names n on rm.name_id = n.id
join movie m on rm.movie_id = m.id
join ratings r on m.id = r.movie_id
where r.median_rating >= 8
and rm.category = 'actor'
group by n.name
order by movie_count desc
limit 2; 






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company,
sum(r.total_votes) as vote_count,
dense_rank() over(order by sum(r.total_votes)desc ) as prod_comp_rank
from movie m
join ratings r on m.id = r.movie_id
where m.production_company is not null
group by m.production_company
order by vote_count desc
limit 3;







/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT m.id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating,
    DENSE_RANK() OVER (ORDER BY 
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) DESC, 
        SUM(r.total_votes) DESC
    ) AS actor_rank
FROM 
    names n
JOIN 
    role_mapping rm ON n.id = rm.name_id
JOIN 
    movie m ON rm.movie_id = m.id
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.country = 'India'
GROUP BY 
    n.name
HAVING 
    COUNT(DISTINCT m.id) >= 5
ORDER BY 
    actor_rank
LIMIT 5;




-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT m.id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
    DENSE_RANK() OVER (
        ORDER BY 
            ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) DESC,
            SUM(r.total_votes) DESC
    ) AS actress_rank
FROM 
    names n
JOIN 
    role_mapping rm ON n.id = rm.name_id
JOIN 
    movie m ON rm.movie_id = m.id
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.country = 'India'
    AND m.languages LIKE '%Hindi%'
    AND rm.category = 'actress'
GROUP BY 
    n.name
HAVING 
    COUNT(DISTINCT m.id) >= 3
ORDER BY 
    actress_rank
LIMIT 5;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

select
	m.title as movie_name,
	case
		when r.avg_rating > 8 then 'Superhit'
        when r.avg_rating between 7 and 8 then 'Hit'
        when r.avg_rating between 5 and 7 then 'One-time-watch'
        when r.avg_rating < 5 then 'Flop'
	end as movie_category
from movie as m
join ratings as r
	on m.id = r.movie_id
join genre as g
	on m.id = g.movie_id
where total_votes > 25000 and g.genre = 'Thriller'
order by r.avg_rating desc;







/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    g.genre,
    AVG(m.duration) AS avg_duration,
    SUM(AVG(m.duration)) OVER (ORDER BY g.genre) AS running_total_duration,
    AVG(AVG(m.duration)) OVER (ORDER BY g.genre ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg_duration
FROM 
    movie m
JOIN 
    genre g ON m.id = g.movie_id
GROUP BY 
    g.genre
ORDER BY 
    g.genre;







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Step 1: Get top 3 genres with most movies
WITH top_genre AS (
    SELECT genre
    FROM genre
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

-- Step 2: Get required movie details joined with genre
genre_movies AS (
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        m.worldwide_gross_income,
        RANK() OVER (PARTITION BY g.genre, m.year ORDER BY m.worldwide_gross_income DESC) AS movie_rank
    FROM genre g
    JOIN movie m ON g.movie_id = m.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres)
)

-- Step 3: Filter top 5 movies for each genre per year
SELECT 
    genre,
    year,
    movie_name,
    worldwide_gross_income,
    movie_rank
FROM genre_movies
WHERE movie_rank <= 5;








-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH hits AS (
    SELECT 
        m.production_company,
        COUNT(*) AS movie_count
    FROM 
        movie m
    JOIN 
        ratings r ON m.id = r.movie_id
    WHERE 
        r.median_rating >= 8
        AND m.languages LIKE '%,%'
    GROUP BY 
        m.production_company
)

SELECT 
    production_company,
    movie_count,
    RANK() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
FROM 
    hits
WHERE 
    movie_count > 0
    AND production_company IS NOT NULL
    AND production_company <> ''

ORDER BY 
    prod_comp_rank
LIMIT 2;






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH superhit_movies AS (
    SELECT 
        m.id AS movie_id,
        r.avg_rating,
        r.total_votes,
        g.genre,
        rm.name_id
    FROM 
        movie m
    JOIN 
        ratings r ON m.id = r.movie_id
    JOIN 
        genre g ON m.id = g.movie_id
    JOIN 
        role_mapping rm ON m.id = rm.movie_id
    WHERE 
        rm.category = 'actress'               -- Filtering only actresses
        AND r.avg_rating > 8                  -- Filtering for Super Hit movies
        AND g.genre = 'drama'                 -- Filtering for 'drama' genre
),

actress_stats AS (
    SELECT 
        n.name AS actress_name,
        SUM(sm.total_votes) AS total_votes,
        COUNT(sm.movie_id) AS movie_count,
        SUM(sm.avg_rating * sm.total_votes) / SUM(sm.total_votes) AS actress_avg_rating
    FROM 
        superhit_movies sm
    JOIN 
        names n ON sm.name_id = n.id
    GROUP BY 
        n.name
)

SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC, actress_name ASC) AS actress_rank
FROM 
    actress_stats
ORDER BY 
    actress_rank
LIMIT 3;






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_movies AS (
    SELECT 
        dm.name_id AS director_id,
        n.name AS director_name,
        m.id AS movie_id,
        m.duration AS movie_duration,
        r.avg_rating,
        r.total_votes,
        m.date_published  -- Include date_published for calculating inter-movie duration
    FROM 
        director_mapping dm
    JOIN 
        movie m ON dm.movie_id = m.id
    JOIN 
        ratings r ON m.id = r.movie_id
    JOIN 
        names n ON dm.name_id = n.id
),

director_stats AS (
    SELECT 
        dm.director_id,
        dm.director_name,
        COUNT(dm.movie_id) AS number_of_movies,
        SUM(dm.movie_duration) AS total_duration,
        MIN(dm.avg_rating) AS min_rating,
        MAX(dm.avg_rating) AS max_rating,
        SUM(dm.total_votes) AS total_votes,
        AVG(dm.avg_rating) AS avg_rating
    FROM 
        director_movies dm
    GROUP BY 
        dm.director_id, dm.director_name
),

inter_movie_durations AS (
    SELECT 
        current_movie.director_id,
        AVG(DATEDIFF(current_movie.date_published, previous_movie.date_published)) AS avg_inter_movie_days
    FROM 
        director_movies current_movie
    JOIN 
        director_movies previous_movie 
    ON 
        current_movie.director_id = previous_movie.director_id
    AND 
        current_movie.movie_id > previous_movie.movie_id
    GROUP BY 
        current_movie.director_id
)

SELECT 
    ds.director_id,
    ds.director_name,
    ds.number_of_movies,
    ROUND(imd.avg_inter_movie_days) AS avg_inter_movie_days,
    ROUND(ds.avg_rating, 2) AS avg_rating,
    ds.total_votes,
    ROUND(ds.min_rating, 1) AS min_rating,
    ROUND(ds.max_rating, 1) AS max_rating,
    ds.total_duration
FROM 
    director_stats ds
JOIN 
    inter_movie_durations imd ON ds.director_id = imd.director_id
ORDER BY 
    ds.number_of_movies DESC
LIMIT 9;





