-- Simple select the needed columns --
select
	movie_id,
	director_id,
	director_name,
	director_url
from
	movies;

-- Create plpgsql function that receives a raw and returns all pairs of directors with their name --
drop type director_splitted;
drop function director_row_multiplyer;

create type director_splitted as(
	movie_id numeric,
	director_id numeric,
	director_name text,
	director_url text
);

create function director_row_multiplyer(
	movie_id integer,
	dir_id_arr text[], 
	dir_name_arr text[], 
	dir_url_arr text[]
)
returns setof director_splitted as $$
	declare
		ret_row director_splitted%rowtype;
	begin
		
		for i in 1 .. cardinality(dir_id_arr)
		loop
			ret_row.movie_id := movie_id;
			ret_row.director_id := dir_id_arr[i]::numeric;
			ret_row.director_name := dir_name_arr[i];
			ret_row.director_url := dir_url_arr[i];
			return next ret_row;
		end loop;
		return;
	end;
$$ language plpgsql;


-- Select the columns as regexp --
-- May not be good as performance --
create index movie_id_idx on movies(movie_id);


create view director_normal_view
as
with to_array as (
	select 
		movie_id, 
		regexp_split_to_array(replace(director_id, ', ', ','), ',') as director_id_arr,
		regexp_split_to_array(replace(director_name, ', ', ','), ',') as director_name_arr,
		regexp_split_to_array(director_url, ', ') as director_url_arr
	from movies
)
select 
	f.movie_id, 
	f.director_id,
	f.director_name,
	f.director_url
from to_array arr 
	left join lateral director_row_multiplyer
	(
		arr.movie_id, 
		arr.director_id_arr, 
		arr.director_name_arr, 
		arr.director_url_arr
	) f on true;

select * from director_normal;
select * from director_normal_view;