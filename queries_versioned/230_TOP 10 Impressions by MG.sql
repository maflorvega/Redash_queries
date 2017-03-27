/*
Name: TOP 10 Impressions by MG
Data source: 4
Created By: Admin
Last Update At: 2016-02-17T18:09:13.661574+00:00
*/
SELECT TOP(H_Lis.marketingGroup_name,10) AS Top_Marketing_Group,
       count(*) AS Impressions
FROM
  (SELECT post_prop34,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   and date(date_time) > date('2016-02-02')
     AND post_prop33 = 'MG_HomeHero_Impressions') v
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34



