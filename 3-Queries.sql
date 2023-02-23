/* Q3 */

SELECT count(t2.cus_gender) as NoOfCustomers, t2.cus_gender FROM 
(SELECT t1.cus_id, t1.cus_gender, t1.ord_amount, t1.cus_name FROM 
(SELECT orders.*, customer.cus_gender, customer.cus_name FROM
orders inner join customer where orders.cus_id=customer.cus_id having orders.ord_amount>=3000)
as t1  group by t1.cus_id) as t2 group by t2.cus_gender;


/* Q4 */

SELECT  product.pro_name,orders.* FROM orders, supplier_pricing, product 
where orders.cus_id=2 and orders.pricing_id=supplier_pricing.pricing_id 
and supplier_pricing.pro_id=product.pro_id;


/* Q5 */

SELECT supplier.* FROM supplier where supplier.supp_id in 
	(SELECT supp_id FROM supplier_pricing group by supp_id having 
	count(supp_id)>1) 
group by supplier.supp_id;


/* Q6 */

SELECT category.cat_id,category.cat_name, min(t3.min_price) as Min_Price FROM category inner join
(SELECT product.cat_id, product.pro_name, t2.* FROM product inner join  
(SELECT pro_id, min(supp_price) as Min_Price FROM supplier_pricing group by pro_id) 
as t2 where t2.pro_id = product.pro_id)
as t3 where t3.cat_id = category.cat_id group by t3.cat_id;


/* Q7 */

SELECT product.pro_id,product.pro_name FROM orders inner join supplier_pricing on 
supplier_pricing.pricing_id=orders.pricing_id inner join
product on product.pro_id=supplier_pricing.pro_id where orders.ord_date>"2021-10-05";


/* Q8 */

SELECT customer.cus_name,customer.cus_gender FROM customer where 
customer.cus_name like 'A%' or customer.cus_name like '%A';


/* Q9 */

DELIMITER &&  
CREATE PROCEDURE proc()
BEGIN
SELECT report.supp_id,report.supp_name,report.Average,
CASE
	WHEN report.Average =5 THEN 'Excellent Service'
    	WHEN report.Average >4 THEN 'Good Service'
    	WHEN report.Average >2 THEN 'Average Service'
    	ELSE 'Poor Service'
END AS Type_of_Service FROM 
(SELECT final.supp_id, supplier.supp_name, final.Average FROM
(SELECT test2.supp_id, sum(test2.rat_ratstars)/count(test2.rat_ratstars) as Average FROM
(SELECT supplier_pricing.supp_id, test.ORD_ID, test.RAT_RATSTARS FROM supplier_pricing inner join
(SELECT orders.pricing_id, rating.ORD_ID, rating.RAT_RATSTARS FROM 
orders inner join rating on rating.ord_id = orders.ord_id ) as test
on test.pricing_id = supplier_pricing.pricing_id) 
as test2 group by supplier_pricing.supp_id) 
as final inner join supplier where final.supp_id = supplier.supp_id) as report;
END &&  
DELIMITER ;  
call proc();