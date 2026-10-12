-- Создаем таблицу категорий товаров
CREATE TABLE Categories (
    CategoryID SERIAL PRIMARY KEY, -- Уникальный идентификатор категории
    CategoryName VARCHAR(100) NOT NULL -- Название категории товаров
);

-- Создаем таблицу поставщиков
CREATE TABLE Suppliers (
    SupplierID SERIAL PRIMARY KEY, -- Уникальный идентификатор поставщика
    SupplierName VARCHAR(100) NOT NULL, -- Название поставщика
    SupplierURL VARCHAR(255) -- URL поставщика (информация о производителе)
);

-- Создаем таблицу товаров
CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY, -- Уникальный идентификатор товара
    CategoryID INT NOT NULL, -- Идентификатор категории товара
    WeightGroup VARCHAR(50) NOT NULL, -- Весовая группа для доставки
    WarrantyPeriod INT, -- Гарантийный срок в месяцах (если применимо)
    SupplierID INT NOT NULL, -- Идентификатор поставщика
    AvailabilityStatus VARCHAR(50) NOT NULL DEFAULT 'На складе', -- Статус доступности товара
    ListPrice NUMERIC(10,2) NOT NULL CHECK (ListPrice >= 0), -- Прейскурантная цена
    MinPrice NUMERIC(10,2) NOT NULL CHECK (MinPrice >= 0 AND MinPrice <= ListPrice), -- Минимальная цена продажи
    ManufacturerURL VARCHAR(255), -- URL для информации о производителе
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE CASCADE, -- Связь с таблицей категорий
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE -- Связь с таблицей поставщиков
);

-- Создаем таблицу местоположений
CREATE TABLE Locations (
    LocationID SERIAL PRIMARY KEY, -- Уникальный идентификатор местоположения
    Address VARCHAR(255) NOT NULL, -- Адрес
    CityOrProvince VARCHAR(100) NOT NULL, -- Город или провинция
    Country VARCHAR(100) NOT NULL, -- Страна
    PostalCode VARCHAR(20) NOT NULL -- Почтовый индекс
);

-- Создаем таблицу складов
CREATE TABLE Warehouses (
    WarehouseID SERIAL PRIMARY KEY, -- Уникальный идентификатор склада
    Name VARCHAR(100) NOT NULL, -- Название склада
    FacilityDescription TEXT, -- Описание объекта
    LocationID INT NOT NULL, -- Идентификатор местоположения
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID) ON DELETE CASCADE -- Связь с таблицей местоположений
);

-- Создаем таблицу запасов товаров
CREATE TABLE Inventory (
    ProductID INT NOT NULL, -- Идентификатор товара
    WarehouseID INT NOT NULL, -- Идентификатор склада
    QuantityOnHand INT NOT NULL DEFAULT 0 CHECK (QuantityOnHand >= 0), -- Количество в наличии
    PRIMARY KEY (ProductID, WarehouseID), -- Составной первичный ключ
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE, -- Связь с таблицей товаров
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID) ON DELETE CASCADE -- Связь с таблицей складов
);

-- Создаем таблицу клиентов
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY, -- Уникальный идентификатор клиента
    Name VARCHAR(100) NOT NULL, -- Имя клиента
    MailingAddress VARCHAR(255) NOT NULL, -- Почтовый адрес
    CityOrProvince VARCHAR(100) NOT NULL, -- Город или провинция
    Country VARCHAR(100) NOT NULL, -- Страна
    PostalCode VARCHAR(20) NOT NULL, -- Почтовый индекс
    EmailAddress VARCHAR(100) -- Адрес электронной почты
);

-- Создаем таблицу телефонов клиентов
CREATE TABLE CustomerPhones (
    CustomerID INT NOT NULL, -- Идентификатор клиента
    PhoneNumber VARCHAR(20) NOT NULL, -- Номер телефона
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE, -- Связь с таблицей клиентов
    PRIMARY KEY (CustomerID, PhoneNumber)
);

-- Создаем таблицу торговых представителей
CREATE TABLE SalesRepresentatives (
    SalesRepID SERIAL PRIMARY KEY, -- Уникальный идентификатор торгового представителя
    Name VARCHAR(100) NOT NULL -- Имя торгового представителя
    -- Можно добавить дополнительные поля при необходимости
);

