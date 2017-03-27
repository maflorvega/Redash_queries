/*
Name: Top Market by MG
Data source: 4
Created By: Admin
Last Update At: 2016-09-08T14:24:47.334123+00:00
*/
SELECT H_Lis.marketingGroup_name AS Marketing_Group,
       nvl(H_Lis.agent_name,"--") AS Agent,
       v.post_prop20 AS Listing_id,
       Listings.published AS Published,
       nvl(H_Lis.listing_address,H_Lis_address.street_address) AS Listing_address,
       count(*) AS Views,
FROM
  (SELECT post_prop20,
          post_prop10 AS Top_Market /* FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))*/
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop1 ='listing' ) v
JOIN
  (SELECT MOD,
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
          upper(city) AS City,
          street_address,
          zip_code
   FROM [djomniture:devspark.MG_Listing_Address]) AS H_Lis_address ON v.post_prop20 = H_Lis_address.id /*   LEFT JOIN
     (SELECT Zip_code,
             upper(City) AS City,
             STATE,
             State_Abbreviation
      FROM[djomniture:devspark.MG_USA_States])AS MG_LA_US ON (H_Lis_address.zip_code = MG_LA_US.Zip_code
                                                              AND H_Lis_address.City = MG_LA_US.City)*/
WHERE H_Lis.marketingGroup_id = '{{mgid}}'
GROUP BY Marketing_Group,
         Agent,
         Listing_id,
         Listing_address,
         Published,

ORDER BY Views DESC
