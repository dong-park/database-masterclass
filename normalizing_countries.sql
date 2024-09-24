CREATE TABLE countries
(
    country_id   bigint unsigned primary key auto_increment,
    country_code char(2),
    created_at   timestamp default current_timestamp                             not null,
    updated_at   timestamp default current_timestamp on update current_timestamp not null
);

alter table countries
    modify column country_code char(2) unique;

insert ignore countries (country_code)
select *
from (select substring_index(country, ',', 1) as country_code
      from movies
      where country not like '__,__,__'
      group by country
      union
      select substring_index(substring_index(country, ',', 2), ',', -1) as country_code
      from movies
      where country not like '__,__,__'
      group by country) as u
group by u.country_code;

create table movie_countries
(
    movie_id   bigint unsigned,
    country_id bigint unsigned,
    primary key (movie_id, country_id),
    foreign key (movie_id) references movies (movie_id) on delete cascade,
    foreign key (country_id) references countries (country_id) on delete cascade
);

insert into movie_countries (movie_id, country_id)
select movie_id, country_id
from movies
         join countries on movies.country like concat('%', country_code, '%')
where country_code <> '';

alter table movies
    drop column country;
