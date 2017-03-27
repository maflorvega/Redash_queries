/*
Name: Geo localization by Country
Data source: 4
Created By: Admin
Last Update At: 2015-11-11T13:09:24.294098+00:00
*/
SELECT l.geo_country AS Country,
       g.lat AS lat,
       g.lng AS lng,
       COUNT (*) AS Clicks,
FROM
  (SELECT *
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop10 = 'mansion_global_search_cn_wsj_realestate'
          OR post_prop10 = 'mansion_global_sponsor_unit_single_cn_wsj_home')
   AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')  
   AND (post_prop72 IS NULL
          OR post_prop72 = ''
          OR post_prop72 = '__'/*IT  IS NOT AN EXTERNAL REDIRECTION*/)) l
JOIN
  (SELECT lower(Country_code) AS code,
          lat,
          lng
   FROM [djomniture:devspark.Geo_Loc])AS g ON l.geo_country = g.code
GROUP BY Country,
         lat,
         lng
ORDER BY Clicks DESC
