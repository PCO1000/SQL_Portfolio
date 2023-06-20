CREATE TABLE movie(
    movie_id SERIAL PRIMARY KEY,
    movie_title VARCHAR,
    rating INTEGER,
    movie_length INTEGER,
    movie_cast VARCHAR

);

CREATE TABLE ticket(
    ticket_id SERIAL PRIMARY KEY,
    movie_id INTEGER,
    cinema_room VARCHAR,
    movie_time VARCHAR,
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id)

);

CREATE TABLE customer(
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    email VARCHAR,
    phone VARCHAR(50),
    ticket_id INTEGER,
    FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id)
);


CREATE TABLE concession(
    concession_id SERIAL PRIMARY KEY,
    snack VARCHAR(150),
    bevarage VARCHAR(150),
    cost INTEGER,
    customer_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)

);

SELECT *
FROM customer;