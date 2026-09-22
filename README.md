# Project: Data Transformer

## Objective 
"Data Transformer" is a comprehensive SQL project designed to enhance your practical knowledge of advanced SQL operations. This project will guide students through working with Joins, Subqueries, Date and String Manipulation Functions, Window Functions, and the SQL CASE Expression. By completing this project, students will build the skills needed to transform and manipulate data for reporting, analysis, and complex queries.

## ▶ Demo Video

<a href="https://drive.google.com/file/d/1AatthUMYyYT7dHo0rPrh9x-oAviJh_4N/view?usp=sharing" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/▶-Watch%20Demo%20Video-181717?style=for-the-badge&logo=github&logoColor=white" alt="Watch Demo Video" />
</a>

## Source Tables

**Customers**

| CustomerID | FirstName | LastName | Email | RegistrationDate |
|---|---|---|---|---|
| 1 | John | Doe | john.doe@email.com | 2022-03-15 |
| 2 | Jane | Smith | jane.smith@email.com | 2021-11-02 |

**Orders**

| OrderID | CustomerID | OrderDate | TotalAmount |
|---|---|---|---|
| 101 | 1 | 2023-07-01 | 150.50 |
| 102 | 2 | 2023-07-03 | 200.75 |

**Employees**

| EmployeeID | FirstName | LastName | Department | HireDate | Salary |
|---|---|---|---|---|---|
| 1 | Mark | Johnson | Sales | 2020-01-15 | 50000.00 |
| 2 | Susan | Lee | HR | 2021-03-20 | 55000.00 |

## Query-by-Query Breakdown


### 1. INNER JOIN — Orders matched with Customers

**Objective:** Combine Orders with Customers, returning only the rows where a matching CustomerID exists in both tables.

**SQL:**

```sql
SELECT o.OrderID, o.OrderDate, o.TotalAmount, c.CustomerID, c.FirstName, c.LastName, c.Email
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;
```

**Output** _( 2 rows )_:

|   OrderID | OrderDate   |   TotalAmount |   CustomerID | FirstName   | LastName   | Email                |
|----------:|:------------|--------------:|-------------:|:------------|:-----------|:---------------------|
|       101 | 2023-07-01  |        150.5  |            1 | John        | Doe        | john.doe@email.com   |
|       102 | 2023-07-03  |        200.75 |            2 | Jane        | Smith      | jane.smith@email.com |


---

### 2. LEFT JOIN — All Customers, with Orders if any

**Objective:** Return every customer, and attach their order details where they exist. Customers with no orders would still appear, with NULLs in the order columns.

**SQL:**

```sql
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;
```

**Output** _( 2 rows )_:

|   CustomerID | FirstName   | LastName   | Email                |   OrderID | OrderDate   |   TotalAmount |
|-------------:|:------------|:-----------|:---------------------|----------:|:------------|--------------:|
|            1 | John        | Doe        | john.doe@email.com   |       101 | 2023-07-01  |        150.5  |
|            2 | Jane        | Smith      | jane.smith@email.com |       102 | 2023-07-03  |        200.75 |


---

### 3. RIGHT JOIN — All Orders, with Customer info if any

**Objective:** Return every order, and attach the placing customer's details where they exist. Orders with no matching customer would still appear, with NULLs in the customer columns.

**SQL:**

```sql
SELECT o.OrderID, o.OrderDate, o.TotalAmount, c.CustomerID, c.FirstName, c.LastName
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;
```

**Output** _( 2 rows )_:

|   OrderID | OrderDate   |   TotalAmount |   CustomerID | FirstName   | LastName   |
|----------:|:------------|--------------:|-------------:|:------------|:-----------|
|       101 | 2023-07-01  |        150.5  |            1 | John        | Doe        |
|       102 | 2023-07-03  |        200.75 |            2 | Jane        | Smith      |


---

### 4. UNION of LEFT JOIN and RIGHT JOIN — Full Outer Join emulation

**Objective:** Simulate a FULL OUTER JOIN by combining a LEFT JOIN and a RIGHT JOIN with UNION, so every customer and every order appears, matched or not, with duplicate matched rows removed automatically by UNION.

**SQL:**

```sql
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;
```

**Output** _( 2 rows )_:

|   CustomerID | FirstName   | LastName   |   OrderID | OrderDate   |   TotalAmount |
|-------------:|:------------|:-----------|----------:|:------------|--------------:|
|            1 | John        | Doe        |       101 | 2023-07-01  |        150.5  |
|            2 | Jane        | Smith      |       102 | 2023-07-03  |        200.75 |


---

### 5. Subquery — Customers whose order exceeded the average order value

**Objective:** Find distinct customers who placed at least one order larger than the average TotalAmount across all orders, using a scalar subquery in the WHERE clause.

**SQL:**

