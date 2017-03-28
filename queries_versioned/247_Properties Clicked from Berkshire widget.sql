/*
Name: Properties Clicked from Berkshire widget
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T15:54:33.592774+00:00
*/
SELECT   REGEXP_EXTRACT(page_url,r'.+\/listings\/(.+)\?.+') AS Property,
         page_url as Link,count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%mod=berkshire_hathaway_widget%'
AND post_prop10 = 'berkshire_hathaway_widget' 

  AND post_prop72 = ''
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
group by Property,Link
order by Clicks desc

