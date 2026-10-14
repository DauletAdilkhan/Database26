--1.1
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);

--1.2
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0
        AND discount_price > 0
        AND discount_price < regular_price
    )
);

--1.3
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER,
    CHECK (num_guests BETWEEN 1 AND 10),
    CHECK (check_out_date > check_in_date)
);

--1.4 valid data
INSERT INTO employees VALUES
(1, 'John', 'Smith', 25, 300000),
(2, 'Anna', 'Brown', 40, 450000);

INSERT INTO products_catalog VALUES
(1, 'Laptop', 500000, 450000),
(2, 'Phone', 300000, 270000);

INSERT INTO bookings VALUES
(1, '2026-10-15', '2026-10-18', 2),
(2, '2026-11-01', '2026-11-05', 5);

--invalid data

INSERT INTO employees VALUES
(3, 'Mike', 'Green', 16, 200000);

INSERT INTO employees VALUES
(4, 'David', 'White', 70, 250000);

INSERT INTO employees VALUES
(5, 'Kate', 'Black', 30, 0);

INSERT INTO employees VALUES
(6, 'Tom', 'Gray', 35, -1000);

INSERT INTO products_catalog VALUES
(3, 'Tablet', 0, 100);

INSERT INTO products_catalog VALUES
(4, 'Monitor', 100000, 0);

INSERT INTO products_catalog VALUES
(5, 'Keyboard', 10000, 12000);

INSERT INTO products_catalog VALUES
(6, 'Mouse', 5000, 5000);

INSERT INTO bookings VALUES
(3, '2026-10-20', '2026-10-22', 0);

INSERT INTO bookings VALUES
(4, '2026-10-20', '2026-10-22', 11);

INSERT INTO bookings VALUES
(5, '2026-10-25', '2026-10-22', 3);

INSERT INTO bookings VALUES
(6, '2026-10-25', '2026-10-25', 2);

--2.1
CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

--2.2
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

--2.3
INSERT INTO customers VALUES
(1, 'john@example.com', '+77011234567', '2026-10-10'),
(2, 'anna@example.com', '+77017654321', '2026-10-11');

INSERT INTO inventory VALUES
(1, 'Laptop', 10, 350000, '2026-10-13 10:00:00'),
(2, 'Mouse', 25, 5000, '2026-10-13 11:30:00');

--null to not null 

INSERT INTO customers VALUES
(NULL, 'test@example.com', '+77011234567', '2026-10-12');

INSERT INTO customers VALUES
(3, NULL, '+77011234567', '2026-10-12');

INSERT INTO customers VALUES
(4, 'test@example.com', '+77011234567', NULL);

INSERT INTO inventory VALUES
(NULL, 'Keyboard', 10, 15000, '2026-10-13 12:00:00');

INSERT INTO inventory VALUES
(3, NULL, 10, 15000, '2026-10-13 12:00:00');

INSERT INTO inventory VALUES
(4, 'Monitor', NULL, 100000, '2026-10-13 12:00:00');

INSERT INTO inventory VALUES
(5, 'Headphones', 5, NULL, '2026-10-13 12:00:00');

INSERT INTO inventory VALUES
(6, 'Webcam', 8, 20000, NULL);

INSERT INTO customers VALUES
(5, 'alex@example.com', NULL, '2026-10-13');

INSERT INTO customers VALUES
(6, 'maria@example.com', NULL, '2026-10-13');

--3.1
CREATE TABLE users (
    user_id INTEGER,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP
);

--3.2
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    UNIQUE (student_id, course_code, semester)
);

--3.3
ALTER TABLE users
ADD CONSTRAINT unique_username UNIQUE (username);

ALTER TABLE users
ADD CONSTRAINT unique_email UNIQUE (email);

--unique 
INSERT INTO users VALUES
(1, 'duman', 'duman@example.com', '2026-10-13 10:00:00'),
(2, 'alex', 'alex@example.com', '2026-10-13 11:00:00');

--not unique
INSERT INTO users VALUES
(4, 'newuser', 'duman@example.com', '2026-10-13 13:00:00');


--4.1
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

INSERT INTO departments VALUES
(1, 'IT', 'Almaty'),
(2, 'Finance', 'Astana'),
(3, 'Marketing', 'Shymkent');

INSERT INTO departments VALUES
(1, 'HR', 'Almaty');

INSERT INTO departments VALUES
(NULL, 'Sales', 'Astana');


--4.2
CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

--4.3
-- PRIMARY KEY vs. UNIQUE:
--   PRIMARY KEY: Uniquely identifies a row, cannot be NULL, only one allowed per table.
--   UNIQUE: Guarantees distinct values, allows NULL, multiple allowed per table.
-- Single-Column vs. Composite PRIMARY KEY:
--   Single-Column: Use in most cases (e.g., auto-increment ID, UUID) — simpler foreign keys and cleaner JOINs.
--   Composite: Use when uniqueness requires a combination of columns (e.g., many-to-many junction tables: student_id + course_id).
-- Why only one PRIMARY KEY but multiple UNIQUE constraints?
--   A table has only one primary identity (which often dictates the physical order of data storage on disk).
--   Secondary unique fields (like email or username) are protected using additional UNIQUE constraints.


--5.1
CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);

INSERT INTO employees_dept VALUES
(1, 'John Smith', 1, '2026-01-15'),
(2, 'Anna Brown', 2, '2026-02-10'),
(3, 'Mike Wilson', 3, '2026-03-05');

