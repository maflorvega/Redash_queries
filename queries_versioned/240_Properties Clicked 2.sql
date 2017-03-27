/*
Name: Properties Clicked 2
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T13:47:41.061530+00:00
*/
SELECT  date_time as date,geo_city, REGEXP_EXTRACT(page_url,r'.+\/listings\/(.+)\?.+') AS Property,
         page_url as Link,count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%mod=berkshire_hathaway_widget%'
AND post_prop10 = 'berkshire_hathaway_widget' 
  AND post_prop72 = ''
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
group by date,geo_city,Property,Link
order by Clicks desc

