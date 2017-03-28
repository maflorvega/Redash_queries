/*
Name: Sub Zero Amount of clicks
Data source: 4
Created By: Admin
Last Update At: 2015-10-15T17:08:25.643397+00:00
*/
SELECT count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%article_page_subzero_widget%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-10-10')
  AND DATE(date_time) <= DATE('{{enddate}}')
