-- Nhóm câu lệnh DDL (Data Definition Language): CREATE; DROP; ALTER;...
-- Nhóm câu lệnh DML (Data Manipulation Language): chỉnh sửa nội dung bên trong. INSERT, UPDATE, DELETE, SELECT
-- Tao csdl session06 cung voi bang product, category

-- 1. Tao csdl
CREATE DATABASE IF NOT EXISTS session06_db;

-- 2. Su dung CSDL
USE session06_db;

-- 3. Tạo bảng category, product
CREATE TABLE IF NOT EXISTS categories(
    category_id int primary key auto_increment,
    category_name varchar(100) not null unique,
    category_status bit default(1)
);

CREATE TABLE IF NOT EXISTS product(
    product_id char(5) primary key,
    product_name varchar(100) not null unique,
    product_price float check (product_price > 0),
    product_status bit default(1)
);

ALTER TABLE product
    ADD COLUMN category_id int;

ALTER TABLE product
    ADD FOREIGN KEY (category_id) REFERENCES categories(category_id);

-- 4. Them du lieu
/*
    C1: INSERT INTO [table_name](column1, column2,...)
    VALUES(value1, value2,...)=> recommend
    C2: INSERT INTO [table_name]
    VALUES(value1, value2,...)=> sai lech cot, sai lech kieu du lieu
    C3: INSERT INTO [table_name](column1, column2,...)
    VALUE(value1, value2,...)=> Khong su dung
    Luu y: co the them 1 hoac nhieu dong du lieu
*/

INSERT INTO categories(category_name, category_status)
VALUES ('LAPTOP', 1),
       ('DIEN THOAI', 0);

INSERT INTO product(product_id, product_name, product_price, product_status, category_id)
VALUES ('P001', 'MACBOOK M5', 2000, 1, 1),
       ('P002', 'IPHONE 18', 1500, 1, 2),
       ('P003', 'SAMSUNG GALAXY S25', 350, 1, 2),
       ('P004', 'LENOVO THINKPAD X9', 1200, 1, 1),
       ('P005', 'XIAOMI', 150, 1, 2);

-- UPDATE va DELETE
/*
UPDATE table_name SET column_name
DELETE FROM table_name WHERE condition
*/

-- Chuyen trang thai cua san pham xiaomi ve status 0
UPDATE product
SET product_status = 0 
WHERE product_name = 'XIAOMI';

-- Chuyen tat ca cac san pham ve status =1
-- Tat che do safemode
SET SQL_SAFE_UPDATES = 0;

UPDATE product
SET product_status = 1;

-- Bat che do safemode
SET SQL_SAFE_UPDATES = 1;

-- Xoa id=P003 ra khoi bang product
DELETE FROM product WHERE product_id = 'P003';

-- 6. SELECT: Truy van du lieu bang
/*
    SELECT column1, column2,.. FROM table_name: truy van theo cot da ghi
    SELECT * FROM table_name: truy van tat cac cot
*/

-- Lay thong tin san pham
SELECT * FROM product;

SELECT p.product_id, p.product_name, p.product_price, p.product_status FROM product as p;
-- ALIAS: bi danh

-- 7. Lay tat ca cac danh muc dang co san pham
SELECT DISTINCT p.category_id FROM product p;

-- Truy van nang cao
-- 8. AGREGATE FUNCTION - Ham tong hop(COUNT, SUM, MIN, MAX, AVG)
-- SELECT COUNT(*) FROM table_name;
-- SELECT COUNT(column_name) FROM table_name;
SELECT COUNT(*) FROM product;
SELECT SUM(product_price) FROM product;
SELECT AVG(product_price) FROM product;

-- 9 JOIN
-- LEFTJOIN, RIGHTJOIN, OUTERJOIN, INNERJOIN, JOIN

-- Them san pham nhung khong gan category
INSERT INTO product(product_id, product_name, product_price, product_status)
VALUES('P006', 'ACER NITRO 5', 1350, 1),
      ('P007', 'DELL PRECISION 5560', 1050, 1);

