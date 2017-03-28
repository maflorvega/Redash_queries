/*
Name: Traffic from WSJ editorial widget by country
Data source: 4
Created By: Admin
Last Update At: 2016-03-11T19:15:09.518465+00:00
*/
SELECT GL.Country AS Country,count(*) as Clicks,
FROM
  (SELECT upper(geo_country) AS geo_country,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop10 ='mansion_global_articles_cn_wsj_home' )v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.geo_country

group by Country,
order by Clicks desc
