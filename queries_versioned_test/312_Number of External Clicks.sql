/*
Name: Number of External Clicks
Data source: 4
Created By: Admin
Last Update At: 2016-03-03T19:26:39.557151+00:00
*/
SELECT count(*) AS Number_of_external_clicks,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}') //visit_num > '1'
  AND (post_prop1 = 'article')
  AND post_page_event = '100'
/*  AND post_page_event = "0" /*Page View Calls*/
  AND post_prop75 = 'article_page_berkshire_hathaway_widget'
