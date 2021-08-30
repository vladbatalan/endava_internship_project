-- top movies foreach director --
select 
	dense_rank() over(partition by d.director_id order by m.movie_popularity desc) movie_order,
	m.movie_id
from directors d 
	join director_groups dg on dg.director_id = d.director_id 
	join movies m on m.movie_id = dg.movie_id 
order by 
	m.movie_popularity desc;