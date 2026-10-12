-- создаем таблицу категорий товаров
CREATE TABLE categories (
    categoryid SERIAL PRIMARY KEY, -- уникальный идентификатор категории
    categoryname VARCHAR(100) NOT NULL -- название категории товаров
);

-- создаем таблицу поставщиков
CREATE TABLE suppliers (
    supplierid SERIAL PRIMARY KEY, -- уникальный идентификатор поставщика
    suppliername VARCHAR(100) NOT NULL, -- название поставщика
    supplierurl VARCHAR(255) -- url поставщика (информация о производителе)
);

-- создаем таблицу товаров
CREATE TABLE products (
    productid SERIAL PRIMARY KEY, -- уникальный идентификатор товара
    categoryid INT NOT NULL, -- идентификатор категории товара
    weightgroup VARCHAR(50) NOT NULL, -- весовая группа для доставки
    warrantyperiod INT, -- гарантийный срок в месяцах (если применимо)
    supplierid INT NOT NULL, -- идентификатор поставщика
    availabilitystatus VARCHAR(50) NOT NULL DEFAULT 'На складе', -- статус доступности товара
    listprice NUMERIC(10,2) NOT NULL CHECK (listprice >= 0), -- прейскурантная цена
    minprice NUMERIC(10,2) NOT NULL CHECK (minprice >= 0 AND minprice <= listprice), -- минимальная цена продажи
    manufacturerurl VARCHAR(255), -- url для информации о производителе
    FOREIGN KEY (categoryid) REFERENCES categories(categoryid) ON DELETE CASCADE, -- связь с таблицей категорий
    FOREIGN KEY (supplierid) REFERENCES suppliers(supplierid) ON DELETE CASCADE -- связь с таблицей поставщиков
);

-- создаем таблицу местоположений
CREATE TABLE locations (
    locationid SERIAL PRIMARY KEY, -- уникальный идентификатор местоположения
    address VARCHAR(255) NOT NULL, -- адрес
    cityorprovince VARCHAR(100) NOT NULL, -- город или провинция
    country VARCHAR(100) NOT NULL, -- страна
    postalcode VARCHAR(20) NOT NULL -- почтовый индекс
);

-- создаем таблицу складов
CREATE TABLE warehouses (
    warehouseid SERIAL PRIMARY KEY, -- уникальный идентификатор склада
    name VARCHAR(100) NOT NULL, -- название склада
    facilitydescription TEXT, -- описание объекта
    locationid INT NOT NULL, -- идентификатор местоположения
    FOREIGN KEY (locationid) REFERENCES locations(locationid) ON DELETE CASCADE -- связь с таблицей местоположений
);

-- создаем таблицу запасов товаров
CREATE TABLE inventory (
    productid INT NOT NULL, -- идентификатор товара
    warehouseid INT NOT NULL, -- идентификатор склада
    quantityonhand INT NOT NULL DEFAULT 0 CHECK (quantityonhand >= 0), -- количество в наличии
    PRIMARY KEY (productid, warehouseid), -- составной первичный ключ
    FOREIGN KEY (productid) REFERENCES products(productid) ON DELETE CASCADE, -- связь с таблицей товаров
    FOREIGN KEY (warehouseid) REFERENCES warehouses(warehouseid) ON DELETE CASCADE -- связь с таблицей складов
);

-- создаем таблицу клиентов
CREATE TABLE customers (
    customerid SERIAL PRIMARY KEY, -- уникальный идентификатор клиента
    name VARCHAR(100) NOT NULL, -- имя клиента
    mailingaddress VARCHAR(255) NOT NULL, -- почтовый адрес
    cityorprovince VARCHAR(100) NOT NULL, -- город или провинция
    country VARCHAR(100) NOT NULL, -- страна
    postalcode VARCHAR(20) NOT NULL, -- почтовый индекс
    emailaddress VARCHAR(100) -- адрес электронной почты
);

-- создаем таблицу телефонов клиентов
CREATE TABLE customerphones (
    customerid INT NOT NULL, -- идентификатор клиента
    phonenumber VARCHAR(20) NOT NULL, -- номер телефона
    FOREIGN KEY (customerid) REFERENCES customers(customerid) ON DELETE CASCADE, -- связь с таблицей клиентов
    PRIMARY KEY (customerid, phonenumber)
);

-- создаем таблицу торговых представителей
CREATE TABLE salesrepresentatives (
    salesrepid SERIAL PRIMARY KEY, -- уникальный идентификатор торгового представителя
    name VARCHAR(100) NOT NULL -- имя торгового представителя
    -- можно добавить дополнительные поля при необходимости
);

