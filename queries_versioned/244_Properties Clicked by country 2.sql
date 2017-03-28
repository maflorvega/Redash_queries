/*
Name: Properties Clicked by country 2
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T14:43:52.966037+00:00
*/
SELECT Loc.Country AS Country,
       count(*) AS Clicks
FROM
  (SELECT UPPER(geo_country) AS geo_country,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE
     post_prop75= 'article_page_berkshire_hathaway_widget'
     and post_prop1='listing'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2015-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}')) v
JOIN [djomniture:devspark.Geo_Loc] Loc ON Loc.Country_code = v.geo_country
GROUP BY Country
ORDER BY Clicks DESC
