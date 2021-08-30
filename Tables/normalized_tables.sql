drop table if exists ratings;
drop table if exists list_urls;
drop table if exists movies;
drop table if exists list_url_types;
drop table if exists lists;
drop table if exists director_groups;
drop table if exists directors;
drop table if exists users;
drop sequence if exists dir_group_seq;

create table directors (
	director_id numeric primary key,
	director_name varchar(100),
	director_url text
);

create sequence dir_group_seq start 1;


create table movies(
	movie_id numeric primary key,
	movie_title varchar(100),
	movie_release_year numeric(5),
	movie_url text,
	movie_title_language varchar(4),
	movie_popularity numeric,
	movie_image_url text
);


create table director_groups(
	movie_id numeric,
	director_id numeric,
	foreign key (director_id) references directors(director_id),
	foreign key (movie_id) references movies(movie_id)
); 

create table users(
	user_id numeric primary key,
	user_trialist boolean,
	user_subscriber boolean,
	user_eligible_for_trial boolean,
	user_has_payment_method boolean,
	user_avatar_img_url text,
	user_cover_img_url text
);

create table lists(
	list_id numeric primary key,
	list_title varchar(100),
	list_movie_number numeric,
	list_update_timestamp timestamp,
	list_create_timestamp timestamp,
	list_followers numeric,
	list_comments numeric,
	list_description text,
	user_id numeric,
	foreign key (user_id) references users(user_id)
);

create table list_url_types(
	url_type_id numeric primary key,
	url_type_name varchar(30)
);

insert into list_url_types values
	(1, 'url'),
	(2, 'cover_image_url'),
	(3, 'second_image_url'),
	(4, 'third_image_url')
;

create table list_urls(
	list_id numeric,
	list_url text,
	url_type_id numeric,
	foreign key (list_id) references lists(list_id),
	foreign key (url_type_id) references list_url_types(url_type_id)
);

create table ratings(
	rating_id numeric primary key,
	rating_timestamp timestamp,
	movie_id numeric,
	rating_url text,
	rating_score numeric,
	critic text,
	critic_likes numeric,
	critic_comments numeric,
	user_id numeric,
	foreign key (user_id) references users(user_id),
	foreign key (movie_id) references movies(movie_id)
);



