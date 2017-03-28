/*
Name: Amount of internal clicks
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T15:37:31.404193+00:00
*/
SELECT post_prop72,
       post_prop10,
       post_prop75,page_url
     
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE  post_prop10='berkshire_hathaway_widget'
  AND post_prop72 = ''
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')

