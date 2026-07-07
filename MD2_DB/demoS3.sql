/* 
1. Cac khai niem can luu y
- Thuc the: Student
- Moi quan he giua cac thuc the: 1-1, 1-N, N-N
- Thuoc tinh: Ma sinh vien, Ten, Tuoi, Email, Sdt,...
- Khai niem bang: Table (thuc the), Cot (THuoc tinh), Dong (Bang ghi)
- Khoa: Khoa chinh (Priamry Key) va Khoa ngoai la (Foreign Key)
2. ERM 
Neu nhu minh muon xay mot ngoi nha - quan ly thu vien - quan ly cua hang 
- Thiet ke truu tuong (Chỉ chứa các khái niệm hoặc quan hệ các thực thể)
+ Sach va nguoi dung (Many to Many)
- Thiet ke Vat ly (Khái niệm thực thể được cung cấp đầy đủ thông tin)
+ 
- Thiet ke logic (Các khái niệm thực thể được cung cấp thêm các thông tin chi tiết (Thuộc tính))
+ Sach: Ten sach, Nam phat hanh, Ma sach,...
+ Nguoi dung: Ma nguoi dung, Dia chi, Email,...
3. ERD
Quan ly cua hang 
De thiet ke ERD can 6 buoc 
B1: Xac dinh muc tieu va pham vi 
- Quan ly nhan vien, hang hoa, doanh thu (hoa don: gia, san pham, khach hang, ....), ....
B2: Thu thap du lieu 
- Quan ly nhan vien can cai gi. Tuong tu voi hang hoa va doanh thu,..
B3: Xac dinh thuc the, Xac dinh thuoc tinh
- Thuc the 1: Nhan vien: Ma nhan vien, ho va ten, tuoi,...
- Thuc the 2: San pham: Ma hang hoa, Gia, Ten san pham,..
- Thuc the 3: Khach hang: Ma khach hang, ten khach hang,...
- Thuc the 4: Hoa don: Ma hoa don
- Thuc ther  5: Category
B4: Moi quan he 
- Nhan vien vs San pham: N-N
- Category vs San pham: 1-N
- Khach hang vs Hoa don: 1-N
- San pham vs Hoa don: N-N
De the hien moi quan he nhieu nhieu trong CSDL thi can tao bang trung gian 
Bien mqh N-N thanh moi quan 1-N
VD: 
Hoa don H01 - 07/07/2026- Tong tien - 
San pham S01 - Iphone - 150000000
Hoa don chi tiet: 
H01 - 07/07/2026- S01- so luong - Gia
H01 - 07/07/2026- S02- so luong - Gia 
B5: Bat dau ve - Chuan hoa du lieu (1NF, 2NF, 3NF, BCNF - ACID)
B6: Ap dung cac rang buoc
*/
/*Co so du lieu
1. Tao moi co so du lieu 
CREATE DATABASE database_name
2. Su dung (tro) vao csdl de lam viec
USE database_name
3. Xoa csdl 
DROP DATABAE database_name
*/ 
CREATE DATABASE tsu260428_db;
USE tsu260428_db;
-- DROP DATABASE tsu260428_db;

/*
Sau khi tao CSDL thi lam viec voi bang 
1. Tao bang 
CREATE TABLE table_name(
	column_name_1 datatype constraint
    column_name_2 datatype constraint
)
2. Xoa bang 
DROP TABLE table_name

3. Sua bang
ALTER TABLE table_name 
	ADD COLUMN column_name_n datatype constraint
    DROP COLUMN column_name 
    RENAME column_name to new_column_name
    ALTER CONSTRAINTS
    MODIFY
*/

/* Tao bang Category: Danh muc san pham gom cac cot (thuoc tinh)
	+ Ma danh muc: int - khoa chinh - tu tang (auto_increment)
    + Ten danh muc: varchar(100) - not null 
    + Mo ta danh muc: text 
    + Trang thai: bit gia tri mac dinh 1
*/
CREATE TABLE categories(
	category_id int primary key auto_increment,
    category_name varchar(100) not null unique,
    category_description text, 
    category_status bit default (1)
);
/* Tao bang Product: San pham
	+ Ma san pham: int - khoa chinh - tu tang (auto_increment)
    + Ten san pham: varchar(100) - not null unique
    + Gia san pham: decimal(10,2) not null >0
    + So luong san pham: int not null >0 
    + Ma danh muc (FK): int tham chieu toi bang Category
*/
CREATE TABLE products(
	product_id int primary key auto_increment,
    product_name varchar(100) not null unique,
    product_price decimal(10,2) not null check(product_price >0),
    product_quantity int not null check(product_quantity >0),
    category_id int, 
    foreign key (category_id) references categories(category_id)
);

/*Tao bang Order: 
	+ Ma hoa don: int khoa chinh auto incre
    + Ngay tao hoa don: date
    + Tong tien thanh toan: float >0 
    + Trang thai: bit mac dinh 1
*/
CREATE TABLE orders(
	order_id int primary key auto_increment,
    order_created date,
    order_total_amount float check(order_total_amount>0),
    order_status bit default(1)
);
/*Tao bang Order_detail: bang trung gian cua order va product khoa chinh => khoa tong hop (composite key(Product(PK)va Order(PK)))
	+ Ma san pham
    + Ma don hang
    + So luong mua: int not null 
    + Thanh tien: float
*/
CREATE TABLE order_detail(
	-- tham chieu den order
    order_id int,
    foreign key (order_id) references orders(order_id),
    -- tham chieu den product
    product_id int,
    foreign key (product_id) references products(product_id),
    primary key (order_id, product_id),
    order_detail_quantity int not null, 
    order_subtotal float
);

-- ALTER 
-- Bo sung them thuoc tinh trang thai hoa don chi tiet 
-- ADD COLUMN column_name_n datatype constraint
ALTER TABLE order_detail
	ADD COLUMN order_detail_status bit default(1);
-- Doi ten order_subtotal => order_detail_subtotal 
ALTER TABLE order_detail
	RENAME COLUMN order_subtotal to order_detail_subtotal








