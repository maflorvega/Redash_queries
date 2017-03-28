/*
Name: Listings saved not unique
Data source: 4
Created By: Admin
Last Update At: 2016-02-15T15:08:48.878827+00:00
*/
SELECT  count(*)
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event='100'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND (post_prop25 = "listingSaved")

