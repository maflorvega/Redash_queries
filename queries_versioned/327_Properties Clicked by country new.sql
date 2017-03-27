/*
Name: Properties Clicked by country new
Data source: 4
Created By: Admin
Last Update At: 2016-03-04T19:46:49.945363+00:00
*/
SELECT Loc.Country AS Country,
       count(*) AS Clicks
FROM
  (SELECT UPPER(geo_country) AS geo_country,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop10= 'berkshire_hathaway_widget'
     AND post_prop72 = ''
     AND post_page_event='0' /*added by joche*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2016-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}')) v
left outer JOIN [djomniture:devspark.Geo_Loc] Loc ON Loc.Country_code = v.geo_country
GROUP BY Country
ORDER BY Clicks DESC
