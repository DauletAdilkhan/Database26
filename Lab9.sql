-- ============================================================
-- Laboratory Work 9: Stored Procedures and User-Defined Functions
-- Part 1: Database Setup  (CityBike rental network)
-- ============================================================

DROP TABLE IF EXISTS rentals, bikes, members, stations CASCADE;

-- Create table: stations
CREATE TABLE stations (
    station_id   INT PRIMARY KEY,
    station_name VARCHAR(50) NOT NULL,
    city         VARCHAR(40) NOT NULL,
    capacity     INT NOT NULL
);

-- Create table: bikes
CREATE TABLE bikes (
    bike_id    INT PRIMARY KEY,
    model      VARCHAR(50) NOT NULL,
    station_id INT REFERENCES stations(station_id),
    daily_rate NUMERIC(8,2) NOT NULL
);

-- Create table: members
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    full_name VARCHAR(60) NOT NULL,
    city      VARCHAR(40) NOT NULL,
    joined_on DATE NOT NULL
);

-- Create table: rentals
CREATE TABLE rentals (
    rental_id  INT PRIMARY KEY,
    member_id  INT REFERENCES members(member_id),
    bike_id    INT REFERENCES bikes(bike_id),
    start_date DATE NOT NULL,
    end_date   DATE,
    fee        NUMERIC(8,2)
);

INSERT INTO stations VALUES
 (10, 'Central Park', 'Almaty',   4),
 (20, 'Riverside',    'Almaty',   3),
 (30, 'Expo Gate',    'Astana',   5),
 (40, 'Old Town',     'Shymkent', 2),
 (50, 'Depot',        'Astana',   0);

INSERT INTO bikes VALUES
 (101, 'City Cruiser', 10,  4.50),
 (102, 'City Cruiser', 10,  4.50),
 (103, 'Mountain X',   20,  7.00),
 (104, 'Mountain X',   30,  7.00),
 (105, 'Road Sprint',  30,  9.25),
 (106, 'Folding Mini', 40,  3.75),
 (107, 'Cargo Hauler', 20, 12.00),
 (108, 'Road Sprint',  10,  9.25);

INSERT INTO members VALUES
 (1, 'Aisha Nurlanova', 'Almaty',   DATE '2023-03-14'),
 (2, 'Daniyar Serik',   'Almaty',   DATE '2023-07-02'),
 (3, 'Marta Kowalski',  'Astana',   DATE '2024-01-20'),
 (4, 'Chen Wei',        'Astana',   DATE '2024-05-11'),
 (5, 'Omar Haddad',     'Shymkent', DATE '2024-09-30'),
 (6, 'Elena Petrova',   'Almaty',   DATE '2025-02-05');

INSERT INTO rentals VALUES
 ( 1, 1, 101, DATE '2024-04-05', DATE '2024-04-08', 13.50),
 ( 2, 1, 103, DATE '2024-06-11', DATE '2024-06-16', 35.00),
 ( 3, 1, 108, DATE '2025-02-02', DATE '2025-02-04', 18.50),
 ( 4, 1, 102, DATE '2025-05-20', DATE '2025-05-27', 31.50),
 ( 5, 2, 101, DATE '2024-05-01', DATE '2024-05-02',  4.50),
 ( 6, 2, 107, DATE '2024-11-15', DATE '2024-11-19', 48.00),
 ( 7, 2, 107, DATE '2025-03-08', DATE '2025-03-14', 72.00),
 ( 8, 3, 104, DATE '2024-02-14', DATE '2024-02-18', 28.00),
 ( 9, 3, 105, DATE '2024-08-03', DATE '2024-08-06', 27.75),
 (10, 3, 104, DATE '2025-01-09', DATE '2025-01-10',  7.00),
 (11, 3, 105, DATE '2025-06-01', DATE '2025-06-09', 74.00),
 (12, 4, 104, DATE '2024-07-19', DATE '2024-07-21', 14.00),
 (13, 4, 105, DATE '2025-04-12', DATE '2025-04-15', 27.75),
 (14, 4, 103, DATE '2025-07-23', DATE '2025-07-29', 42.00),
 (15, 5, 106, DATE '2024-10-05', DATE '2024-10-12', 26.25),
 (16, 5, 106, DATE '2025-01-18', DATE '2025-01-20',  7.50),
 (17, 5, 106, DATE '2025-08-14', DATE '2025-08-21', 26.25),
 (18, 2, 102, DATE '2025-09-02', DATE '2025-09-05', 13.50),
 (19, 1, 101, DATE '2025-10-10', NULL,              NULL),
 (20, 4, 108, DATE '2024-12-28', DATE '2025-01-03', 55.50),
 (21, 3, 103, DATE '2025-02-26', DATE '2025-03-02', 28.00),
 (22, 5, 104, DATE '2025-05-05', DATE '2025-05-08', 21.00);


