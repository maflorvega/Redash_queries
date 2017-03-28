/*
Name: Home Hero Impressions by Branch june 21
Data source: 4
Created By: Admin
Last Update At: 2016-06-23T17:49:16.740839+00:00
*/
SELECT H_Lis.marketingGroup_name AS Marketing_group,
       H_Lis.brokerage_name AS Brokerage,
       nvl(H_Lis.agent_name,"--") AS Agent,
       H_Lis.branch_name AS Branch,
       H_Lis.Listing_id AS Listing_id,
       nvl(H_Lis.listing_address,H_Lis_address.street_address) AS Listing_address,
       count(*) AS Impressions
FROM
  (SELECT post_prop34,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) >= date('2016-05-04')
     AND post_prop33 = 'MG_HomeHero_Impressions') v
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34
LEFT OUTER JOIN [djomniture:devspark.MG_Listing_Address] AS H_Lis_address ON H_Lis.listing_id = H_Lis_address.id
WHERE H_Lis.branch_id = '{{branch_id}}'
  AND H_Lis.brokerage_id = '{{brokerage_id}}'
  AND H_Lis.marketingGroup_id = '{{mgid}}'
GROUP BY Branch,
         Agent,
         Listing_address,
         Marketing_group,
         Listing_id,
         Brokerage
ORDER BY Impressions DESC
