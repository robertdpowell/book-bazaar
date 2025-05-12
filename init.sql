CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL,
  price NUMERIC(10,2) NOT NULL
);

INSERT INTO books (title, author, price) VALUES
  ('Clean Code', 'Robert C. Martin', 29.99),
  ('Domain-Driven Design', 'Eric Evans', 45.50),
  ('The Pragmatic Programmer', 'Andy Hunt & Dave Thomas', 39.95);