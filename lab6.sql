-- 1.1
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2)
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    budget DECIMAL(10, 2)
);


--1.2
INSERT INTO employees VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);

INSERT INTO departments VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');

INSERT INTO projects VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);

-- 2.1
SELECT e.emp_name, d.dept_name
FROM employees e
CROSS JOIN departments d;
- 20rows = 5*4


-a Comma notation
SELECT e.emp_name, d.dept_name
FROM employees e, departments d;


-b INNER JOIN with true
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON TRUE;

-2.3
SELECT e.emp_name, p.project_name
FROM employees e
CROSS JOIN projects p;

--3
---3.1
SELECT e.emp_name, d.dept_name, d.location
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id;

---3.2
SELECT emp_name, dept_name, location
FROM employees
INNER JOIN departments USING (dept_id);


---3.3
SELECT emp_name, dept_name, location
FROM employees
NATURAL INNER JOIN departments;


---3.4
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
INNER JOIN projects p
ON d.dept_id = p.dept_id;


---4.1
SELECT e.emp_name, e.dept_id AS emp_dept,
       d.dept_id AS dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id;

---4.2
SELECT e.emp_name, e.dept_id AS emp_dept,
       d.dept_id AS dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id;

---4.3
SELECT e.emp_name, e.dept_id
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;


---4.4
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;


--5
---5.1
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id;


---5.2
SELECT e.emp_name, d.dept_name
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id;


---5.3
SELECT d.dept_name, d.location
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;

--6
---6.1
SELECT e.emp_name,
       e.dept_id AS emp_dept,
       d.dept_id AS dept_dept,
       d.dept_name
FROM employees e
FULL JOIN departments d
ON e.dept_id = d.dept_id;


---6.2
SELECT d.dept_name, p.project_name, p.budget
FROM departments d
FULL JOIN projects p
ON d.dept_id = p.dept_id;


---6.3
SELECT
    CASE
        WHEN e.emp_id IS NULL
            THEN 'Department without employees'
        WHEN d.dept_id IS NULL
            THEN 'Employee without department'
        ELSE 'Matched'
    END AS record_status,
    e.emp_name,
    d.dept_name
FROM employees e
FULL JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL
   OR d.dept_id IS NULL;

--7
---7.1
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
AND d.location = 'Building A';

---7.2
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';


---7.3
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
AND d.location = 'Building A';


SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';


--8
---8.1
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    p.project_name,
    p.budget
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
LEFT JOIN projects p
ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

---8.2
ALTER TABLE employees
ADD COLUMN manager_id INT;

UPDATE employees SET manager_id = 3 WHERE emp_id = 1;
UPDATE employees SET manager_id = 3 WHERE emp_id = 2;
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees SET manager_id = 3 WHERE emp_id = 4;
UPDATE employees SET manager_id = 3 WHERE emp_id = 5;


SELECT
    e.emp_name AS employee,
    m.emp_name AS manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id;

---8.3
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;



-Part 9. Lab Questions
1. What is the difference between INNER JOIN and LEFT JOIN?

INNER JOIN returns only matching rows. LEFT JOIN returns all rows from the left table, including unmatched rows.

2. When would you use CROSS JOIN in a practical scenario?

To generate all possible combinations, for example employees and projects.

3. Why does ON vs WHERE matter for outer joins but not inner joins?

ON filters matching conditions before the outer join is completed. WHERE filters the final result. With INNER JOIN, both produce the same matching rows in this example.

4. What is the result of CROSS JOIN if table1 has 5 rows and table2 has 10 rows?

Answer: 50 rows (5 × 10).

5. How does NATURAL JOIN determine which columns to join on?

It automatically joins columns with the same names in both tables.

6. What are the potential risks of using NATURAL JOIN?

Unexpected columns with matching names may be used for joining, producing incorrect results.

---7
SELECT *
FROM A
LEFT JOIN B ON A.id = B.id;

SELECT *
FROM B
RIGHT JOIN A ON A.id = B.id;


---10
-1
SELECT *
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id

UNION

SELECT *
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id;

-2
SELECT e.emp_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IN (
    SELECT dept_id
    FROM projects
    GROUP BY dept_id
    HAVING COUNT(*) > 1
);

-3

SELECT
    e.emp_name AS employee,
    m.emp_name AS manager,
    mm.emp_name AS top_manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id
LEFT JOIN employees mm
ON m.manager_id = mm.emp_id;


-4
SELECT
    e1.emp_name AS employee1,
    e2.emp_name AS employee2,
    e1.dept_id
FROM employees e1
JOIN employees e2
ON e1.dept_id = e2.dept_id
AND e1.emp_id < e2.emp_id;
