/*
Name: Amount of internal clicks 2
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T20:27:53.606441+00:00
*/
SELECT post_prop72,
       post_prop10,
       count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%mod=berkshire_hathaway_widget%'
  AND post_prop10='berkshire_hathaway_widget'
  AND post_prop72 = ''
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
GROUP BY post_prop72,
         post_prop10,

