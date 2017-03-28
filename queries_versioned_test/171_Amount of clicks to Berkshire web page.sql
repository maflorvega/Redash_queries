/*
Name: Amount of clicks to Berkshire web page
Data source: 4
Created By: Admin
Last Update At: 2016-02-04T13:58:47.707303+00:00
*/

SELECT 
       count(*) AS ExternalClicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE 
   DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2016-02-26')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_prop1 = 'article'
  AND post_prop75= 'article_page_berkshire_hathaway_widget'
  and post_page_event ='100'
  and post_prop72 like '%www.berkshire%'
ORDER BY ExternalClicks DESC
