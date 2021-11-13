create database lab;
use lab;
create table Customer(cus_id int primary key, cus_name varchar(20), cus_phone varchar(20), cus_city varchar(20), cus_gender varchar(20));
create table Order_(ord_id int primary key, ord_amount int, ord_date date, cus_id int, prod_id int, foreign key(cUS_id) references customer(cus_id));
create table Category(cat_id int primary key, cat_name varchar(20));
create table Product(pro_id int primary key, pro_name varchar(20), pro_desc varchar(20), cat_id int, foreign key(cat_id) references Category(cat_id));
create table Product_details(prod_id int primary key, pro_id int, supp_id int, prod_price int, foreign key(pro_id) references Product(pro_id));
create table Supplier(supp_id int primary key, supp_name varchar(20), supp_city varchar(20), supp_phone int);
create table rating(rat_id int primary key, cus_id int, supp_id int, rat_ratstars int, foreign key(cus_id) references Customer(cus_id));

alter table Customer modify column cus_phone varchar(20);
insert into Customer values( 1, "Aakash", 99999999999, "Delhi", "M");
insert into Customer values( 2, "Aman", 9785463215 , "Noida","M");
insert into Customer values( 3, "Neha",9999999999 , "Mumbai","F");
insert into Customer values( 4, "Megha", 9994562399, "Kolkata","F");
insert into Customer values( 5, "Pulkit", 7895999999 , "Lucknow","M");

alter table Order_ modify column ord_date date;
insert into Order_ values(20,1500,"2021-10-12",3,5);
insert into Order_ values(25,30500,"2021-09-16",5,2);
insert into Order_ values(26,2000,"2021-10-05",1,1);
insert into Order_ values(30,3500,"2021-08-16",4,3);
insert into Order_ values(50,2000,"2021-10-06",2,1);

insert into Category values( 1, "Books");
insert into Category values( 2, "Games");
insert into Category values( 3, "Groceries");
insert into Category values( 4, "Electronics");
insert into Category values( 5, "Clothes");

insert into Product values(1 , "GTA V", "DFJDJFDJFDJFDJFJF",2);
insert into Product values(2 , "Tshirt", "DFDFJDFJDKFD",5);
insert into Product values(3 , "ROG Laptop", "DFNTTNTNTERND",4);
insert into Product values(4 , "Oats", "REURENTBTOTH",3);
insert into Product values(5, "Harry Potter", "NBEMCTHTJTH",1);

insert into Product_details values(1,1,2,1500);
insert into Product_details values(2,3,5,30000);
insert into Product_details values(3,5,1,3000);
insert into Product_details values(4,2,3,2500);
insert into Product_details values(5,4,1,1000);
alter table Supplier modify column supp_phone varchar(20);
insert into Supplier values(1,"Rajesh Retails","Delhi","1234567890");
insert into Supplier values(2,"Appario Ltd.","Mumbai","2589631470");
insert into Supplier values(3,"Knome products","Banglore","9785462315");
insert into Supplier values(4,"Bansal Retails","Kochi","8975463285");
insert into Supplier values(5,"Mittal Ltd.","Lucknow","7898456532");
insert into rating values(1,2,2,4);
insert into rating values(2,3,4,3);
insert into rating values(3,5,1,5);
insert into rating values(4,1,3,2);
insert into rating values(5,4,5,4);
/*3rd query*/
SELECT count(cus_gender), cus_gender FROM Customer WHERE  cus_id in (SELECT cus_id  FROM Order_ WHERE ord_amount > 3000)
group by cus_gender;
/*4th Query*/
select pro_name from Product where pro_id in (select pro_id from Product_details where prod_id in
(SELECT prod_id from Order_ WHERE cus_id = 2));
/*5th Query*/
select supp_name from Supplier where supp_id in (select supp_id from Product_details GROUP BY supp_id
HAVING COUNT(supp_id)>1);
/*6th Query*/
select cat_name from category where cat_id in
(select cat_id from product where pro_id in
(select pro_id from Product_details where pro_id in 
(select pro_id from Order_ order by ord_amount asc limit 0,1)));

select cat_name from category where cat_id in
(select cat_id from product where pro_id in
(select pro_id from Product_details where pro_id in 
(select pro_id from Order_ where ord_amount in(SELECT Min(ord_amount),prod_id FROM Order_))));

/*7th Query*/
 SELECT s.pro_id,  n.prod_id, n.ord_date, p.pro_id, p.pro_name
  FROM  product_details s
  left join Order_  n ON s.pro_id = n.prod_id
  left join product p on p.pro_id = s.pro_id order by n.ord_date limit 4,4;
  
  /*8th query*/
select s.supp_id, r.supp_id, s.supp_name from supplier s left join rating r on s.supp_id = r.supp_id order by rat_ratstars desc;

/*9TH query*/
select cus_name,cus_gender from Customer where cus_name like "A%" 
UNION
select cus_name,cus_gender from Customer where cus_name like "%A";

/*10th query*/
select sum(ord_amount) from Order_ where cus_id in (select cus_id from Customer where cus_gender = "M");

/*11th Query*/
select cus_name,ord_id, ord_amount, ord_date, prod_id from Order_ LEFT OUTER JOIN Customer on Customer.cus_id = Order_.cus_id;

/*12th*/ 

DELIMITER &&  
CREATE PROCEDURE get_merit_student ()  
BEGIN  
select supp_id, rat_ratstars, IF(rat_ratstars>4, "YES",  "NO") as GenuineSupplier, 
IF(rat_ratstars>2, "YES",  "NO") as AverageSupplier, 
IF(rat_ratstars<=2, "YES",  "NO") as Do_not_Consider from rating;
END && DELIMITER ;

CALL get_merit_student ();