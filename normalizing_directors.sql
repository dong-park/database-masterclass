CREATE TABLE directors
(
    director_id bigint unsigned primary key auto_increment,
    name        varchar(120),
    created_at  timestamp default current_timestamp                             not null,
    updated_at  timestamp default current_timestamp on update current_timestamp not null
);

insert into directors (name)
select director
from movies
group by director;

alter table movies
    add column director_id bigint unsigned;

alter table movies
    add constraint fk_director foreign key (director_id)
        references directors (director_id) on delete SET NULL;

create index idx_director_name on directors (name);

update movies
set movies.director_id = (select directors.director_id from directors where directors.name = movies.director);

alter table movies drop column director;