INSERT INTO employees_dept VALUES
(4, 'David Green', 99, '2026-04-01');

--5.2
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

INSERT INTO authors VALUES
(1, 'George Orwell', 'United Kingdom'),
(2, 'J.K. Rowling', 'United Kingdom'),
(3, 'Abai Qunanbaiuly', 'Kazakhstan');

INSERT INTO publishers VALUES
(1, 'Penguin Books', 'London'),
(2, 'Bloomsbury', 'London'),
(3, 'Kazakh Press', 'Almaty');

INSERT INTO books VALUES
(1, '1984', 1, 1, 1949, '9780451524935'),
(2, 'Harry Potter', 2, 2, 1997, '9780747532699'),
(3, 'Words of Edification', 3, 3, 1890, '9786010000001');

SELECT
    b.title,
    a.author_name,
    p.publisher_name,
    b.publication_year,
    b.isbn
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN publishers p ON b.publisher_id = p.publisher_id;

--5.3
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id)
        ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id)
        ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);

INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Books');

INSERT INTO products_fk VALUES
(1, 'Laptop', 1),
(2, 'Keyboard', 1),
(3, 'Novel', 2);

INSERT INTO orders VALUES
(101, '2026-10-10'),
(102, '2026-10-11');

INSERT INTO order_items VALUES
(1, 101, 1, 1),
(2, 101, 2, 2),
(3, 102, 3, 1);

DELETE FROM categories
WHERE category_id = 1;

SELECT * FROM categories;
SELECT * FROM products_fk;

DELETE FROM orders
WHERE order_id = 101;

SELECT * FROM orders;

SELECT * FROM order_items
ORDER BY item_id;


--6.1
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL
        REFERENCES customers(customer_id)
        ON DELETE RESTRICT,
    order_date DATE NOT NULL,
    total_amount NUMERIC(12, 2) NOT NULL
        CHECK (total_amount >= 0),
    status TEXT NOT NULL CHECK (
        status IN (
            'pending',
            'processing',
            'shipped',
            'delivered',
            'cancelled'
        )
    )
);

CREATE TABLE order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL
        REFERENCES orders(order_id)
        ON DELETE CASCADE,
    product_id INTEGER NOT NULL
        REFERENCES products(product_id)
        ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL
        CHECK (unit_price >= 0)
);

INSERT INTO customers VALUES
(1, 'Duman Muratkul', 'duman@example.com',
    '+77011234567', '2026-01-10'),
(2, 'Alex Brown', 'alex@example.com',
    '+77012345678', '2026-02-15'),
(3, 'Anna Smith', 'anna@example.com',
    NULL, '2026-03-01'),
(4, 'David Wilson', 'david@example.com',
    '+77019876543', '2026-04-20'),
(5, 'Maria Green', 'maria@example.com',
    NULL, '2026-05-12');


INSERT INTO products VALUES
(1, 'Laptop', 'Gaming laptop', 450000.00, 10),
(2, 'Mouse', 'Wireless mouse', 12000.00, 50),
(3, 'Keyboard', 'Mechanical keyboard', 25000.00, 30),
(4, 'Monitor', '27-inch monitor', 110000.00, 15),
(5, 'Headphones', 'Wireless headphones', 35000.00, 20);


INSERT INTO orders VALUES
(101, 1, '2026-09-01', 474000.00, 'delivered'),
(102, 2, '2026-09-05', 37000.00, 'shipped'),
(103, 3, '2026-09-10', 110000.00, 'processing'),
(104, 4, '2026-09-15', 35000.00, 'pending'),
(105, 5, '2026-09-20', 25000.00, 'cancelled');


INSERT INTO order_details VALUES
(1, 101, 1, 1, 450000.00),
(2, 101, 2, 2, 12000.00),
(3, 102, 3, 1, 25000.00),
(4, 102, 5, 1, 12000.00),
(5, 103, 4, 1, 110000.00);


INSERT INTO customers VALUES
(1, 'Another Customer', 'another@example.com',
    NULL, '2026-10-01');


INSERT INTO customers VALUES
(6, 'New Customer', 'duman@example.com',
    NULL, '2026-10-01');


INSERT INTO customers VALUES
(6, NULL, 'new@example.com',
    NULL, '2026-10-01');

INSERT INTO products VALUES
(6, 'Bad Product', 'Invalid price', -100.00, 10);

INSERT INTO products VALUES
(6, 'Bad Product', 'Invalid stock', 1000.00, -5);

INSERT INTO orders VALUES
(106, 999, '2026-10-01', 1000.00, 'pending');

INSERT INTO orders VALUES
(106, 1, '2026-10-01', 1000.00, 'refunded');

INSERT INTO order_details VALUES
(6, 101, 2, 0, 12000.00);

INSERT INTO order_details VALUES
(6, 101, 999, 1, 1000.00);

DELETE FROM customers
WHERE customer_id = 1;

SELECT *
FROM order_details
WHERE order_id = 101;

DELETE FROM orders
WHERE order_id = 101;

SELECT *
FROM order_details
WHERE order_id = 101;

DELETE FROM products
WHERE product_id = 1;

SELECT
    c.name AS customer_name,
    o.order_id,
    o.order_date,
    o.status,
    p.name AS product_name,
    od.quantity,
    od.unit_price,
    od.quantity * od.unit_price AS subtotal
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN products p
    ON od.product_id = p.product_id
ORDER BY o.order_id;


SELECT 'customers' AS table_name, COUNT(*) AS total_records
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_details', COUNT(*)
FROM order_details;