-- Создаем таблицу заказов
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY, -- Уникальный идентификатор заказа
    CustomerID INT NOT NULL, -- Идентификатор клиента
    OrderDate DATE NOT NULL DEFAULT CURRENT_DATE, -- Дата заказа
    OrderMethod VARCHAR(50) NOT NULL, -- Способ размещения заказа
    CurrentStatus VARCHAR(50) NOT NULL DEFAULT 'Pending', -- Текущий статус заказа
    ShippingMethod VARCHAR(50) NOT NULL, -- Способ доставки
    TotalAmount NUMERIC(10,2) NOT NULL CHECK (TotalAmount >= 0), -- Общая сумма заказа
    SalesRepID INT, -- Идентификатор торгового представителя
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE, -- Связь с таблицей клиентов
    FOREIGN KEY (SalesRepID) REFERENCES SalesRepresentatives(SalesRepID) ON DELETE SET NULL -- Связь с таблицей торговых представителей
);

-- Создаем таблицу позиций заказа
CREATE TABLE OrderItems (
    OrderID INT NOT NULL, -- Идентификатор заказа
    ProductID INT NOT NULL, -- Идентификатор товара
    Quantity INT NOT NULL CHECK (Quantity > 0), -- Количество
    Price NUMERIC(10,2) NOT NULL CHECK (Price >= 0), -- Цена за единицу
    PRIMARY KEY (OrderID, ProductID), -- Составной первичный ключ
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE, -- Связь с таблицей заказов
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE -- Связь с таблицей товаров
);

-- Заполняем таблицу категорий
INSERT INTO Categories (CategoryName) VALUES
('Комплектующие'),
('ПО'),
('Music'),
('Одежда'),
('Инструменты');

-- Заполняем таблицу поставщиков
INSERT INTO Suppliers (SupplierName, SupplierURL) VALUES
('Техногуд', 'http://www.techgood.com'),
('Мелкомягкий Inc.', 'http://www.melkosoft.com'),
('Музобоз', 'http://www.musoboz.com'),
('Тряпки', 'http://www.treplo.com'),
('ToolMasters', 'http://www.toolmasters.com');

-- Заполняем таблицу товаров
INSERT INTO Products (CategoryID, WeightGroup, WarrantyPeriod, SupplierID, AvailabilityStatus, ListPrice, MinPrice, ManufacturerURL) VALUES
(1, 'Light', 24, 1, 'На складе', 1000.00, 800.00, 'http://www.techcorp.com/products/1'),
(2, 'None', NULL, 2, 'На складе', 200.00, 150.00, 'http://www.softwareinc.com/products/2'),
(3, 'Light', NULL, 3, 'Нет на складе', 15.00, 10.00, 'http://www.musicworld.com/products/3'),
(4, 'Medium', NULL, 4, 'На складе', 50.00, 40.00, 'http://www.fashionhouse.com/products/4'),
(5, 'Heavy', 12, 5, 'На складе', 250.00, 200.00, 'http://www.toolmasters.com/products/5');

-- Заполняем таблицу местоположений
INSERT INTO Locations (Address, CityOrProvince, Country, PostalCode) VALUES
('123 Main St', 'New York', 'USA', '10001'),
('456 Elm St', 'Los Angeles', 'USA', '90001'),
('789 Oak St', 'Chicago', 'USA', '60601');

-- Заполняем таблицу складов
INSERT INTO Warehouses (Name, FacilityDescription, LocationID) VALUES
('East Coast Warehouse', 'Main warehouse on the east coast', 1),
('West Coast Warehouse', 'Main warehouse on the west coast', 2),
('Central Warehouse', 'Central distribution center', 3);

-- Заполняем таблицу запасов
INSERT INTO Inventory (ProductID, WarehouseID, QuantityOnHand) VALUES
(1, 1, 50),
(2, 1, 100),
(3, 2, 0),
(4, 3, 200),
(5, 1, 10);

-- Заполняем таблицу клиентов
INSERT INTO Customers (Name, MailingAddress, CityOrProvince, Country, PostalCode, EmailAddress) VALUES
('Иван Ивановичт Иванов', 'ул. Архангельская 31-а, 69', 'Коряжма', 'Россия', '165651', 'Ivaicanov@blahblah.com'),
('Петр Петрович Петров', 'пр. Мира 12-144', 'Архангельск', 'Россия', '165300', 'petr@blah.com'),
('Сидор Сидорович Сидоров', 'пр. Свободы 12, 345', 'Минск', 'Беларусь', '80201', NULL);

-- Заполняем таблицу телефонов клиентов
INSERT INTO CustomerPhones (CustomerID, PhoneNumber) VALUES
(1, '555-1234'),
(1, '555-5678'),
(2, '555-8765'),
(3, '555-4321'),
(3, '555-1111'),
(3, '555-2222');

-- Заполняем таблицу торговых представителей
INSERT INTO SalesRepresentatives (Name) VALUES
('Алиса Зазеркальная'),
('Ярослав Дронов');

