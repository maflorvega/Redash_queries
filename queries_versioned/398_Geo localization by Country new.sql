/*
Name: Geo localization by Country new
Data source: 4
Created By: Admin
Last Update At: 2016-04-18T15:55:45.123314+00:00
*/
SELECT l.geo_country AS Country,g.code as code,
       l.geo_city AS City,g.City as lat_city,
       g.latitude AS lat,
       g.longitude AS lng,
       COUNT (*) AS Clicks,
FROM
  (SELECT lower(geo_country) AS geo_country,
          lower(geo_city) AS geo_city
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop10 = 'mansion_global_search_cn_wsj_realestate'
          OR post_prop10 = 'mansion_global_sponsor_unit_single_cn_wsj_home')
     AND (post_prop72 IS NULL
          OR post_prop72 = ''
          OR post_prop72 = '__'/*IT  IS NOT AN EXTERNAL REDIRECTION*/)) l
LEFT OUTER JOIN
  (SELECT lower(code_country_3) AS code,
          latitude,
          longitude,
          lower(City) AS City,
   FROM [djomniture:devspark.MG_Geo_location_Cities])AS g ON (l.geo_country = g.code
                                                              AND l.geo_city= g.City)
GROUP BY Country,
         City,
         lat,
         lng, code,lat_city
ORDER BY Clicks DESC