```sql
SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);
```

**Output** _( 1 row )_:

|   CustomerID | FirstName   | LastName   |
|-------------:|:------------|:-----------|
|            2 | Jane        | Smith      |


---

### 6. Subquery — Employees earning above the average salary

**Objective:** Identify employees whose Salary is greater than the company-wide average salary, again using a scalar subquery.

**SQL:**

```sql
SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);
```

**Output** _( 1 row )_:

|   EmployeeID | FirstName   | LastName   | Department   |   Salary |
|-------------:|:------------|:-----------|:-------------|---------:|
|            2 | Susan       | Lee        | HR           |    55000 |


---

### 7. EXTRACT — Pull the Year and Month out of a date

**Objective:** Break OrderDate into its Year and Month components for time-based reporting (e.g. monthly/yearly sales grouping).

**SQL:**

```sql
SELECT OrderID, OrderDate,
       EXTRACT(YEAR FROM OrderDate) AS OrderYear,
       EXTRACT(MONTH FROM OrderDate) AS OrderMonth
FROM Orders;
```

**Output** _( 2 rows )_:

|   OrderID | OrderDate   |   OrderYear |   OrderMonth |
|----------:|:------------|------------:|-------------:|
|       101 | 2023-07-01  |        2023 |            7 |
|       102 | 2023-07-03  |        2023 |            7 |


---

### 8. Date Arithmetic — Days elapsed since the order

**Objective:** Calculate how many days have passed between the order date and today's date, useful for aging/recency analysis.

**SQL:**

```sql
SELECT OrderID, OrderDate, CURRENT_DATE - OrderDate AS DaysDifference
FROM Orders;
```

**Output** _( 2 rows )_:

|   OrderID | OrderDate   |   DaysDifference |
|----------:|:------------|-----------------:|
|       101 | 2023-07-01  |             1179 |
|       102 | 2023-07-03  |             1177 |


---

### 9. Date Formatting — Human-readable date string

**Objective:** Reformat OrderDate into a display-friendly string (day-month-year) for reports and dashboards, using the database's date-formatting function.

**SQL:**

```sql
SELECT OrderID, TO_CHAR(OrderDate, 'DD-Mon-YYYY') AS FormattedOrderDate
FROM Orders;
```

> **Note:** DuckDB has no `TO_CHAR` function, so the equivalent `strftime()` was used to execute this query and produce the output below. The original `TO_CHAR` syntax (valid in PostgreSQL/Oracle) is shown above and works unchanged there.

**Output** _( 2 rows )_:

|   OrderID | FormattedOrderDate   |
|----------:|:---------------------|
|       101 | 01-Jul-2023          |
|       102 | 03-Jul-2023          |


---

### 10. CONCAT — Build a Full Name

**Objective:** Merge FirstName and LastName into a single FullName column, a common step when preparing data for display or export.

**SQL:**

```sql
SELECT CustomerID, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;
```

**Output** _( 2 rows )_:

|   CustomerID | FullName   |
|-------------:|:-----------|
|            1 | John Doe   |
|            2 | Jane Smith |


---

### 11. REPLACE — Substitute text within a string

**Objective:** Demonstrate string substitution by replacing every occurrence of 'John' with 'Jonathan' in FirstName, without permanently altering the underlying data.

**SQL:**

```sql
SELECT CustomerID, REPLACE(FirstName, 'John', 'Jonathan') AS UpdatedFirstName, LastName
FROM Customers;
```

**Output** _( 2 rows )_:

|   CustomerID | UpdatedFirstName   | LastName   |
|-------------:|:-------------------|:-----------|
|            1 | Jonathan           | Doe        |
|            2 | Jane               | Smith      |


---

### 12. UPPER / LOWER — Case conversion

**Objective:** Standardize text casing by converting FirstName to uppercase and LastName to lowercase, useful for consistent formatting or case-insensitive comparisons.

**SQL:**

```sql
SELECT CustomerID, UPPER(FirstName) AS UpperFirstName, LOWER(LastName) AS LowerLastName
FROM Customers;
```

**Output** _( 2 rows )_:

|   CustomerID | UpperFirstName   | LowerLastName   |
|-------------:|:-----------------|:----------------|
|            1 | JOHN             | doe             |
|            2 | JANE             | smith           |


---

### 13. TRIM — Remove stray whitespace

**Objective:** Strip leading/trailing whitespace from the Email column, a standard data-cleaning step before validation or deduplication.

**SQL:**

```sql
SELECT CustomerID, TRIM(Email) AS CleanedEmail
FROM Customers;
```

**Output** _( 2 rows )_:

|   CustomerID | CleanedEmail         |
|-------------:|:---------------------|
|            1 | john.doe@email.com   |
|            2 | jane.smith@email.com |


---

### 14. Window Function — Running Total of Orders