-- создаем таблицу заказов
CREATE TABLE orders (
    orderid SERIAL PRIMARY KEY, -- уникальный идентификатор заказа
    customerid INT NOT NULL, -- идентификатор клиента
    orderdate DATE NOT NULL DEFAULT CURRENT_DATE, -- дата заказа
    ordermethod VARCHAR(50) NOT NULL, -- способ размещения заказа
    currentstatus VARCHAR(50) NOT NULL DEFAULT 'Pending', -- текущий статус заказа
    shippingmethod VARCHAR(50) NOT NULL, -- способ доставки
    totalamount NUMERIC(10,2) NOT NULL CHECK (totalamount >= 0), -- общая сумма заказа
    salesrepid INT, -- идентификатор торгового представителя
    FOREIGN KEY (customerid) REFERENCES customers(customerid) ON DELETE CASCADE, -- связь с таблицей клиентов
    FOREIGN KEY (salesrepid) REFERENCES salesrepresentatives(salesrepid) ON DELETE SET NULL -- связь с таблицей торговых представителей
);

-- создаем таблицу позиций заказа
CREATE TABLE orderitems (
    orderid INT NOT NULL, -- идентификатор заказа
    productid INT NOT NULL, -- идентификатор товара
    quantity INT NOT NULL CHECK (quantity > 0), -- количество
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0), -- цена за единицу
    PRIMARY KEY (orderid, productid), -- составной первичный ключ
    FOREIGN KEY (orderid) REFERENCES orders(orderid) ON DELETE CASCADE, -- связь с таблицей заказов
    FOREIGN KEY (productid) REFERENCES products(productid) ON DELETE CASCADE -- связь с таблицей товаров
);

-- заполняем таблицу категорий
INSERT INTO categories (categoryname) VALUES
('Комплектующие'),
('ПО'),
('Music'),
('Одежда'),
('Инструменты');

-- заполняем таблицу поставщиков
INSERT INTO suppliers (suppliername, supplierurl) VALUES
('Техногуд', 'http://www.techgood.com'),
('Мелкомягкий Inc.', 'http://www.melkosoft.com'),
('Музобоз', 'http://www.musoboz.com'),
('Тряпки', 'http://www.treplo.com'),
('ToolMasters', 'http://www.toolmasters.com');

-- заполняем таблицу товаров
INSERT INTO products (categoryid, weightgroup, warrantyperiod, supplierid, availabilitystatus, listprice, minprice, manufacturerurl) VALUES
(1, 'Light', 24, 1, 'На складе', 1000.00, 800.00, 'http://www.techcorp.com/products/1'),
(2, 'None', NULL, 2, 'На складе', 200.00, 150.00, 'http://www.softwareinc.com/products/2'),
(3, 'Light', NULL, 3, 'Нет на складе', 15.00, 10.00, 'http://www.musicworld.com/products/3'),
(4, 'Medium', NULL, 4, 'На складе', 50.00, 40.00, 'http://www.fashionhouse.com/products/4'),
(5, 'Heavy', 12, 5, 'На складе', 250.00, 200.00, 'http://www.toolmasters.com/products/5');

-- заполняем таблицу местоположений
INSERT INTO locations (address, cityorprovince, country, postalcode) VALUES
('123 Main St', 'New York', 'USA', '10001'),
('456 Elm St', 'Los Angeles', 'USA', '90001'),
('789 Oak St', 'Chicago', 'USA', '60601');

-- заполняем таблицу складов
INSERT INTO warehouses (name, facilitydescription, locationid) VALUES
('East Coast Warehouse', 'Main warehouse on the east coast', 1),
('West Coast Warehouse', 'Main warehouse on the west coast', 2),
('Central Warehouse', 'Central distribution center', 3);

-- заполняем таблицу запасов
INSERT INTO inventory (productid, warehouseid, quantityonhand) VALUES
(1, 1, 50),
(2, 1, 100),
(3, 2, 0),
(4, 3, 200),
(5, 1, 10);

-- заполняем таблицу клиентов
INSERT INTO customers (name, mailingaddress, cityorprovince, country, postalcode, emailaddress) VALUES
('Иван Ивановичт Иванов', 'ул. Архангельская 31-а, 69', 'Коряжма', 'Россия', '165651', 'Ivaicanov@blahblah.com'),
('Петр Петрович Петров', 'пр. Мира 12-144', 'Архангельск', 'Россия', '165300', 'petr@blah.com'),
('Сидор Сидорович Сидоров', 'пр. Свободы 12, 345', 'Минск', 'Беларусь', '80201', NULL);

-- заполняем таблицу телефонов клиентов
INSERT INTO customerphones (customerid, phonenumber) VALUES
(1, '555-1234'),
(1, '555-5678'),
(2, '555-8765'),
(3, '555-4321'),
(3, '555-1111'),
(3, '555-2222');

-- заполняем таблицу торговых представителей
INSERT INTO salesrepresentatives (name) VALUES
('Алиса Зазеркальная'),
('Ярослав Дронов');

