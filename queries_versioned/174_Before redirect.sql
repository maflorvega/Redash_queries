/*
Name: Before redirect
Data source: 4
Created By: Admin
Last Update At: 2016-02-05T15:00:18.472157+00:00
*/
SELECT  post_prop10, page_url, post_prop72,count(*) as clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%from=article_page_berkshire_hathaway_widget%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_prop10 = '' 

group by post_prop10, page_url, post_prop72,
order by clicks desc
