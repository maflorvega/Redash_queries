/*
Name: Real estate -Geo localization
Data source: 4
Created By: Admin
Last Update At: 2015-11-11T18:44:48.936083+00:00
*/
SELECT l.geo_country as Country,
      l.geo_city  as City,
       g.lat as lat,
       g.lng as lng,
       count (*) as count,
FROM
  (SELECT *
   FROM TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}'))")
   WHERE (post_prop10 = 'mansion_global_search_cn_wsj_realestate'
         )) l
JOIN
  (SELECT geo_city ,
          geo_country,
          lat,
          lng
   FROM [djomniture:devspark.Geo_Localization])AS g ON l.geo_city = g.geo_city
AND l.geo_country = g.geo_country
group by Country, City, lat, lng
order by count desc