-- заполняем таблицу заказов
INSERT INTO orders (customerid, orderdate, ordermethod, currentstatus, shippingmethod, totalamount, salesrepid) VALUES
(1, '2023-01-15', 'Онлайн', 'Погружен', 'Почта России', 1050.00, 1),
(2, '2023-01-20', 'Телефон', 'В ожидании', 'Деловые линии', 200.00, 2),
(3, '2023-01-25', 'Онлайн', 'Доставлен', 'CDec', 50.00, NULL);

-- заполняем таблицу позиций заказа
INSERT INTO orderitems (orderid, productid, quantity, price) VALUES
(1, 1, 1, 1000.00),
(1, 2, 1, 50.00),
(2, 2, 1, 200.00),
(3, 4, 1, 50.00);

-- выводим список всех товаров с их категориями и поставщиками
SELECT
    p.productid,
    p.manufacturerurl,
    p.availabilitystatus,
    p.listprice,
    p.minprice,
    c.categoryname,
    s.suppliername
FROM
    products p
    JOIN categories c ON p.categoryid = c.categoryid
    JOIN suppliers s ON p.supplierid = s.supplierid;

-- находим товары, которых нет в наличии
SELECT
    p.productid,
    p.manufacturerurl,
    p.availabilitystatus
FROM
    products p
WHERE
    p.availabilitystatus = 'Нет на складе';

-- выводим клиентов, у которых больше одного номера телефона
SELECT
    c.customerid,
    c.name,
    COUNT(cp.phonenumber) AS phonecount
FROM
    customers c
    JOIN customerphones cp ON c.customerid = cp.customerid
GROUP BY
    c.customerid,
    c.name
HAVING
    COUNT(cp.phonenumber) > 1;

-- вычисляем общую сумму продаж для каждого торгового представителя
SELECT
    sr.salesrepid,
    sr.name,
    SUM(o.totalamount) AS totalsales
FROM
    salesrepresentatives sr
    JOIN orders o ON sr.salesrepid = o.salesrepid
GROUP BY
    sr.salesrepid,
    sr.name;

-- находим склад с наибольшим количеством товара с идентификатором 1
SELECT
    w.warehouseid,
    w.name,
    i.quantityonhand
FROM
    inventory i
    JOIN warehouses w ON i.warehouseid = w.warehouseid
WHERE
    i.productid = 1
ORDER BY
    i.quantityonhand DESC
LIMIT 1;

-- выводим все заказы, размещенные через интернет
SELECT
    o.orderid,
    o.orderdate,
    o.totalamount,
    c.name AS customername
FROM
    orders o
    JOIN customers c ON o.customerid = c.customerid
WHERE
    o.ordermethod = 'Онлайн';

-- вычисляем среднюю общую сумму заказа
SELECT
    AVG(totalamount) AS averageorderamount
FROM
    orders;

-- находим клиентов, которые не указали адрес электронной почты
SELECT
    c.customerid,
    c.name
FROM
    customers c
WHERE
    c.emailaddress IS NULL;

-- считаем количество товаров в каждой категории
SELECT
    c.categoryname,
    COUNT(p.productid) AS productcount
FROM
    categories c
    LEFT JOIN products p ON c.categoryid = p.categoryid
GROUP BY
    c.categoryname;

-- получаем общее количество каждого товара на всех складах
SELECT
    p.productid,
    p.manufacturerurl,
    SUM(i.quantityonhand) AS totalquantityonhand
FROM
    products p
    JOIN inventory i ON p.productid = i.productid
