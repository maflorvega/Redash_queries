/*
Name: After redirect
Data source: 4
Created By: Admin
Last Update At: 2016-02-05T13:09:31.992564+00:00
*/
SELECT  post_prop10, page_url, post_prop72,count(*) as clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND page_url LIKE '%mod=berkshire_hathaway_widget%'
  AND post_prop10 = 'berkshire_hathaway_widget' 
  AND post_prop72 = ''
group by post_prop10, page_url, post_prop72,
order by clicks desc

