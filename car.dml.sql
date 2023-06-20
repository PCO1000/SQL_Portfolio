INSERT INTO customer(
    full_name,
    customer_address,
    email
)VALUES(
    'Josh Hosan',
    '23 South Street',
    'jhosan@gmail.com'
),(
    'Angel Tom',
    '12 South Street',
    'atom@gmail.com'
);

INSERT INTO car(
    model,
    make,
    car_year,
    car_type
)VALUES(
    'Toyota',
    'Camry',
    '2015',
    'Sedan'
), (
    'Honda',
    'Accord',
    '2016',
    'Sedan'
);

INSERT INTO invoice(
    amount,
    invoice_number
) VALUES(
    300,
    12
),(
    500,
    9
);

INSERT INTO bank(
    car_id,
    customer_id
)VALUES(
    1,
    1
),(
    2,
    2
);

INSERT INTO car_service(
    service_date,
    service_type
)VALUES(
    '02-23-2023', 
    'Oil Change'
), (
    '03-15-2022', 
    'Engine Replacement'
);

INSERT INTO staff(
    full_name,
    position
)VALUES(
    'Musa Hamza',
    'Salesperson'
),(
    'John Paul',
    'Mechanic'
);

SELECT *
FROM staff;