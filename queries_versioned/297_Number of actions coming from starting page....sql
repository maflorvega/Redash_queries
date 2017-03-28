/*
Name: Number of actions coming from starting page...
Data source: 4
Created By: Admin
Last Update At: 2016-03-01T19:03:46.695810+00:00
*/
select
v.Starting_page_type AS Starting_page_type,
count(*) AS Number_of_actions,
from 
(
select * from 
(
  SELECT LOWER(CASE WHEN post_prop19 = '' THEN 'search' ELSE post_prop19 END) as Starting_page_type,visit_page_num,visid_high,visid_low,visit_num
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")')) 
)v
join ( 
    select   visid_high,visid_low,visit_num,post_prop19,visit_page_num
    FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
    WHERE DATE(date_time) >= DATE('{{startdate}}')
      AND DATE(date_time) <= DATE('{{enddate}}') 
      AND (post_prop13 = 'LeadSubmited' OR post_prop23 = 'NewsletterSubscribe') /*AND post_prop19 = 'home'*/
  ) AS det ON det.visid_high = v.visid_high AND det.visid_low = v.visid_low AND det.visit_num = v.visit_num
)
where v.visit_page_num = '1'
GROUP BY Starting_page_type
ORDER BY Number_of_actions DESC  
