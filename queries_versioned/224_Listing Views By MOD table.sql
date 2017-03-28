/*
Name: Listing Views By MOD table
Data source: 4
Created By: Admin
Last Update At: 2016-02-17T15:04:56.653112+00:00
*/
SELECT 
       post_prop10,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
GROUP BY post_prop10
