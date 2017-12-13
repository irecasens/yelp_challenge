use yelp_db


DROP VIEW V_Category_Rating;
DROP VIEW V_Business_Photo;
DROP TABLE tbl_V_Category_Rating;
DROP TABLE tbl_V_Business_Photo;


CREATE VIEW V_Category_Rating AS
    (SELECT 
        c.category,
        COUNT(distinct c.business_id) as n_restaurants,
        AVG(b.stars) AS mean_rating,
        SUM(b.review_count) AS total_reviews,
        SUM(b.review_count)/COUNT(distinct c.business_id) as reviews_per_restaurant
        
    FROM
        category c LEFT JOIN business b ON c.business_id = b.id
    GROUP BY 1
    ORDER BY SUM(b.review_count) DESC);
 


DROP VIEW V_reviews;
### ALL REVIEWS
CREATE VIEW V_reviews AS
    (
SELECT  distinct r.business_id, r.user_id, c.category, r.date, r.text, r.stars, r.useful, r.funny, r.cool 
    FROM
        review r LEFT JOIN category c ON c.business_id = r.business_id
    where c.category like 'Ramen'
    );
create table tbl_V_reviews select * from V_reviews;

select * from tbl_V_reviews
select count(*) from tbl_V_reviews




DROP VIEW V_reviews_Vegas;
CREATE VIEW V_reviews_Vegas AS
    (
SELECT  distinct r.business_id, r.text, r.stars, r.useful, r.funny, r.cool, b.name, b.city, b.state, b.latitude, b.longitude, b.stars as business_stars, b.review_count, b.is_open
    FROM
        review r 
        LEFT JOIN business b ON r.business_id = b.id  
        left join category c on c.business_id = r.business_id
    where b.city like 'Las Vegas' and b.neighborhood like "The Strip" and FIND_IN_SET(c.category, "Restaurants,Food,Sandwiches,Fast Food,American (Traditional),Pizza,Coffee & Tea,Italian,Burgers,Breakfast & Brunch,Mexican,American (New),Chinese,Specialty Food,Desserts,Japanese,Chicken Wings,Seafood,Salad,Sushi,Asian Fusion,Mediterranean,Steakhouses,Thai,Indian,Diners,Greek,French,Vietnamese,Vegetarian,Ethnic Food,Buffets,Korean,Tex-Mex,Soup,Hot Dogs,Donuts,Comfort Food,Vegan,Bagels,Caribbean,German,Latin American,Halal,Southern,Pakistani,British,Tapas Bars,Fish & Chips,Noodles,Food Stands,Hawaiian,Soul Food,Cajun/Creole,Portuguese,Cupcakes,Creperies,Chicken Shop,Spanish,Filipino,Irish,Cheesesteaks,Turkish,Lebanese,Taiwanese,Persian/Iranian,Delicatessen,Brasseries,Ramen,Patisserie/Cake Shop,Bistros,Tacos,Falafel,Peruvian,Brazilian,Waffles,Cuban,Kebab,Wraps,Poke,Malaysian,Pub Food,Swiss Food") >0 
    
    );
    
create table tbl_V_reviews_Vegas select * from V_reviews_Vegas;

select * from tbl_V_reviews_Vegas
select count(*) from tbl_V_reviews_Vegas




DROP VIEW V_atributes;
CREATE VIEW V_atributes AS
    (
SELECT c.category, a.*
    FROM
        attribute a LEFT JOIN category c ON a.business_id = c.business_id 
	WHERE c.category like 'Ramen'
    );
    
create table tbl_V_atributes select * from V_atributes;

CREATE VIEW V_atributes_business AS
    (
SELECT a.*, b.city, b.state, b.latitude, b.longitude, b.stars as business_stars, b.review_count, b.is_open
    FROM
        tbl_V_atributes a LEFT JOIN business b ON a.business_id = b.id 
    );
    
create table tbl_V_atributes_business select * from V_atributes_business;

select * from tbl_V_atributes_business





DROP VIEW V_business_in_NV;
DROP TABLE tbl_V_business_in_NV;

CREATE VIEW V_business_in_NV AS
    (
SELECT distinct b.id, 1 as is_here
    FROM
        business b  left join category c on c.business_id = b.id
	WHERE b.city like "Las Vegas" and FIND_IN_SET(c.category, "Restaurants,Food,Sandwiches,Fast Food,American (Traditional),Pizza,Coffee & Tea,Italian,Burgers,Breakfast & Brunch,Mexican,American (New),Chinese,Specialty Food,Desserts,Japanese,Chicken Wings,Seafood,Salad,Sushi,Asian Fusion,Mediterranean,Steakhouses,Thai,Indian,Diners,Greek,French,Vietnamese,Vegetarian,Ethnic Food,Buffets,Korean,Tex-Mex,Soup,Hot Dogs,Donuts,Comfort Food,Vegan,Bagels,Caribbean,German,Latin American,Halal,Southern,Pakistani,British,Tapas Bars,Fish & Chips,Noodles,Food Stands,Hawaiian,Soul Food,Cajun/Creole,Portuguese,Cupcakes,Creperies,Chicken Shop,Spanish,Filipino,Irish,Cheesesteaks,Turkish,Lebanese,Taiwanese,Persian/Iranian,Delicatessen,Brasseries,Ramen,Patisserie/Cake Shop,Bistros,Tacos,Falafel,Peruvian,Brazilian,Waffles,Cuban,Kebab,Wraps,Poke,Malaysian,Pub Food,Swiss Food") >0 );
    
create table tbl_V_business_in_NV select * from V_business_in_NV;


DROP VIEW V_atributes_NV;
DROP TABLE tbl_V_atributes_NV;
CREATE VIEW V_atributes_NV AS
    (
SELECT a.*
    FROM attribute a
    LEFT JOIN tbl_V_business_in_NV b  ON b.id  = a.business_id
	WHERE 
    b.is_here = 1
    );
    
create table tbl_V_atributes_NV select * from V_atributes_NV;


DROP VIEW V_business_category_NV;
DROP TABLE tbl_V_business_category_NV;

CREATE VIEW V_business_category_NV AS
    (
SELECT distinct b.*
    FROM
        business b 
        #LEFT JOIN category c ON b.id  = c.business_id
        LEFT JOIN tbl_V_business_in_NV bnv  ON bnv.id  = b.id
	WHERE 
    b.city like "Las Vegas" and bnv.is_here = 1);
    
create table tbl_V_business_category_NV select * from V_business_category_NV;