**Objective:** Calculate a cumulative (running) sum of TotalAmount as orders are read in date order, without collapsing rows the way GROUP BY would.

**SQL:**

```sql
SELECT OrderID, CustomerID, OrderDate, TotalAmount,
       SUM(TotalAmount) OVER (ORDER BY OrderDate, OrderID) AS RunningTotal
FROM Orders;
```

**Output** _( 2 rows )_:

|   OrderID |   CustomerID | OrderDate   |   TotalAmount |   RunningTotal |
|----------:|-------------:|:------------|--------------:|---------------:|
|       101 |            1 | 2023-07-01  |        150.5  |         150.5  |
|       102 |            2 | 2023-07-03  |        200.75 |         351.25 |


---

### 15. Window Function — Rank Orders by Value

**Objective:** Rank every order from highest to lowest TotalAmount using RANK(), which assigns tied values the same rank and skips the next rank accordingly.

**SQL:**

```sql
SELECT OrderID, CustomerID, TotalAmount,
       RANK() OVER (ORDER BY TotalAmount DESC) AS OrderRank
FROM Orders;
```

**Output** _( 2 rows )_:

|   OrderID |   CustomerID |   TotalAmount |   OrderRank |
|----------:|-------------:|--------------:|------------:|
|       102 |            2 |        200.75 |           1 |
|       101 |            1 |        150.5  |           2 |


---

### 16. CASE — Tiered discount labels for Orders

**Objective:** Apply business rules to categorize each order into a discount tier based on TotalAmount thresholds, using conditional CASE logic.

**SQL:**

```sql
SELECT OrderID, CustomerID, TotalAmount,
       CASE
           WHEN TotalAmount > 1000 THEN '10% off'
           WHEN TotalAmount > 500 THEN '5% off'
           ELSE 'No Discount'
       END AS Discount
FROM Orders;
```

**Output** _( 2 rows )_:

|   OrderID |   CustomerID |   TotalAmount | Discount    |
|----------:|-------------:|--------------:|:------------|
|       101 |            1 |        150.5  | No Discount |
|       102 |            2 |        200.75 | No Discount |


---

### 17. CASE — Salary band classification for Employees

**Objective:** Bucket each employee into a High / Medium / Low salary category using CASE with range conditions, useful for HR reporting.

**SQL:**

```sql
SELECT EmployeeID, FirstName, LastName, Salary,
       CASE
           WHEN Salary >= 60000 THEN 'High'
           WHEN Salary BETWEEN 50000 AND 59999 THEN 'Medium'
           ELSE 'Low'
       END AS SalaryCategory
FROM Employees;
```

**Output** _( 2 rows )_:

|   EmployeeID | FirstName   | LastName   |   Salary | SalaryCategory   |
|-------------:|:------------|:-----------|---------:|:-----------------|
|            1 | Mark        | Johnson    |    50000 | Medium           |
|            2 | Susan       | Lee        |    55000 | Medium           |


---


## Quick-Reference Summary

| # | Category | Query | What it demonstrates |
|---|---|---|---|
| 1 | Join | INNER JOIN | Rows with matches in both tables only |
| 2 | Join | LEFT JOIN | All Customers, matched Orders or NULL |
| 3 | Join | RIGHT JOIN | All Orders, matched Customers or NULL |
| 4 | Join | UNION of LEFT + RIGHT | Emulates a FULL OUTER JOIN |
| 5 | Subquery | Scalar subquery in WHERE | Customers above avg order value |
| 6 | Subquery | Scalar subquery in WHERE | Employees above avg salary |
| 7 | Date | EXTRACT | Pull YEAR / MONTH from a date |
| 8 | Date | Date arithmetic | Days between two dates |
| 9 | Date | TO_CHAR / strftime | Custom date formatting |
| 10 | String | CONCAT | Combine two columns |
| 11 | String | REPLACE | Substring substitution |
| 12 | String | UPPER / LOWER | Case conversion |
| 13 | String | TRIM | Whitespace removal |
| 14 | Window | SUM() OVER | Running total |
| 15 | Window | RANK() OVER | Ranking rows |
| 16 | Conditional | CASE | Discount tiering |
| 17 | Conditional | CASE | Salary banding |

- **Subqueries (5–6)** show how a scalar subquery (`SELECT AVG(...)`) can be used inline as a comparison threshold.
- **Date functions (7–9)** cover extracting parts of a date, doing date arithmetic, and formatting dates for display.
- **String functions (10–13)** cover the everyday cleanup/formatting toolkit: concatenation, substitution, case conversion, and trimming.
- **Window functions (14–15)** show running totals and ranking — calculations that reference other rows without collapsing the result set, unlike `GROUP BY`.
- **CASE expressions (16–17)** show how to bucket numeric values into labeled categories directly in SQL.
