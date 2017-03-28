/*
Name: TOP 15 Articles more Clicked
Data source: 4
Created By: Admin
Last Update At: 2016-02-03T14:03:53.847584+00:00
*/

SELECT  TOP( REGEXP_EXTRACT(page_url,r'.+\/listings\/(.+)\?.+'),15) as Top_15_Articles_clicked, count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%mod=berkshire_hathaway_widget%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')


