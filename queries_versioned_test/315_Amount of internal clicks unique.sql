/*
Name: Amount of internal clicks unique
Data source: 4
Created By: Admin
Last Update At: 2016-03-03T23:48:18.082746+00:00
*/
SELECT count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop10= 'berkshire_hathaway_widget'
 AND post_prop72 = ''
and post_page_event='0'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2016-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