GROUP BY
    p.productid,
    p.manufacturerurl;
       
       
       
       
    /*
       
    В ходе работы мы создали реляционную базу данных для компании, которая продает различные категории товаров. 
    Мы определили основные таблицы, такие как categories, suppliers, products, warehouses, inventory, customers, orders и другие, 
    установили связи между ними с помощью внешних ключей и добавили необходимые ограничения для поддержания целостности данных.
    
    При создании таблиц были учтены следующие моменты:
    1. Внешние ключи настроены таким образом, чтобы при удалении записи из основной таблицы связанные записи в зависимых таблицах автоматически удалялись. Это предотвращает появление "висячих" ссылок и поддерживает целостность данных.
    
    2. Для числовых полей, таких как цены и количество, добавлены ограничения CHECK, которые гарантируют, что значения не отрицательные и соответствуют заданным условиям.
    
    3. Для некоторых полей, таких как availabilitystatus и orderdate, установлены значения по умолчанию, 
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
       
    --================================================================================================   
    --=====================================проект 2===================================================
    --================================================================================================
    
    /*
    задание: временные	структуры	и	представления,	способы	валидации	запросов
    
    
    
     * 
     */
    
     --  для решения задания написал задачи, основываясь на заданиях из дз
       
    -- 1. создать временную таблицу (temporary table), в которой будут храниться топ-5 самых дорогих товаров,
    --    проданных через интернет (ordermethod = 'Online'). под "самых дорогих" будем понимать
    --    товары с наибольшей ценой (price) в позициях заказов, размещенных через интернет.
    
    -- найдем 5 самых дорогих товаров, проданных онлайн:
    WITH top5onlineproducts AS (
        SELECT
            oi.productid,
            MAX(oi.price) AS maxpriceonline
        FROM
            orders o
            JOIN orderitems oi ON o.orderid = oi.orderid
        WHERE
            o.ordermethod = 'Online'
        GROUP BY
            oi.productid
        ORDER BY
            MAX(oi.price) DESC
        LIMIT 5
    )
    -- создаем временную таблицу на основе cte:
    CREATE TEMP TABLE temptop5onlineproducts AS
    SELECT * FROM top5onlineproducts;
    
    -- выведем данные о товарах из таблицы products, которые попали в топ-5:
    SELECT
        p.productid,
        p.manufacturerurl,
        p.listprice,
        p.minprice,
        t.maxpriceonline
    FROM
        products p
        JOIN temptop5onlineproducts t ON p.productid = t.productid;
    
    
    -- 2. создать cte employee_sales_stats, который посчитает общее количество продаж и среднее количество продаж 
    --    для каждого сотрудника (торгового представителя) за последние 30 дней. 
    --    затем вывести сотрудников с количеством продаж выше среднего по компании.
    
    -- для простоты примера считаем "продажей" любой заказ, у которого есть salesrepid, 
    -- и количество продаж - это количество заказов. возьмем период 30 дней от текущей даты.
    WITH employee_sales_stats AS (
        SELECT
            sr.salesrepid,
            sr.name,
            COUNT(o.orderid) AS salescount
        FROM
            salesrepresentatives sr
            LEFT JOIN orders o ON sr.salesrepid = o.salesrepid 
            AND o.orderdate >= (CURRENT_DATE - INTERVAL '30 day')
        GROUP BY
            sr.salesrepid, sr.name
    ),
    avg_sales AS (
        SELECT AVG(salescount) AS avgsales FROM employee_sales_stats
    )
    SELECT
        e.salesrepid,
        e.name,
        e.salescount
    FROM
        employee_sales_stats e,
        avg_sales a
    WHERE
        e.salescount > a.avgsales;
    
    
    -- 3. используя cte, создать иерархическую структуру, показывающую все товары, которые содержатся в каждой стране.
    --    иерархия: 
    --    страна -> склад (warehouse) -> товар (product)
    --    для этого объединим таблицы products, inventory, warehouses, locations. 
    
    WITH countryhierarchy AS (
        SELECT 
            l.country,
            w.warehouseid,
            w.name AS warehousename,
            i.productid
        FROM 
            warehouses w
            JOIN locations l ON w.locationid = l.locationid
            JOIN inventory i ON w.warehouseid = i.warehouseid
    )
    SELECT 
        ch.country,
        ch.warehouseid,
        ch.warehousename,
        p.productid,
        p.manufacturerurl
    FROM 
        countryhierarchy ch
        JOIN products p ON ch.productid = p.productid
    ORDER BY 
        ch.country, ch.warehouseid, p.productid;
    
    
    -- 4. напишите запрос с cte, который выведет топ-3 самых дорогих продукта (по listprice) на каждом складе.
    --    в результате укажем склад и соответствующие ему топ-3 товара по цене.
    
    WITH warehouseproducts AS (
        SELECT
            w.warehouseid,
            w.name AS warehousename,
            p.productid,
            p.listprice,
            ROW_NUMBER() OVER (PARTITION BY w.warehouseid ORDER BY p.listprice DESC) AS rn
        FROM
            warehouses w
            JOIN inventory i ON w.warehouseid = i.warehouseid
            JOIN products p ON i.productid = p.productid
    )
    SELECT
        warehouseid,
        warehousename,
        productid,
        listprice
    FROM
        warehouseproducts
    WHERE
        rn <= 3
    ORDER BY
        warehouseid, listprice DESC;
       
       
       
       
       
    --=============================================
    --представляю дополнительные примеры решения для выполнения задания проекта 2
    --создание временных структур (представлений)
    --==============================================
        
    --пример 1. создать представление, показывающее общие продажи по датам. это может быть полезно для аналитики, чтобы увидеть, как меняется объем продаж по дням.
    
    CREATE VIEW dailysales AS
    SELECT 
        orderdate,
        SUM(totalamount) AS dailytotal
    FROM orders
    GROUP BY orderdate;
    --данное представление позволяет оперативно смотреть на суммарные продажи за каждый день, не обращаясь к сложным объединениям таблиц.
    
    
    --пример 2. создать представление, отображающее количество заказанных единиц каждого товара по дням.
    --если нам требуется временная аналитика по продуктам, мы можем объединить таблицы orders и orderitems:
    
    CREATE VIEW dailyproductsales AS
    SELECT 
        o.orderdate,
        p.productid,
        SUM(oi.quantity) AS totalquantitysold,
        SUM(oi.price * oi.quantity) AS totalsalesamount
    FROM orders o
    JOIN orderitems oi ON o.orderid = oi.orderid
    JOIN products p ON p.productid = oi.productid
    GROUP BY o.orderdate, p.productid;
    --такая структура даст нам представление о том, как меняется спрос на конкретные товары с течением времени.
    
    -- применение валидации запросов и данных
    /*
    пример 1. добавление ограничений (check) для валидации данных при вставке или обновлении. 
    например, мы можем добавить ограничение для таблицы orders, чтобы убедиться, что дата заказа не находится в будущем:
    */
    ALTER TABLE orders 
    ADD CONSTRAINT check_orderdate_not_future 
    CHECK (orderdate <= CURRENT_DATE);
    --это гарантирует, что при вставке нового заказа orderdate не будет опережать текущую дату.
    /*пример 2. добавить ограничение на метод доставки, чтобы было возможно использовать только определенные варианты 
    
     (например, 'fedex', 'ups', 'usps', 'dhl'):*/
    ALTER TABLE orders 
    ADD CONSTRAINT check_shipping_method 
    CHECK (shippingmethod IN ('FedEx','UPS','USPS','DHL'));
    --это убережёт от ввода невалидных способов доставки.
    
    
    --===================================================
    -- создание индекса для повышения производительности
    --====================================================
    /*
    предположим, нам часто нужно выполнять запросы к таблице orders по дате заказа, 
    а также сортировать результаты по дате и идентификатору заказа.
    по умолчанию orderid является первичным ключом, и на нем уже есть индекс.
    для ускорения выборок по дате заказа и сортировки можно создать составной индекс по полям orderdate и orderid:
    */
    CREATE INDEX idx_orders_orderdate_orderid ON orders(orderdate, orderid);
    --теперь у нас есть индекс, который может использоваться для оптимизации запросов, фильтрующих и сортирующих данные по дате.
    
    --оценка влияния индекса на производительность с помощью explain analyze
    --рассмотрим пример запроса, который извлекает заказы за определенный период и сортирует их по дате:
    
    EXPLAIN ANALYZE
    SELECT *
    FROM orders
    WHERE orderdate BETWEEN '2023-01-01' AND '2023-01-31'
    ORDER BY orderdate, orderid;
    
    /*
    до создания индекса:
    postgresql, скорее всего, будет использовать последовательное сканирование 
    по таблице (seq scan) с последующей сортировкой, что может быть неэффективным, особенно при большом объеме данных.
    */
    
    --после создания индекса idx_orders_orderdate_orderid/ с большой вероятностью запрос сможет использовать индекс для выборки и сортировки
    
    /*
     * 
     * за счет использования индекса уменьшится стоимость выполнения запроса (cost), 
     * снизится время выполнения и количество операций ввода-вывода. 
     * вывод explain analyze покажет уменьшение времени выполнения (actual time) и 
     * менее затратный план выполнения.
     */