SELECT (SELECT COUNT(*) FROM stations) AS stations,
       (SELECT COUNT(*) FROM bikes)    AS bikes,
       (SELECT COUNT(*) FROM members)  AS members,
       (SELECT COUNT(*) FROM rentals)  AS rentals;



--Part 2
CREATE OR REPLACE FUNCTION inc(val INTEGER) RETURNS INTEGER AS $$
DECLARE
result INTEGER;
BEGIN
result := val + 1;
RETURN result;
END; $$
LANGUAGE plpgsql;
SELECT inc(10);        -- 11


--2.1
CREATE OR REPLACE FUNCTION rental_days(p_rental_id INT)
RETURNS INT AS $$
DECLARE
    v_days INT;
BEGIN
    SELECT end_date - start_date INTO v_days
    FROM rentals WHERE rental_id = p_rental_id;
    RETURN v_days;
END;
$$ LANGUAGE plpgsql;

drop function rental_days(INTEGER);


SELECT rental_days(2);
SELECT rental_days(11);-- rental 2 ran from 2024-06-11 to 2024-06-16

SELECT rental_days(19);
SELECT rental_days(999);
--no because rental 19 have the null date, in 999 we dont have rental id

--2.2
create or replace function member_rental_count(p_member_id int )
returns int as $$
    declare
    v_count int;
    begin
        select count(*) into v_count from rentals
        where member_id = p_member_id;
        return v_count;
        end;
    $$ language plpgsql;

select member_rental_count(1); --5
select member_rental_count(5); --4
select member_rental_count(6); --0


-- Exercise 2.3
CREATE OR REPLACE FUNCTION station_city(p_station_id INT)
RETURNS VARCHAR AS $$
DECLARE
    v_city VARCHAR;
BEGIN
    SELECT city INTO v_city FROM stations
    WHERE station_id = p_station_id;
    RETURN v_city;
END;
$$ LANGUAGE plpgsql;

SELECT station_city(30); -- Astana
SELECT station_city(77); -- NULL

-- Exercise 2.4
SELECT rental_id, member_id, rental_days(rental_id) AS duration_days
FROM rentals
WHERE rental_days(rental_id) > 4
ORDER BY duration_days DESC;

-- ============================================================
-- PART 3. PARAMETER MODES
-- ============================================================

