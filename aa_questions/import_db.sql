-- DROP TABLE users;
-- DROP TABLE questions;
-- DROP TABLE question_followers;
-- DROP TABLE replies;
-- DROP TABLE question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Tim', 'Canty'),
  ('Louie', 'Chen');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('Why?','?', (SELECT id FROM users WHERE fname = 'Tim' AND lname = 'Canty' )),
  ('Whats the meaning of life?', 'I need to know', (SELECT id FROM users WHERE fname = 'Louie' AND lname = 'Chen' ));

INSERT INTO
  question_followers(user_id,question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Tim' AND lname = 'Canty'), (SELECT id FROM questions WHERE body = 'I need to know'));


INSERT INTO
  question_likes(user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Louie' AND lname = 'Chen'), (SELECT id FROM questions WHERE body = '?'));

INSERT INTO
  replies(parent_id, user_id, question_id, body)
VALUES
  (null, 1, 2, 'Having fun'), (1,2,2,'That sounds right');
