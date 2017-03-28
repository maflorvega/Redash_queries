/*
Name: Amount of clicks to BHHS web page (After Feb 26th)
Data source: 4
Created By: Admin
Last Update At: 2016-03-04T15:23:44.130568+00:00
*/

SELECT count(*)
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) >= DATE('2016-02-26')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_prop1 = 'article'
  AND post_prop75= 'article_page_berkshire_hathaway_widget'
  AND post_page_event ='100'
  AND post_prop72 LIKE '%www.berkshire%'
