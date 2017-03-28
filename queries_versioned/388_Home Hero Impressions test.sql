/*
Name: Home Hero Impressions test
Data source: 4
Created By: Admin
Last Update At: 2016-04-08T17:28:53.593819+00:00
*/
SELECT nvl(H_Lis.marketingGroup_name,"--") AS Marketing_Group,
       nvl(H_Lis.marketingGroup_id,"--") AS Marketing_Group_id,
       nvl(H_Lis.brokerage_name,"--") AS Brokerage,
       nvl(H_Lis.brokerage_id,"--") AS Brokerage_id,
       nvl(H_Lis.branch_name,"--") AS Branch,
       nvl(H_Lis.branch_id,"--") AS Branch_id,
       nvl(H_Lis.agent_name,"--") AS Agent,
       nvl(H_Lis.agent_id,"--") AS Agent_id,
       nvl(H_Lis.Listing_id,"--") as Listing_id,
       nvl(H_Lis.listing_address,H_Lis_address.street_address) AS Listing_address,v.post_prop1 as post_prop1,
       count(*) AS Impressions
FROM
  (SELECT post_prop34,post_prop1,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) > date('2016-02-02')
     AND post_prop33 = 'MG_HomeHero_Impressions') v
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34
LEFT OUTER JOIN [djomniture:devspark.MG_Listing_Address] AS H_Lis_address ON H_Lis.listing_id = H_Lis_address.id
GROUP BY Marketing_Group,
         Marketing_Group_id,
         Brokerage,
         Brokerage_id,
         Branch,
         Branch_id,
         Agent,
         agent_id,Listing_id,Listing_address,post_prop1
ORDER BY Impressions DESC