-- Заполняем таблицу заказов
INSERT INTO Orders (CustomerID, OrderDate, OrderMethod, CurrentStatus, ShippingMethod, TotalAmount, SalesRepID) VALUES
(1, '2023-01-15', 'Онлайн', 'Погружен', 'Почта России', 1050.00, 1),
(2, '2023-01-20', 'Телефон', 'В ожидании', 'Деловые линии', 200.00, 2),
(3, '2023-01-25', 'Онлайн', 'Доставлен', 'CDec', 50.00, NULL);

-- Заполняем таблицу позиций заказа
INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price) VALUES
(1, 1, 1, 1000.00),
(1, 2, 1, 50.00),
(2, 2, 1, 200.00),
(3, 4, 1, 50.00);

-- Выводим список всех товаров с их категориями и поставщиками
SELECT
    p.ProductID,
    p.ManufacturerURL,
    p.AvailabilityStatus,
    p.ListPrice,
    p.MinPrice,
    c.CategoryName,
    s.SupplierName
FROM
    Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
    JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- Находим товары, которых нет в наличии
SELECT
    p.ProductID,
    p.ManufacturerURL,
    p.AvailabilityStatus
FROM
    Products p
WHERE
    p.AvailabilityStatus = 'Нет на складе';

-- Выводим клиентов, у которых больше одного номера телефона
SELECT
    c.CustomerID,
    c.Name,
    COUNT(cp.PhoneNumber) AS PhoneCount
FROM
    Customers c
    JOIN CustomerPhones cp ON c.CustomerID = cp.CustomerID
GROUP BY
    c.CustomerID,
    c.Name
HAVING
    COUNT(cp.PhoneNumber) > 1;

-- Вычисляем общую сумму продаж для каждого торгового представителя
SELECT
    sr.SalesRepID,
    sr.Name,
    SUM(o.TotalAmount) AS TotalSales
FROM
    SalesRepresentatives sr
    JOIN Orders o ON sr.SalesRepID = o.SalesRepID
GROUP BY
    sr.SalesRepID,
    sr.Name;

-- Находим склад с наибольшим количеством товара с идентификатором 1
SELECT
    w.WarehouseID,
    w.Name,
    i.QuantityOnHand
FROM
    Inventory i
    JOIN Warehouses w ON i.WarehouseID = w.WarehouseID
WHERE
    i.ProductID = 1
ORDER BY
    i.QuantityOnHand DESC
LIMIT 1;

-- Выводим все заказы, размещенные через Интернет
SELECT
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    c.Name AS CustomerName
FROM
    Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE
    o.OrderMethod = 'Онлайн';

-- Вычисляем среднюю общую сумму заказа
SELECT
    AVG(TotalAmount) AS AverageOrderAmount
FROM
    Orders;

-- Находим клиентов, которые не указали адрес электронной почты
SELECT
    c.CustomerID,
    c.Name
FROM
    Customers c
WHERE
    c.EmailAddress IS NULL;

-- Считаем количество товаров в каждой категории
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM
    Categories c
    LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY
    c.CategoryName;

-- Получаем общее количество каждого товара на всех складах
SELECT
    p.ProductID,
    p.ManufacturerURL,
    SUM(i.QuantityOnHand) AS TotalQuantityOnHand
FROM
    Products p
    JOIN Inventory i ON p.ProductID = i.ProductID
GROUP BY
    p.ProductID,
    p.ManufacturerURL;
    
   
   
   
/*
   
В ходе работы мы создали реляционную базу данных для компании, которая продает различные категории товаров. 
Мы определили основные таблицы, такие как Categories, Suppliers, Products, Warehouses, Inventory, Customers, Orders и другие, 
установили связи между ними с помощью внешних ключей и добавили необходимые ограничения для поддержания целостности данных.

При создании таблиц были учтены следующие моменты:
1. Внешние ключи настроены таким образом, чтобы при удалении записи из основной таблицы связанные записи в зависимых таблицах автоматически удалялись. Это предотвращает появление "висячих" ссылок и поддерживает целостность данных.

2. Для числовых полей, таких как цены и количество, добавлены ограничения CHECK, которые гарантируют, что значения не отрицательные и соответствуют заданным условиям.

3. Для некоторых полей, таких как AvailabilityStatus и OrderDate, установлены значения по умолчанию, 
что упрощает ввод данных и предотвращает появление NULL-значений там, где они нежелательны.

Мы также наполнили таблицы примерными данными и выполнили ряд запросов, демонстрирующих возможности фильтрации и агрегации. 

В итоге запросы позволили сделать следующее:

1. Получить список товаров с категориями и поставщиками.
2. Найти товары, отсутствующие в наличии.
3. Определить клиентов с несколькими номерами телефонов.
4. Вычислить общую сумму продаж для каждого торгового представителя.
5. И другие аналитические задачи.
При разработке базы данных и написании запросов были учтены рекомендации по форматированию, структуре и технике:   
   */