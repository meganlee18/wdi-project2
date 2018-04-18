CREATE DATABASE globe_db;

CREATE TABLE albums (
    id SERIAL4 PRIMARY KEY,
    name VARCHAR(200),
    image_url VARCHAR(400)
);


CREATE TABLE comments (
    id SERIAL4 PRIMARY KEY,
    content VARCHAR(400) NOT NULL,
    albums_id INTEGER NOT NULL,
    user_id INTEGER,
    FOREIGN KEY (albums_id) REFERENCES albums (id) ON DELETE CASCADE
);

CREATE TABLE users (
    id SERIAL4 PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    password_digest VARCHAR(400) NOT NULL
);

alter table photos add content text;
alter table users add user_name VARCHAR(50) NOT NULL;