/*
Name: Search filters details
Data source: 4
Created By: Admin
Last Update At: 2016-11-01T14:03:30.638974+00:00
*/
select * from 
(SELECT 'Total' desc, count(*) amount
  	FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%'
),(
SELECT 'min_price' desc, count(*) amount
  	FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%' AND page_url contains 'min_price'
)
,(
SELECT 'max_price' desc, count(*) amount
  	FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%' AND page_url contains 'max_price'
)
,(
SELECT 'min_bedrooms' desc, count(*) amount
  	FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%' AND page_url contains 'min_bedrooms'
)
,(
SELECT 'min_bathrooms' desc, count(*) amount
  	FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%' AND page_url contains 'min_bathrooms'
)
,(
SELECT 'min_living_area' desc, count(*) amount
  	FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%' AND page_url contains 'min_living_area'
)
,(
SELECT 'min_lot_size' desc, count(*) amount
  	FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%' AND page_url contains 'min_lot_size'
)
,(
SELECT 'property_type' desc, count(*) amount
  	FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%' AND page_url contains 'property_type'
)
,(
SELECT 'features' desc, count(*) amount
  	FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%' AND page_url contains 'features'
)
order by 2 desc