-- Exercise 3.1
CREATE OR REPLACE FUNCTION fee_with_discount(p_fee NUMERIC, p_percent NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN ROUND(p_fee * (1 - p_percent / 100), 2);
END;
$$ LANGUAGE plpgsql;

SELECT fee_with_discount(74.00, 15); -- 62.90

-- Exercise 3.2
CREATE OR REPLACE FUNCTION member_stats(
    p_member_id INT,
    OUT rental_cnt INT,
    OUT total_fee NUMERIC,
    OUT last_start DATE
) AS $$
BEGIN
    SELECT COUNT(*)::INT, COALESCE(SUM(fee), 0), MAX(start_date)
    INTO rental_cnt, total_fee, last_start
    FROM rentals WHERE member_id = p_member_id;
END;
$$ LANGUAGE plpgsql;

SELECT member_stats(3);
SELECT * FROM member_stats(3);
SELECT * FROM member_stats(6); -- 0, 0, NULL

-- Exercise 3.3
CREATE OR REPLACE FUNCTION apply_late_fee(INOUT p_fee NUMERIC) AS $$
BEGIN
    p_fee := p_fee + 5.00;
END;
$$ LANGUAGE plpgsql;

SELECT apply_late_fee((SELECT fee FROM rentals WHERE rental_id = 1)); -- 18.50

-- Exercise 3.4
CREATE OR REPLACE FUNCTION fee_summary(
    VARIADIC p_fees NUMERIC[],
    OUT total NUMERIC,
    OUT average NUMERIC,
    OUT largest NUMERIC
) AS $$
BEGIN
    SELECT COALESCE(SUM(p_fees[g.i]), 0),
           ROUND(AVG(p_fees[g.i]), 2),
           MAX(p_fees[g.i])
    INTO total, average, largest
    FROM generate_subscripts(p_fees, 1) AS g(i);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fee_summary(13.50, 35.00, 18.50, 31.50);
SELECT * FROM fee_summary(); -- total 0; average/largest NULL

-- Exercise 3.5 (written answer in report):
-- (a) IN; (b) INOUT; (c) VARIADIC; (d) OUT parameters.

-- ============================================================
-- PART 4. DEFAULTS AND OVERLOADING
-- ============================================================

-- Exercise 4.1: one-argument version
CREATE OR REPLACE FUNCTION total_fees(p_member_id INT)
RETURNS NUMERIC AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(fee), 0) INTO v_total
    FROM rentals WHERE member_id = p_member_id;
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

SELECT total_fees(1); -- 99.00 (includes NULL fee as ignored)
SELECT total_fees(6); -- 0

-- Exercise 4.2: overloaded two-argument version
CREATE OR REPLACE FUNCTION total_fees(p_member_id INT, p_from_date DATE)
RETURNS NUMERIC AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(fee), 0) INTO v_total
    FROM rentals
    WHERE member_id = p_member_id AND start_date >= p_from_date;
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

SELECT total_fees(1, DATE '2024-01-01'); -- 99.00
SELECT total_fees(1, DATE '2025-01-01'); -- 50.00

-- Exercise 4.3: Demonstration of DEFAULT ambiguity.
-- PostgreSQL may reject creation of this overload when the one-argument
-- version already exists (ambiguous call/overlapping signatures).
-- To test the lab's intended runtime ambiguity, run the following
-- CREATE after the two-argument version exists:
-- CREATE OR REPLACE FUNCTION total_fees(p_member_id INT,
--     p_from_date DATE DEFAULT DATE '2025-01-01')
-- RETURNS NUMERIC AS $$
-- BEGIN
--   RETURN total_fees(p_member_id, p_from_date);
-- END;
-- $$ LANGUAGE plpgsql;
-- Then SELECT total_fees(1); -- ambiguous due to both one-arg candidates.

-- Exercise 4.4
DROP FUNCTION total_fees(INTEGER);
SELECT total_fees(1); -- default-date overload; 50.00

-- Exercise 4.5
CREATE OR REPLACE FUNCTION total_fees(p_member_name VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(r.fee), 0) INTO v_total
    FROM members m LEFT JOIN rentals r ON r.member_id = m.member_id
    WHERE m.full_name = p_member_name;
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

SELECT total_fees('Aisha Nurlanova'); -- VARCHAR/name overload: 99.00
SELECT total_fees(1); -- integer/date overload with default: 50.00

-- ============================================================
-- PART 5. TABLE-RETURNING FUNCTIONS
-- ============================================================