--==================================================================================================
--========================================ПРОЕКТ3
--==================================================================================================
/*
Создание триггеров 
Триггер before insert на таблице products для проверки минимальной цены
Этот триггер проверяет, что минимальная цена (minprice) не превышает прайс-лист (listprice) при вставке нового товара.
*/

-- Создание функции для триггера
CREATE OR REPLACE FUNCTION check_minprice_before_insert()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.minprice > NEW.listprice THEN
        RAISE EXCEPTION 'Минимальная цена (%) не может превышать прайс-лист (%)', NEW.minprice, NEW.listprice;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER trg_before_insert_products
BEFORE INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION check_minprice_before_insert();

--Триггер after update на таблице inventory для логирования изменений количества товара
--Этот триггер записывает изменения в количестве товара в таблицу логов.

-- Создание таблицы для логирования изменений
CREATE TABLE inventory_changes_log (
    log_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    old_quantity INT NOT NULL,
    new_quantity INT NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание функции для триггера
CREATE OR REPLACE FUNCTION log_inventory_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO inventory_changes_log (product_id, warehouse_id, old_quantity, new_quantity)
    VALUES (OLD.productid, OLD.warehouseid, OLD.quantityonhand, NEW.quantityonhand);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER trg_after_update_inventory
AFTER UPDATE ON inventory
FOR EACH ROW
EXECUTE FUNCTION log_inventory_changes();


/**
 * Триггер before delete на таблице customers для предотвращения удаления клиентов с активными заказами
Этот триггер запрещает удаление клиента, если у него есть связанные заказы.
 */
 -- Создание функции для триггера
CREATE OR REPLACE FUNCTION prevent_delete_customers_with_orders()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM orders WHERE customerid = OLD.customerid) THEN
        RAISE EXCEPTION 'Невозможно удалить клиента (ID: %), так как у него есть связанные заказы', OLD.customerid;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER trg_before_delete_customers
