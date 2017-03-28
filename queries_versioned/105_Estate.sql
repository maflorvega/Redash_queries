/*
Name: Estate
Data source: 4
Created By: Admin
Last Update At: 2015-11-11T20:49:11.261732+00:00
*/
SELECT l.geo_country AS Country,
       g.lat AS lat,
       g.lng AS lng,
       COUNT (*) AS COUNT,
FROM
  (SELECT *
   FROM TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}'))")
   WHERE (post_prop10 = 'mansion_global_search_cn_wsj_realestate'
          ) l
JOIN
  (SELECT lower(Country_code) as code,
          lat,
          lng
   FROM [djomniture:devspark.Geo_Loc])AS g 
ON l.geo_country = g.code
GROUP BY Country,
         lat,
         lng
ORDER BY COUNT DESC
