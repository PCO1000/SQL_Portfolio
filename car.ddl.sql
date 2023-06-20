CREATE TABLE staff(
    staff_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150),
    position VARCHAR(100)
);

CREATE TABLE car(
    car_id SERIAL PRIMARY KEY,
    model VARCHAR(150),
    make VARCHAR(150),
    car_year VARCHAR(50)
);

CREATE TABLE customer(
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150),
    customer_address VARCHAR(150),
    email VARCHAR(150),
    invoice_id INTEGER,
    car_id INTEGER,
    FOREIGN KEY (car_id) REFERENCES car(car_id)
);

CREATE TABLE invoice(
    invoice_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    amount INTEGER,
    invoice_number INTEGER,
    staff_id INTEGER,
    car_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (car_id) REFERENCES car(car_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

ALTER TABLE customer
ADD FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id);

CREATE TABLE bank(
    bank_id SERIAL PRIMARY KEY,
    car_id INTEGER,
    customer_id INTEGER,
    FOREIGN KEY (car_id) REFERENCES car(car_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE service(
    service_id SERIAL PRIMARY KEY,
    invoice_id INTEGER,
    service_date DATE,
    service_type VARCHAR(100),
    staff_id INTEGER,
    car_id INTEGER,
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (car_id) REFERENCES car(car_id)
);

ALTER TABLE car
ADD car_type VARCHAR(150);

ALTER TABLE service
RENAME TO car_service;