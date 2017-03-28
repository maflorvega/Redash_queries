/*
Name: Listings saved information 3
Data source: 4
Created By: Admin
Last Update At: 2016-02-22T20:15:02.582580+00:00
*/
SELECT date(date_time) as date,post_prop24,count(*)
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event='100'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND (post_prop25 = "listingSaved")
group by post_prop24,date
order by date desc


