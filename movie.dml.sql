INSERT INTO customer(
    first_name,
    last_name,
    email,
    phone
)VALUES (
    'Gosta',
    'Jerry',
    'gostaj@gmail.com',
    '336-345-9089'
),(
    'Mary',
    'Bush',
    'mbush@gmail.com',
    '336-400-9089'
),(
    'Sean',
    'Henry',
    'shenry@gmail.com',
    '336-290-9089'
),(
    'Tyrin',
    'Lester',
    'tlester@gmail.com',
    '336-167-9089'
);

INSERT INTO ticket(
    cinema_room,
    movie_time
)VALUES(
    '24B',
    '4:00 PM'
),(
    '20D',
    '2:00 PM'
),(
    '30E',
    '1:00 PM'
),(
    '25A',
    '11:00 AM'
);

INSERT INTO movie(
    movie_title,
    rating,
    movie_length,
    movie_cast
)VALUES(
    'Prison Break',
    5,
    120,
    'Denzel Washington, Michael Schofield'
),(
    'Breaking Bad',
    4,
    75,
    'Kevin Hart, Elon Musk'
),(
    'Christmas Party',
    3,
    60,
    'Lupita Nyongo, Steve Harvey'
),(
    'Ghost Town',
    2,
    80,
    'John Abrutzi, Sucre Fernandez'
);

INSERT INTO concession(
    snack,
    bevarage,
    cost
)VALUES(
    'Pop-corn',
    'Pepsi',
    20
),(
    'Chips',
    'Fanta',
    15
),(
    'Bread',
    'Coke',
    30
),(
    'Pizza',
    'Sprite',
    10
);

