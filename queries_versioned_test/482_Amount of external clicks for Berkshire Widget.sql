/*
Name: Amount of external clicks for Berkshire Widget
Data source: 4
Created By: Admin
Last Update At: 2016-12-05T17:57:55.262370+00:00
*/
SELECT count(*) AS external_Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop68='ExternalClick'
  and post_prop75= 'article_page_berkshire_hathaway_widget'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='article')
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
