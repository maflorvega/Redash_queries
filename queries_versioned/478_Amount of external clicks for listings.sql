/*
Name: Amount of external clicks for listings
Data source: 4
Created By: Admin
Last Update At: 2016-12-05T17:35:29.319352+00:00
*/
SELECT count(*) AS external_Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='listing')
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
