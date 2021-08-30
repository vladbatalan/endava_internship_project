
-- select director over popularity --
with directed_movies as
(
	-- count movies directed by directors --
	select 
		d.director_id,
		count(dg.movie_id) movies_directed
	from
		directors d 
		join director_groups dg on d.director_id = dg.director_id 
	group by 
		d.director_id 
)
select 
	dense_rank() over (order by avg(m.movie_popularity) desc, avg(r.rating_score) desc) as rank,
	d.director_id, 
	d.director_name,
	avg(m.movie_popularity) average_popularity,
	avg(r.rating_score) average_rating,
	dm.movies_directed
from
	directors d
	join director_groups dg on d.director_id = dg.director_id 
	join directed_movies dm on d.director_id = dm.director_id
	join movies m on dg.movie_id = m.movie_id 
	join ratings r on r.movie_id = m.movie_id 
where
	m.movie_release_year > 2011
group by 
	d.director_id,
	dm.movies_directed
having 
	avg(m.movie_popularity) is not null
order by 
	avg(m.movie_popularity) desc,
	avg(r.rating_score) desc;
	
	