-- Them category
INSERT INTO categories(category_name, category_status)
VALUES ('MAY TINH BANG', 1);

-- Su dung INNER JOIN
SELECT * FROM product p INNER JOIN categories c ON p.category_id = c.category_id;

-- Su dung LEFT JOIN
SELECT * FROM product p LEFT JOIN categories c ON p.category_id = c.category_id;

-- Su dung RIGHT JOIN
SELECT p.product_id, p.product_name, p.product_price, c.category_id FROM product p RIGHT JOIN categories c ON p.category_id = c.category_id;

-- Lam the nao de category 3 khi su dung RIGHT JOIN co ket qua san pham
SET SQL_SAFE_UPDATES = 0;
UPDATE product SET category_id = 3 WHERE product_id = 'P006';

-- 10 Lay ra cac san pham duoi 1200
SELECT * FROM product p WHERE p.product_price < 1200;

-- 11 Lay ra cac san pham co gia tu 500 den 1300
SELECT * FROM product p WHERE p.product_price > 500 AND p.product_price < 1300;

-- 12 BETWEEN vs IN
SELECT * FROM product p WHERE p.product_price BETWEEN 500 AND 1300;
SELECT * FROM product p WHERE p.product_price IN (500, 1300);

-- 13 LIKE
/*
Like dung de so sanh tim kiem chuoi ky tu
% no dai dien 0, 1 hoac nhieu ky tu
_ _ A% tim cac chuoi co ky tu thu 3 la chu A
*/
SELECT * FROM product p WHERE p.product_name = "DELL PRECISION 5560";
SELECT * FROM product p WHERE p.product_name LIKE "DELL PRECISION%";
SELECT * FROM product p WHERE p.product_name LIKE "_E%";

-- Tim san pham co chu cai thu 2 la chu E va gia tu 500 -1100
SELECT * FROM product p WHERE p.product_name LIKE "_E%" AND p.product_price BETWEEN 500 AND 1100;

-- 14. Thong ke gia trung binh theo tung danh muc (category)
SELECT p.category_id, AVG(p.product_price) FROM product p GROUP BY p.category_id;

-- 15. Thong ke cac danh muc co tong tien lon hon 1500
SELECT p.category_id, SUM(p.product_price) FROM product p GROUP BY p.category_id HAVING SUM(p.product_price) > 1500;
-- SELECT - FROM - WHERE - GROUP BY - HAVING (viet truy van)
-- Khi SQL thuc thi: FROM (thuc thi o bang nao) - WHERE (dieu kien) - GROUP BY - HAVING - SELECT

-- 16 Lay thong tin san pham sap xep tang dan
SELECT * FROM product
ORDER BY product_price;

-- 17 Lay thong tin san pham sap xep giam dan
SELECT * FROM product
ORDER BY product_price DESC;

-- 18 Lay thong tin 3 san pham gia cao nhat
SELECT * FROM product
ORDER BY product_price DESC LIMIT 3;

-- 19 Lay thong tin 3 san pham co gia gan lon nhat (bo qua san pham dat nhat)
SELECT * FROM product
ORDER BY product_price DESC LIMIT 3 OFFSET 1;

-- 10 ban ghi /trang. Toi muon xem trang thu 2
-- LIMIT 10 OFFSET 10

-- 20 Subquery - (CTE Common Table Expression)
-- Lay ra cac san pham co gia lon hon hoac bang gia tri trung binh cua cac san pham
-- 1. Tinh gia trung binh cua cac san pham
-- SELECT *, AVG(product_price) FROM product = A
-- 2 Lay thong tin san pham so sanh gia tri trung binh do
-- product_price so sanh voi A
SELECT * FROM product p WHERE p.product_price >= (SELECT AVG(p.product_price) AS 'AVG_PRICE' FROM product p);