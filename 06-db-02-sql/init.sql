--task2
-- CREATE DATABASE test_db; - указали при старте контейнера env POSTGRES_DB=test_db,
-- при наличии POSTGRES_DB автоматически создает базу

CREATE TABLE orders (
    id      serial PRIMARY KEY,
    title   varchar(100) NOT NULL,
    price   integer NOT NULL
);
CREATE TABLE clients (
    id              serial PRIMARY KEY,
    last_name       varchar(40),
    accommodation   varchar(40),
    order_id        integer,
    FOREIGN KEY (order_id) REFERENCES orders (id)
);
CREATE INDEX accommodation_idx ON clients (accommodation);
CREATE INDEX order_id_idx ON clients (order_id);

CREATE USER "test-admin-user" WITH PASSWORD 'admin';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "test-admin-user";

CREATE USER "test-simple-user" WITH PASSWORD 'simple';
GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-simple-user";

--task3
INSERT INTO orders(title, price)
VALUES ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);

INSERT INTO clients(last_name, accommodation)
VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'),
('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');

-- task 4
UPDATE clients SET order_id = orders.id FROM orders
WHERE clients.last_name = 'Иванов Иван Иванович' AND orders.title = 'Книга';

UPDATE clients SET order_id = orders.id FROM orders
WHERE clients.last_name = 'Петров Петр Петрович' AND orders.title = 'Монитор';

UPDATE clients SET order_id = orders.id FROM orders
WHERE clients.last_name = 'Иоганн Себастьян Бах' AND orders.title = 'Гитара';
