/*
Name: Click to BHHS Web Page by country
Data source: 4
Created By: Admin
Last Update At: 2016-02-04T16:49:33.612576+00:00
*/
SELECT Loc.Country AS Country,
       count(*) AS Clicks
FROM
  (SELECT UPPER(geo_country) AS geo_country,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop75= 'article_page_berkshire_hathaway_widget'
     AND post_prop68='ExternalClick'
	 AND post_prop1='article'
     AND date(date_time) >= date('2016-11-18')     
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')) v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] Loc ON Loc.Country_code = v.geo_country
GROUP BY Country
ORDER BY Clicks DESC
