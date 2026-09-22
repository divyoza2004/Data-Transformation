CREATE DATABASE data_transformation; 
USE data_transformation; 
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, RegistrationDate) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'), (2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02');
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(101, 1, '2023-07-01', 150.50), (102, 2, '2023-07-03', 200.75);
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10, 2)
);
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate, Salary) VALUES
(1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00), (2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00);
SELECT o.OrderID, o.OrderDate, o.TotalAmount, c.CustomerID, c.FirstName, c.LastName, c.Email FROM Orders o INNER JOIN Customers c ON o.CustomerID = c.CustomerID;
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, o.OrderID, o.OrderDate, o.TotalAmount FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;
SELECT o.OrderID, o.OrderDate, o.TotalAmount, c.CustomerID, c.FirstName, c.LastName FROM Customers c RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID UNION SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount FROM Customers c RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;
SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID WHERE o.TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);
SELECT EmployeeID, FirstName, LastName, Department, Salary FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);
SELECT OrderID, OrderDate, EXTRACT(YEAR FROM OrderDate) AS OrderYear, EXTRACT(MONTH FROM OrderDate) AS OrderMonth FROM Orders;
SELECT OrderID, OrderDate, CURRENT_DATE - OrderDate AS DaysDifference FROM Orders;
SELECT OrderID, TO_CHAR(OrderDate, 'DD-Mon-YYYY') AS FormattedOrderDate FROM Orders;
SELECT CustomerID, CONCAT(FirstName, ' ', LastName) AS FullName FROM Customers;
SELECT CustomerID, REPLACE(FirstName, 'John', 'Jonathan') AS UpdatedFirstName, LastName FROM Customers;
SELECT CustomerID, UPPER(FirstName) AS UpperFirstName, LOWER(LastName) AS LowerLastName FROM Customers;
SELECT CustomerID, TRIM(Email) AS CleanedEmail FROM Customers;
SELECT OrderID, CustomerID, OrderDate, TotalAmount, SUM(TotalAmount) OVER (ORDER BY OrderDate, OrderID) AS RunningTotal FROM Orders;
SELECT OrderID, CustomerID, TotalAmount, RANK() OVER (ORDER BY TotalAmount DESC) AS OrderRank FROM Orders;
SELECT OrderID, CustomerID, TotalAmount, CASE WHEN TotalAmount > 1000 THEN '10% off' WHEN TotalAmount > 500 THEN '5% off' ELSE 'No Discount' END AS Discount FROM Orders;
SELECT EmployeeID, FirstName, LastName, Salary, CASE WHEN Salary >= 60000 THEN 'High' WHEN Salary BETWEEN 50000 AND 59999 THEN 'Medium' ELSE 'Low' END AS SalaryCategory FROM Employees;