BEFORE DELETE ON customers
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_customers_with_orders();

/*Триггер instead of insert на представлении view_product_details (пример операционного триггера)
Предположим, что у нас есть представление, объединяющее информацию о продуктах, категориях и поставщиках. 
Мы можем использовать триггер INSTEAD OF для обработки вставок в это представление.*/

-- Создание представления
CREATE VIEW view_product_details AS
SELECT
    p.productid,
    p.productname,
    c.categoryname,
    s.suppliername
FROM
    products p
JOIN
    categories c ON p.categoryid = c.categoryid
JOIN
    suppliers s ON p.supplierid = s.supplierid;

-- Создание функции для триггера
CREATE OR REPLACE FUNCTION instead_insert_view_product_details()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO products (categoryid, weightgroup, warrantyperiod, supplierid, availabilitystatus, listprice, minprice, manufacturerurl)
    VALUES (NEW.categoryid, NEW.weightgroup, NEW.warrantyperiod, NEW.supplierid, NEW.availabilitystatus, NEW.listprice, NEW.minprice, NEW.manufacturerurl);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER trg_instead_insert_view_product_details
INSTEAD OF INSERT ON view_product_details
FOR EACH ROW
EXECUTE FUNCTION instead_insert_view_product_details();





--Создадим транзакций с примерами успешных и неуспешных транзакций
--Успешная транзакция: Добавление нового заказа и обновление запасов
 
BEGIN;

-- Вставка нового заказа
INSERT INTO orders (customerid, ordermethod, shippingmethod, totalamount, salesrepid)
VALUES (2, 'Онлайн', 'Почта России', 300.00, 1)
RETURNING orderid;

-- Предположим, что новый orderid = 4

-- Вставка позиций заказа
INSERT INTO orderitems (orderid, productid, quantity, price)
VALUES
(4, 1, 2, 1000.00),
(4, 5, 1, 250.00);

-- Обновление запасов
UPDATE inventory
SET quantityonhand = quantityonhand - 2
WHERE productid = 1 AND warehouseid = 1;

UPDATE inventory
SET quantityonhand = quantityonhand - 1
WHERE productid = 5 AND warehouseid = 1;

COMMIT;
-- В этой транзакции добавляется новый заказ, связанные позиции заказа и обновляются запасы на складе.
-- Все операции выполняются успешно, поэтому транзакция фиксируется.




--Неуспешная транзакция: Попытка добавить заказ с нарушением ограничения minprice <= listprice

BEGIN;

-- Вставка нового продукта с minprice > listprice
INSERT INTO products (categoryid, weightgroup, warrantyperiod, supplierid, availabilitystatus, listprice, minprice, manufacturerurl)
VALUES (1, 'Light', 24, 1, 'На складе', 500.00, 600.00, 'http://www.techcorp.com/products/6');

-- Пытаемся добавить заказ с этим продуктом
INSERT INTO orders (customerid, ordermethod, shippingmethod, totalamount, salesrepid)
VALUES (1, 'Онлайн', 'CDec', 600.00, 1)
RETURNING orderid;

-- Предположим, что новый orderid = 5

INSERT INTO orderitems (orderid, productid, quantity, price)
VALUES
(5, 6, 1, 600.00);

-- Обновление запасов
UPDATE inventory
SET quantityonhand = quantityonhand - 1
WHERE productid = 6 AND warehouseid = 1;

COMMIT;

-- В данной транзакции возникает ошибка при вставке продукта, так как minprice (600.00) превышает listprice (500.00).
-- Это нарушает ограничение, установленное триггером `trg_before_insert_products`.
-- В результате транзакция откатывается, и ни одна из операций не фиксируется в базе данных.


/*В примере неуспешной транзакции мы пытаемся вставить новый продукт, у которого minprice превышает listprice. 
 * Триггер trg_before_insert_products, созданный ранее, обнаруживает нарушение и генерирует исключение. 
 * Поскольку в транзакции произошла ошибка, все изменения, внесенные в рамках транзакции, 
 * откатываются с помощью ROLLBACK, даже если некоторые операции до этого были успешными.*/




--Использование RAISE внутри триггеров для логирования
-- Триггер after insert на таблице orders с использованием RAISE NOTICE для логирования
-- триггер выводит уведомление при добавлении нового заказа.


-- Создание функции для триггера
CREATE OR REPLACE FUNCTION log_new_order()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Новый заказ добавлен: ID = %, Клиент = %', NEW.orderid, NEW.customerid;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER trg_after_insert_orders
AFTER INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION log_new_order();





