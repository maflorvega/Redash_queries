/*
Name: Top Markets by Brokerage
Data source: 4
Created By: Admin
Last Update At: 2016-09-08T14:26:52.797675+00:00
*/
SELECT H_Lis.marketingGroup_name AS Marketing_group,
       H_Lis.brokerage_name AS Brokerage,
       nvl(H_Lis.agent_name,"--") AS Agent,
       H_Lis.Listing_id AS Listing_id,
       Listings.published as Published,
       nvl(H_Lis.listing_address, H_Lis_address.street_address) AS Listing_address,
 /*      nvl(MG_LA_US.STATE,'') AS STATE,*/
       count(*) AS Views,
FROM
  (SELECT post_prop20,post_prop10 as Top_Market
   /*FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))*/
     FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop1 ='listing'
      ) v
JOIN (SELECT MOD,
          DisplayName
   FROM [djomniture:devspark.MODS]
   WHERE DisplayName='{{top_market}}') AS VM ON v.Top_Market= VM.MOD
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop20
JOIN (select string(id) as id, published 
      FROM [djomniture:devspark.MG_All_Listings]
     where DATE(created_at) <= DATE('{{enddate}}')) AS Listings ON Listings.id = v.post_prop20
LEFT  JOIN
  (SELECT address,
          ID,
          upper(city) AS City,
          street_address,
          zip_code
   FROM [djomniture:devspark.MG_Listing_Address]) AS H_Lis_address ON v.post_prop20 = H_Lis_address.id
/*LEFT JOIN
  (SELECT Zip_code,
          upper(City) AS City,
          STATE,
          State_Abbreviation
   FROM[djomniture:devspark.MG_USA_States])AS MG_LA_US ON (H_Lis_address.zip_code = MG_LA_US.Zip_code
                                                           AND H_Lis_address.City = MG_LA_US.City)*/
WHERE H_Lis.brokerage_id = '{{brokerage_id}}'
  AND H_Lis.marketingGroup_id = '{{mgid}}'
GROUP BY Brokerage, Agent, Listing_address, Listing_id, Marketing_group, Published,
ORDER BY Views desc

