CREATE TABLE langs
(
    lang_id    bigint unsigned primary key auto_increment,
    name       varchar(120),
    code       char(2),
    created_at timestamp default current_timestamp                             not null,
    updated_at timestamp default current_timestamp on update current_timestamp not null
);

insert into langs (code)
select original_language
from movies
group by original_language;

alter table movies
    add column original_lang_id bigint unsigned;

alter table movies
    add constraint fk_org_lang foreign key (original_lang_id)
        references langs (lang_id) on delete SET NULL;

update movies
set movies.original_lang_id = (select langs.lang_id from langs where langs.code = movies.original_language);

alter table movies
    drop column original_language;