/*
Триггер after update на таблице customers с использованием RAISE EXCEPTION для предотвращения изменения страны
Этот триггер запрещает изменение поля country у клиента.

 */


-- Создание функции для триггера
CREATE OR REPLACE FUNCTION prevent_country_update()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.country <> OLD.country THEN
        RAISE EXCEPTION 'Изменение страны клиента (ID: %) запрещено', OLD.customerid;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER trg_after_update_customers
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION prevent_country_update();








--Триггер after delete на таблице suppliers с использованием RAISE NOTICE для уведомления об удалении поставщика
-- Создание функции для триггера
CREATE OR REPLACE FUNCTION notify_supplier_deletion()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Поставщик удален: ID = %, Название = %', OLD.supplierid, OLD.suppliername;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER trg_after_delete_suppliers
AFTER DELETE ON suppliers
FOR EACH ROW
EXECUTE FUNCTION notify_supplier_deletion();





/*Феномены при параллельном выполнении транзакций
Фантомное чтение (Phantom Read)
 Фантомное чтение происходит, когда одна транзакция читает набор строк, 
а другая транзакция добавляет или удаляет строки, удовлетворяющие условию первого запроса. 
При повторном выполнении первого запроса набор строк изменяется ("появляются фантомы").*/

--Пример:
--Транзакция A:
BEGIN;
SELECT * FROM orders WHERE totalamount > 100;
-- Результат: заказы с ID 1 и 2



--Транзакция B:
BEGIN;
INSERT INTO orders (customerid, ordermethod, shippingmethod, totalamount, salesrepid)
VALUES (3, 'Онлайн', 'CDec', 150.00, 2);
COMMIT;


--Транзакция A (продолжение):
SELECT * FROM orders WHERE totalamount > 100;
-- Теперь результат: заказы с ID 1, 2 и новым заказом



/*Потерянное обновление (Lost Update)
Потерянное обновление происходит, когда две транзакции одновременно читают одну и ту же строку и 
обновляют ее, при этом изменения одной транзакции могут быть перезаписаны другой.
*/
--Пример:

--Транзакция A:

BEGIN;
SELECT quantityonhand FROM inventory WHERE productid = 1 AND warehouseid = 1;
-- Допустим, количество: 50
UPDATE inventory SET quantityonhand = 51 WHERE productid = 1 AND warehouseid = 1;

--Транзакция B

BEGIN;
SELECT quantityonhand FROM inventory WHERE productid = 1 AND warehouseid = 1;
-- Количество: 50
UPDATE inventory SET quantityonhand = 52 WHERE productid = 1 AND warehouseid = 1;
COMMIT;


--Транзакция A (продолжение):
COMMIT;
-- Итоговое количество: 51 (обновление из транзакции A перезаписало 52 из транзакции B)




/*
"Грязное" чтение (Dirty Read)
"Грязное" чтение происходит, когда одна транзакция читает данные, которые были изменены другой транзакцией, 
но еще не зафиксированы. Если вторая транзакция откатится, первая транзакция будет иметь неконсистентные данные.
*/
--Пример:
--Транзакция A:
BEGIN;
UPDATE products SET listprice = 1200.00 WHERE productid = 1;

--Транзакция B:
BEGIN;
SELECT listprice FROM products WHERE productid = 1;
-- Получает listprice = 1200.00


--Транзакция A (продолжение):
ROLLBACK;

--Транзакция B (продолжение):
SELECT listprice FROM products WHERE productid = 1;
-- Все еще видит listprice = 1200.00, хотя транзакция A была откатана


/*
 * Неповторяющееся чтение (Non-Repeatable Read)
Неповторяющееся чтение происходит, когда транзакция читает одну и ту же строку несколько раз и получает разные результаты из-за изменений, 
внесенных другой транзакцией.
 * 
 * */

--Пример:
--Транзакция A:
BEGIN;
SELECT quantityonhand FROM inventory WHERE productid = 1 AND warehouseid = 1;
-- Количество: 50

--Транзакция B:
BEGIN;
UPDATE inventory SET quantityonhand = 60 WHERE productid = 1 AND warehouseid = 1;
COMMIT;

--Транзакция A (продолжение):
SELECT quantityonhand FROM inventory WHERE productid = 1 AND warehouseid = 1;
-- Теперь количество: 60
COMMIT;




/*Аномалия сериализации (Serialization Anomaly)
Аномалия сериализации возникает, когда параллельные транзакции приводят к результату, 
который невозможно получить последовательным выполнением транзакций.
*/
--Пример:
--Транзакция A:
BEGIN;
INSERT INTO orders (customerid, ordermethod, shippingmethod, totalamount, salesrepid)
VALUES (1, 'Онлайн', 'CDec', 500.00, 1);

--Транзакция B:
BEGIN;
DELETE FROM orders WHERE orderid = 1;
COMMIT;

--Транзакция A (продолжение):

