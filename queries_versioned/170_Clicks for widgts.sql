/*
Name: Clicks for widgts
Data source: 4
Created By: Admin
Last Update At: 2016-02-03T15:57:00.412574+00:00
*/
SELECT date_time, geo_country,geo_city, count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%mod=berkshire_hathaway_widget%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
group by date_time,geo_country,geo_city
order by Clicks desc
