/*
Name: Home Hero Impressions
Data source: 4
Created By: Admin
Last Update At: 2016-02-17T17:46:10.375215+00:00
*/
SELECT H_Lis.marketingGroup_name AS Marketing_Group,
       H_Lis.brokerage_name AS Brokerage,
       H_Lis.branch_name AS Branch,
       H_Lis.agent_name AS Agent,
       H_Lis.listing_id AS Listing_Id,
       H_Lis.listing_address AS Listing_address,
       City,
       GL.Country AS Country,
       count(*) AS Impressions
FROM
  (SELECT post_prop34,
          upper(geo_country) AS Country,
          geo_city AS City,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   and date(date_time) > date('2016-02-02')
     AND post_prop33 = 'MG_HomeHero_Impressions') v
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.Country
GROUP BY Marketing_Group,
         Brokerage,
         Branch,
         Agent,
         Listing_Id,
         Country,
         City,
         Listing_address,
ORDER BY Impressions DESC
