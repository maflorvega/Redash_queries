/*
Name: Top Market by Listing
Data source: 4
Created By: Admin
Last Update At: 2016-09-08T14:33:46.815815+00:00
*/
SELECT H_Lis.marketingGroup_name AS Marketing_Group,
       H_Lis.brokerage_name AS Brokerage,
       H_Lis.branch_name AS Branch,
       H_Lis.agent_name AS Agent,
       H_Lis.listing_id AS Listing_Id,
       Listings.published AS Published,
       nvl(H_Lis.listing_address,H_Lis_address.street_address) AS Listing_address,
      /* H_Lis_address.zip_code as ZipCode,
       H_Lis_address.City as City,*/
       /*  nvl(MG_LA_US.STATE,'') AS STATE,*/
       v.Country AS Country,
       v.Views as Views
FROM
  (SELECT post_prop20,post_prop10 as Top_Market,
          upper(geo_country) AS Country,count(*) as Views
   /*FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))*/
     FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop1 ='listing'
   
	AND post_prop20 = '{{listing_id}}'   
     group by post_prop20,Country,Top_Market) v

JOIN (SELECT MOD,
          DisplayName
   FROM [djomniture:devspark.MODS]
   WHERE DisplayName='{{top_market}}') AS VM ON v.Top_Market= VM.MOD

JOIN
  (SELECT string(id) AS id,
          published
   FROM [djomniture:devspark.MG_All_Listings]
  where DATE(created_at) <= DATE('{{enddate}}')) AS Listings ON Listings.id = v.post_prop20
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop20
LEFT  JOIN
  (SELECT address,
          ID,         
          street_address,
   FROM [djomniture:devspark.MG_Listing_Address]) AS H_Lis_address ON v.post_prop20 = H_Lis_address.id /*LEFT JOIN
*/
WHERE H_Lis.branch_id = '{{branch_id}}'
  AND H_Lis.brokerage_id = '{{brokerage_id}}'
  AND H_Lis.marketingGroup_id = '{{mgid}}'
  AND H_Lis.agent_id = '{{agent_id}}'
ORDER BY Views DESC

