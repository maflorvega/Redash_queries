/*
Name: Amount of views per Top Market
Data source: 4
Created By: Admin
Last Update At: 2016-09-08T14:14:05.693648+00:00
*/
SELECT 
       VM.DisplayName AS TopMarket,
       count(*) AS Views
FROM
  (SELECT page_url,
          post_prop10 AS MOD,
 /*  FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))*/
     FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop10 LIKE '%top_market'
     and (post_prop1='listing' or post_prop1='development')) AS M
JOIN [djomniture:devspark.MODS] AS VM ON M.mod= VM.MOD
GROUP BY TopMarket,
         
         
ORDER BY Views DESC
