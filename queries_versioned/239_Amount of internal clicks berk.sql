/*
Name: Amount of internal clicks berk
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T13:26:47.985684+00:00
*/
SELECT date_time, page_url,
       count(*)
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop10 = 'berkshire_hathaway_widget'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
GROUP BY page_url,date_time
ORDER BY page_url

limit 30