UPDATE orders SET totalamount = 550.00 WHERE orderid = 1;
COMMIT;

--Результат: В базе данных может остаться заказ с totalamount = 550.00, несмотря на то, 
--что транзакция B удалила заказ с orderid = 1. Это приводит к неконсистентному состоянию.


--Теперь поэкспериментируем с уровнями изоляции и феноменами
/*
READ UNCOMMITTED
 На этом уровне транзакции могут читать "грязные" данные, то есть данные, измененные другими транзакциями, но еще не зафиксированные.
*/
--Эксперимент:
--Транзакция A:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
UPDATE products SET listprice = 1300.00 WHERE productid = 1;
-- Не фиксируем изменения

--Транзакция B:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT listprice FROM products WHERE productid = 1;
-- Получает listprice = 1300.00
ROLLBACK;

--Транзакция A (продолжение):
ROLLBACK;
--Транзакция B смогла прочитать "грязные" данные, так как уровень изоляции READ UNCOMMITTED позволяет это. 
--После отката транзакции A изменения не фиксируются, но транзакция B уже прочитала измененные данные.

/*Уровень изоляции: READ COMMITTED
Гарантирует, что транзакция читает только зафиксированные данные. "Грязные" чтения предотвращены.
*/
--Эксперимент:
--Транзакция A:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE products SET listprice = 1400.00 WHERE productid = 1;
-- Не фиксируем изменения

--Транзакция B:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT listprice FROM products WHERE productid = 1;
-- Получает исходное listprice, так как изменения в транзакции A не зафиксированы
ROLLBACK;


--Транзакция A (продолжение):
ROLLBACK;

--Транзакция B не видит незакоммиченные изменения транзакции A, что предотвращает "грязные" чтения.


/*
Уровень изоляции: REPEATABLE READ
 Гарантирует, что данные, прочитанные транзакцией, не изменятся до ее завершения. Предотвращает неповторяющиеся чтения и фантомные чтения в большинстве случаев.
*/
--Эксперимент:

--Транзакция A:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT quantityonhand FROM inventory WHERE productid = 1 AND warehouseid = 1;
-- Количество: 50

--Транзакция B:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE inventory SET quantityonhand = 70 WHERE productid = 1 AND warehouseid = 1;
COMMIT;

--Транзакция A (продолжение):
SELECT quantityonhand FROM inventory WHERE productid = 1 AND warehouseid = 1;
-- Все еще количество: 50
COMMIT;
/*
 * Если транзакция A пытается выполнить действия, 
 * которые влияют на сериализацию транзакций, она может получить ошибку и потребоваться откат. 
 * В данном примере, если нет конфликтов, обе транзакции могут успешно выполниться, но при конфликтах одна из них будет откатана.
 */







--Примеры блокировок
--Пример блокировки при обновлении записи

--Транзакция A:
BEGIN;
UPDATE products SET listprice = 1500.00 WHERE productid = 2;
-- Не фиксируем изменения


--Транзакция B:
BEGIN;
SELECT * FROM products WHERE productid = 2 FOR UPDATE;
-- Ожидает, пока транзакция A завершится
/*Транзакция A устанавливает эксклюзивную блокировку на запись продукта с productid = 2. 
 * Транзакция B пытается установить блокировку FOR UPDATE на ту же запись и вынуждена ждать завершения транзакции A. 
 * Это пример блокировки на уровне строк.*/



--Пример блокировки таблицы при массовом обновлении
--Транзакция A:
BEGIN;
UPDATE products SET availabilitystatus = 'Нет на складе';
-- Не фиксируем изменения

--Транзакция B:
BEGIN;
SELECT * FROM products;
-- Может ожидать, пока транзакция A завершится, в зависимости от уровня изоляции

/*Транзакция A обновляет все записи в таблице products, устанавливая статус доступности. 
Это может привести к блокировке всей таблицы для других транзакций, пытающихся читать или изменять данные в таблице products до завершения транзакции A.
*/


--Избежание взаимных блокировок (Deadlocks)
--Пример:
--Транзакция A:

BEGIN;
UPDATE products SET listprice = 1600.00 WHERE productid = 3;

--Транзакция B:
BEGIN;
UPDATE products SET listprice = 1700.00 WHERE productid = 4;

--Транзакция A (продолжение):
UPDATE products SET listprice = 1800.00 WHERE productid = 4;
-- Ожидает блокировку, установленную транзакцией B

--Транзакция B (продолжение):
UPDATE products SET listprice = 1900.00 WHERE productid = 3;
-- Ожидает блокировку, установленную транзакцией A
COMMIT;
--В данном сценарии транзакции A и B ожидают освобождения блокировок, установленных друг другом, что приводит к взаимной блокировке (deadlock). 
--СУБД обнаруживает deadlock и отменяет одну из транзакций для разрешения ситуации.












   
