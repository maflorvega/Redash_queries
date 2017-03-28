/*
Name: TOP 10 Impressions for each MG(test)
Data source: 4
Created By: Admin
Last Update At: 2016-02-23T14:53:25.660153+00:00
*/

SELECT TOP(H_Lis.marketingGroup_id,10) AS Top_Marketing_Group,
       count(*) AS Impressions
FROM
  (SELECT post_prop34,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) > date('2016-02-02')
     AND post_prop33 = 'MG_HomeHero_Impressions') v
LEFT OUTER JOIN
  (SELECT marketingGroup_id,
          marketingGroup_name,
          listing_id
   FROM [djomniture:devspark.MG_Hierarchy_Listing]) AS H_Lis ON H_Lis.listing_id = v.post_prop34
