/*
Name: Amount of internal clicks
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T15:58:05.225370+00:00
*/
SELECT count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop75= 'article_page_berkshire_hathaway_widget'
  AND lower(post_prop1)='listing'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