-- Exercise 5.1
CREATE OR REPLACE FUNCTION find_bikes(p_pattern VARCHAR)
RETURNS TABLE(found_id INT, found_model VARCHAR, found_rate NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT b.bike_id, b.model::VARCHAR, b.daily_rate
    FROM bikes b
    WHERE b.model ILIKE p_pattern
    ORDER BY b.bike_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_bikes('%road%');
SELECT * FROM find_bikes('%Mini');
-- SELECT find_bikes('%road%'); returns each composite row as one column.

-- Exercise 5.2
CREATE OR REPLACE FUNCTION member_history(p_member_id INT)
RETURNS TABLE(
    rental_id INT, bike_model VARCHAR, station_name VARCHAR,
    duration_days INT, rental_fee NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT r.rental_id, b.model::VARCHAR, s.station_name::VARCHAR,
           (r.end_date - r.start_date)::INT, r.fee
    FROM rentals r
    JOIN bikes b ON b.bike_id = r.bike_id
    JOIN stations s ON s.station_id = b.station_id
    WHERE r.member_id = p_member_id
    ORDER BY r.start_date;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM member_history(3);

-- Exercise 5.3: avoid output-variable/column name collision
CREATE OR REPLACE FUNCTION bike_list(p_station_id INT)
RETURNS TABLE(out_bike_id INT, out_model VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT b.bike_id, b.model::VARCHAR
    FROM bikes b WHERE b.station_id = p_station_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM bike_list(10);

-- Alternative fix, keeping output names bike_id and model:
-- CREATE OR REPLACE FUNCTION bike_list(p_station_id INT)
-- RETURNS TABLE(bike_id INT, model VARCHAR) AS $$
-- BEGIN
--   RETURN QUERY
--   SELECT b.bike_id, b.model::VARCHAR FROM bikes b
--   WHERE b.station_id = p_station_id;
-- END;
-- $$ LANGUAGE plpgsql;

-- Exercise 5.4
CREATE OR REPLACE FUNCTION station_board(p_city VARCHAR)
RETURNS TABLE(s_name VARCHAR, s_bikes INT, s_free INT) AS $$
BEGIN
    RETURN QUERY
    SELECT s.station_name::VARCHAR,
           COUNT(b.bike_id)::INT,
           (s.capacity - COUNT(b.bike_id))::INT
    FROM stations s
    LEFT JOIN bikes b ON b.station_id = s.station_id
    WHERE s.city = p_city
    GROUP BY s.station_id, s.station_name, s.capacity
    ORDER BY s.station_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM station_board('Almaty');
-- Without COUNT(*)::INT, the return type mismatch is BIGINT vs INT.

-- ============================================================
-- PART 6. BLOCKS, DO AND SUBBLOCKS
-- ============================================================

-- Exercise 6.1
DO $$
<<rental_report>>
DECLARE
    total_rentals INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO total_rentals FROM rentals;
    RAISE NOTICE 'The rentals table holds % rows.', total_rentals;
END rental_report;
$$;

-- Exercise 6.2
DO $$
<<fee_blocks>>
DECLARE
    fee_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(fee), 0) INTO fee_total FROM rentals;
    RAISE NOTICE 'Outer before: %', fee_total;

    DECLARE
        fee_total NUMERIC;
    BEGIN
        SELECT COALESCE(SUM(fee), 0) INTO fee_total
        FROM rentals WHERE start_date >= DATE '2025-01-01';
        RAISE NOTICE 'Inner: %', fee_total;
        RAISE NOTICE 'Outer from inner: %', fee_blocks.fee_total;
    END;

    RAISE NOTICE 'Outer after: %', fee_total;
END fee_blocks;
$$;

-- Exercise 6.3: local variable visibility (intentionally invalid example)
-- This block would fail if a later subblock tries to reference a variable
-- declared only in an earlier subblock:
-- DO $$ BEGIN
--   DECLARE inner_only INT := 1;
--   BEGIN NULL; END;
--   DECLARE another INT;
--   BEGIN RAISE NOTICE '%', inner_only; END;
-- END $$;
-- Correct approach: declare shared_var in the outer DECLARE section.

-- Exercise 6.4
CREATE OR REPLACE FUNCTION fee_split(
    p_from_date DATE,
    OUT before_total NUMERIC,
    OUT after_total NUMERIC
) AS $$
BEGIN
    SELECT COALESCE(SUM(fee) FILTER (WHERE start_date < p_from_date), 0),
           COALESCE(SUM(fee) FILTER (WHERE start_date >= p_from_date), 0)
    INTO before_total, after_total
    FROM rentals;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fee_split(DATE '2025-01-01');

-- ============================================================
-- PART 7. PRACTICAL SCENARIOS
-- ============================================================

-- Exercise 7.1
CREATE OR REPLACE FUNCTION station_load(
    p_station_id INT,
    OUT bikes_parked INT,
    OUT capacity_pct NUMERIC
) AS $$
DECLARE
    v_capacity INT;
BEGIN
    SELECT s.capacity, COUNT(b.bike_id)::INT
    INTO v_capacity, bikes_parked
    FROM stations s LEFT JOIN bikes b ON b.station_id = s.station_id
    WHERE s.station_id = p_station_id
    GROUP BY s.capacity;

    capacity_pct := CASE
        WHEN v_capacity = 0 THEN 0
        ELSE ROUND(bikes_parked::NUMERIC * 100 / v_capacity, 1)
    END;
END;
$$ LANGUAGE plpgsql;

SELECT s.station_id, s.station_name, l.*
FROM stations s, LATERAL station_load(s.station_id) l;

-- Exercise 7.2
CREATE OR REPLACE FUNCTION top_members(p_limit INT DEFAULT 3)
RETURNS TABLE(member_name VARCHAR, rental_count BIGINT, amount_spent NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT m.full_name::VARCHAR, COUNT(r.rental_id),
           COALESCE(SUM(r.fee), 0)
    FROM members m LEFT JOIN rentals r ON r.member_id = m.member_id
    GROUP BY m.member_id, m.full_name
    ORDER BY COALESCE(SUM(r.fee), 0) DESC, m.member_id
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM top_members();
SELECT * FROM top_members(6);

-- Exercise 7.3
CREATE OR REPLACE FUNCTION rental_invoice(p_rental_id INT)
RETURNS TABLE(
    member_name VARCHAR, bike_model VARCHAR, duration_days INT,
    amount_owed NUMERIC, rental_status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT m.full_name::VARCHAR, b.model::VARCHAR,
           (COALESCE(r.end_date, CURRENT_DATE) - r.start_date)::INT,
           ROUND((COALESCE(r.end_date, CURRENT_DATE) - r.start_date)
                 * b.daily_rate, 2),
           CASE WHEN r.end_date IS NULL THEN 'OPEN'::VARCHAR
                ELSE 'CLOSED'::VARCHAR END
    FROM rentals r
    JOIN members m ON m.member_id = r.member_id
    JOIN bikes b ON b.bike_id = r.bike_id
    WHERE r.rental_id = p_rental_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM rental_invoice(11);
SELECT * FROM rental_invoice(19);

-- Exercise 7.4 (two overloads)
CREATE OR REPLACE FUNCTION city_report(p_city VARCHAR)
RETURNS TABLE(member_count BIGINT, rental_count BIGINT, revenue NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(DISTINCT m.member_id), COUNT(r.rental_id),
           COALESCE(SUM(r.fee), 0)
    FROM members m LEFT JOIN rentals r ON r.member_id = m.member_id
    WHERE m.city = p_city;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION city_report(p_city VARCHAR, p_from_date DATE)
RETURNS TABLE(member_count BIGINT, rental_count BIGINT, revenue NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(DISTINCT m.member_id), COUNT(r.rental_id),
           COALESCE(SUM(r.fee), 0)
    FROM members m
    LEFT JOIN rentals r
      ON r.member_id = m.member_id AND r.start_date >= p_from_date
    WHERE m.city = p_city;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM city_report('Almaty');
SELECT * FROM city_report('Almaty', DATE '2025-01-01');

-- ============================================================
-- LAB QUESTIONS: answers are included as SQL comments
-- ============================================================
-- 1. Name is the identifier; signature is name + argument types/modes.
--    DROP needs the signature to distinguish overloaded functions.
-- 2. $$ marks the function body, allowing ordinary single quotes inside:
--    BEGIN RAISE NOTICE 'It's ready'; END; (without dollar quotes escaping is needed)
-- 3. OUT is convenient for a small fixed set of scalar outputs; RETURNS TABLE
--    is better for row sets, composability, and explicit output-column names.
-- 4. VARIADIC must be last because otherwise PostgreSQL cannot know where the
--    variable-length arguments end and later fixed arguments begin.
-- 5. RETURN returns a scalar/record or exits; RETURN QUERY appends rows
--    from a query in a set-returning function.
-- 6. DEFAULT creates an implicit shorter call signature and can overlap an
--    existing overload. Avoid overlapping overloads, drop/recreate carefully,
--    and test calls before deployment.
-- 7. A subblock variable ceases to be accessible after END; shadowed outer
--    variable is referenced as outer_block_label.variable_name.
-- 8. Advantage: centralised, consistent rules and reduced round trips.
--    Disadvantage: database-specific code is harder to test/version and scales DB CPU.
-- 9. Trusted PL/pgSQL cannot access outside resources; ordinary users with
--    suitable privileges may create it. Untrusted PL/Python can access OS/network
--    and normally requires superuser privileges to install/use.
-- 10. CREATE OR REPLACE cannot change an existing function's argument types;
--     it creates a separate overload/signature, which may cause ambiguity or
--     leave the old function in place.

-- ============================================================
-- OPTIONAL CHALLENGES (if required)
-- ============================================================

-- Challenge 1
CREATE OR REPLACE FUNCTION busiest_station(
    p_from_date DATE DEFAULT DATE '2024-01-01'
)
RETURNS TABLE(station_id INT, station_name VARCHAR, total_rented_days BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT s.station_id, s.station_name::VARCHAR,
           SUM(COALESCE(r.end_date, CURRENT_DATE) - r.start_date)::BIGINT
    FROM stations s
    JOIN bikes b ON b.station_id = s.station_id
    JOIN rentals r ON r.bike_id = b.bike_id
    WHERE r.start_date >= p_from_date
    GROUP BY s.station_id, s.station_name
    ORDER BY SUM(COALESCE(r.end_date, CURRENT_DATE) - r.start_date) DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Challenge 2
DO $$
DECLARE rec RECORD;
BEGIN
    FOR rec IN
        SELECT m.full_name, COUNT(r.rental_id) AS rentals,
               COALESCE(SUM(r.fee), 0) AS spent
        FROM members m LEFT JOIN rentals r ON r.member_id = m.member_id
        GROUP BY m.member_id, m.full_name
        ORDER BY m.member_id
    LOOP
        RAISE NOTICE '%: % rentals, total %', rec.full_name, rec.rentals, rec.spent;
    END LOOP;
END;
$$;

-- Challenge 3: stricter rental_days (raises an exception for unknown ID)
-- Replace the earlier function body with:
-- CREATE OR REPLACE FUNCTION rental_days(p_rental_id INT) RETURNS INT AS $$
-- DECLARE v_days INT;
-- BEGIN
--   SELECT end_date - start_date INTO v_days FROM rentals
--   WHERE rental_id = p_rental_id;
--   IF NOT FOUND THEN
--     RAISE EXCEPTION 'Rental id % does not exist', p_rental_id;
--   END IF;
--   RETURN v_days;
-- END; $$ LANGUAGE plpgsql;

-- Challenge 4
CREATE OR REPLACE FUNCTION fee_report(p_member_id INT)
RETURNS NUMERIC AS $$ BEGIN RETURN total_fees(p_member_id); END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fee_report(p_member_name VARCHAR)
RETURNS NUMERIC AS $$ BEGIN RETURN total_fees(p_member_name); END; $$ LANGUAGE plpgsql;
-- fee_report(TEXT) is another distinct signature and may be created; string
-- literals can become ambiguous depending on overload resolution/casts.

-- Challenge 5: PostgreSQL procedure (transactional data change)
CREATE OR REPLACE PROCEDURE close_rental(p_rental_id INT, p_end_date DATE)
LANGUAGE plpgsql AS $$
DECLARE v_rate NUMERIC;
BEGIN
    SELECT b.daily_rate INTO v_rate
    FROM rentals r JOIN bikes b ON b.bike_id = r.bike_id
    WHERE r.rental_id = p_rental_id AND r.end_date IS NULL;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No open rental with id %', p_rental_id;
    END IF;
    UPDATE rentals
    SET end_date = p_end_date,
        fee = (p_end_date - start_date) * v_rate
    WHERE rental_id = p_rental_id;
END;
$$;
-- Example: CALL close_rental(19, CURRENT_DATE);
-- Procedures are invoked with CALL and can manage transactions (COMMIT/ROLLBACK
-- in permitted contexts); functions are called in SQL expressions and cannot
-- perform transaction control.
