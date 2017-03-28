/*
Name: Amount of clicks per day
Data source: 4
Created By: Admin
Last Update At: 2015-10-16T16:15:45.118922+00:00
*/

SELECT STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y") AS DAY,
       count(*) AS clicks,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%article_page_subzero_widget%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-10-10')
  AND DATE(date_time) <= DATE('{{enddate}}')
GROUP BY DAY
ORDER BY CLICKS
