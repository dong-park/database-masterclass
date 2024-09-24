CREATE TABLE statues
(
    status_id   BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    status_name ENUM ('Canceled',
        'In Production',
        'Planned',
        'Post Production',
        'Released',
        'Rumored')                                                              NOT NULL,
    explanation TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP                             NOT NULL,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL
);

SELECT status
FROM movies
GROUP BY status;

insert into statues (status_name)
SELECT movies.status
from movies
group by movies.status;

ALTER TABLE movies
    ADD COLUMN status_id BIGINT UNSIGNED;

alter table movies
    add CONSTRAINT fk_status FOREIGN KEY (status_id)
        references statues (status_id) ON DELETE set null;

update movies set movies.status_id = (select statues.status_id from statues where status_name = movies.status);

alter table movies drop column status;

