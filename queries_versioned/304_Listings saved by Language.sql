/*
Name: Listings saved by Language
Data source: 4
Created By: Admin
Last Update At: 2016-03-02T18:46:07.154889+00:00
*/

select post_prop64,count(*)
from(
SELECT string(post_prop26) Listing, post_prop64
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event='100'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND (post_prop25 = "listingSaved")
GROUP BY Listing,post_prop64)
group by post_prop64
