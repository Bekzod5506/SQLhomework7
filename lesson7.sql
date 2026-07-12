create database Sql_lesson7

use Sql_lesson7;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
	CustomerID INT,
    OrderDate DATE
);



CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);





CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

INSERT INTO Customers VALUES 

(1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Orders VALUES 

(101, 1, '2024-01-01'), (102, 1, '2024-02-15'),
(103, 2, '2024-03-10'), (104, 2, '2024-04-20');

INSERT INTO OrderDetails VALUES 

(1, 101, 1, 2, 10.00), (2, 101, 2, 1, 20.00),
(3, 102, 1, 3, 10.00), (4, 103, 3, 5, 15.00),
(5, 104, 1, 1, 10.00), (6, 104, 2, 2, 20.00);

INSERT INTO Products VALUES 

(1, 'Laptop', 'Electronics'), 
(2, 'Mouse', 'Electronics'),
(3, 'Book', 'Stationery');

select*from Customers;
select*from Orders;
select*from OrderDetails;
select*from Products;

--Task1

select c.CustomerName, o.OrderID, o.OrderDate
from Customers c
left join Orders o on c.CustomerID = o.CustomerID;

--Task2

select c.CustomerName, o.OrderDate
from Customers c
left join Orders o on c.CustomerID = o.CustomerID 
where o.OrderID is Null;

--Task3

select od.OrderID, p.Productname, od.Quantity
from OrderDetails od 
left join Products p on od.ProductID = p.ProductID;

--Task4

select c.customerid, c.customername, count(o.orderid) as total_orders
from customers c
join orders o
    on c.customerid = o.customerid
group by c.customerid, c.customername
having count(o.orderid) > 1;

--Task5 

select orderid, productid, price
from (
    select 
        orderid,
        productid,
        price,
        row_number() over (partition by orderid order by price) as rn
    from orderdetails
) t
where rn = 1;

--Task6

select 
    c.customerid,
    c.customername,
    t.orderid,
    t.orderdate
from customers c
join (
    select 
        customerid,
        orderid,
        orderdate,
        row_number() over (partition by customerid order by orderdate desc) as rn
    from orders
) t
    on c.customerid = t.customerid
where t.rn = 1;

--Task7

select c.customerid, c.customername
from customers c
join orders o
    on c.customerid = o.customerid
join orderdetails od
    on o.orderid = od.orderid
join products p
    on od.productid = p.productid
group by c.customerid, c.customername
having count(distinct case when p.category <> 'electronics' then p.category end) = 0;

--Task8

select distinct c.customerid, c.customername
from customers c
join orders o
    on c.customerid = o.customerid
join orderdetails od
    on o.orderid = od.orderid
join products p
    on od.productid = p.productid
where p.category = 'stationery';

--Task9 

select 
    c.customerid,
    c.customername,
    sum(od.quantity * od.price) as total_spent
from customers c
join orders o
    on c.customerid = o.customerid
join orderdetails od
    on o.orderid = od.orderid
group by c.customerid, c.customername;

--Done








