use yelp_db;


DROP VIEW V_business_split;
DROP TABLE tbl_V_business_split;

CREATE VIEW V_business_split AS
    (
SELECT  a.id, a.name, a.neighborhood, a.stars, b.hours, SUBSTRING_INDEX(b.hours,'|',1) as Week_day, SUBSTRING_INDEX(b.hours,'|',-1) as Timeframe
FROM business a inner JOIN hours b ON a.id = b.business_id
WHERE city = 'Las Vegas');
create table tbl_V_business_split select * from V_business_split;

select * from tbl_V_business_split


DROP VIEW V_business_split2;
DROP TABLE tbl_V_business_split2;
CREATE VIEW V_business_split2 AS
    (
SELECT  a.id, a.name, a.neighborhood, a.stars, a.Week_day, a.Timeframe, SUBSTRING_INDEX(SUBSTRING_INDEX(a.Timeframe,'-',1),':',1)  as open_time, SUBSTRING_INDEX(SUBSTRING_INDEX(a.Timeframe,'-',-1),':',1)  as close_time
FROM tbl_V_business_split a left join category c on a.id = c.business_id
WHERE FIND_IN_SET(c.category, "Sandwiches,Fast Food,Pizza,Italian,Burgers,Mexican,Chinese,Japanese,Chicken Wings,Sushi,Asian Fusion,Mediterranean,Thai,Indian,Diners,Greek,Vietnamese,Vegetarian,Ethnic Food,Buffets,Korean,Tex-Mex,Soup,Hot Dogs,Vegan,Halal,Pakistani,Tapas Bars,Fish & Chips,Noodles,Hawaiian,Soul Food,Taiwanese,Ramen,Tacos,Falafel,Peruvian,Brazilian,Cuban,Kebab,Wraps,Poke,Malaysian") >0 
);
create table tbl_V_business_split2 select * from V_business_split2;

select * from tbl_V_business_split2;


select b.id, b.name, b.neighborhood, b.stars, 
max(CASE WHEN b.Week_day like 'Monday' then b.Timeframe end) as Monday,
max(CASE WHEN b.Week_day like 'Tuesday' then b.Timeframe end) as Tuesday,
max(CASE WHEN b.Week_day like 'Wednesday' then b.Timeframe end) as Wednesday,
max(CASE WHEN b.Week_day like 'Thursday' then b.Timeframe end) as Thursday,
max(CASE WHEN b.Week_day like 'Friday' then b.Timeframe end) as Friday,
max(CASE WHEN b.Week_day like 'Saturday' then b.Timeframe end) as Saturday,
max(CASE WHEN b.Week_day like 'Sunday' then b.Timeframe end) as Sunday
from tbl_V_business_split b
group by 1,2,3,4;




