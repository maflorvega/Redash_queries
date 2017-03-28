/*
Name: Home Hero Impressions by Listing june 21
Data source: 4
Created By: Admin
Last Update At: 2016-06-23T17:49:37.629077+00:00
*/
SELECT H_Lis.marketingGroup_name AS Marketing_Group,
       H_Lis.brokerage_name AS Brokerage,
       H_Lis.branch_name AS Branch,
       H_Lis.agent_name AS Agent,
       H_Lis.listing_id AS Listing_Id,
       nvl(H_Lis.listing_address,H_Lis_address.street_address) AS Listing_address,
       nvl(GL.Country,'(Unknown)') AS ImpressionCountry,
       count(*) AS Impressions
FROM
  (SELECT post_prop34,
          page_url,
          upper(geo_country) AS Country,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) >= date('2016-05-04')
     AND post_prop33 = 'MG_HomeHero_Impressions') v
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34
LEFT OUTER JOIN [djomniture:devspark.MG_Listing_Address] AS H_Lis_address ON H_Lis.listing_id = H_Lis_address.id
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.Country
WHERE H_Lis.branch_id = '{{branch_id}}'
  AND H_Lis.brokerage_id = '{{brokerage_id}}'
  AND H_Lis.marketingGroup_id = '{{mgid}}'
  AND H_Lis.agent_id = '{{agent_id}}'
  AND v.post_prop34 = '{{listing_id}}'
GROUP BY Marketing_Group,
         Brokerage,
         Branch,
         Agent,
         Listing_Id,
         ImpressionCountry,
         Listing_address
ORDER BY Impressions DESC
