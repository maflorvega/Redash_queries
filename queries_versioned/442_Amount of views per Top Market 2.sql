/*
Name: Amount of views per Top Market 2
Data source: 4
Created By: Admin
Last Update At: 2016-09-12T19:17:35.902505+00:00
*/
SELECT 
       VM.DisplayName AS TopMarket,
       count(*) AS Views
FROM
  (SELECT page_url,
          post_prop10 AS MOD,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop10 LIKE '%top_market'
     ) AS M
JOIN [djomniture:devspark.MODS] AS VM ON M.mod= VM.MOD
GROUP BY TopMarket,
         
         
ORDER BY Views DESC
