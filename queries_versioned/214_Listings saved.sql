/*
Name: Listings saved
Data source: 4
Created By: Admin
Last Update At: 2016-02-15T20:15:09.506685+00:00
*/

SELECT COUNT(*) ListingSaved,
FROM
  (SELECT string(post_prop26) as Listing,
          COUNT(DISTINCT string(post_prop26)) save,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "listingSaved")
  group by Listing)
