/*
Name: Listings NOT PUBLISHED by Feed Client
Data source: 4
Created By: Admin
Last Update At: 2016-08-26T19:44:25.589748+00:00
*/

SELECT Feed_Client,
       Listing_ID,
       nvl(Listings.mls_id,'--') AS Mls_id,
       Agent,
       CASE
           WHEN (Listings.geocoded_addresses='[]'
                 AND Listings.primary_listing_image IS NOT NULL) THEN 'Without GeoLoc'
           WHEN (Listings.primary_listing_image IS NULL
                 AND Listings.geocoded_addresses!='[]') THEN 'Without Image'
           WHEN (Listings.geocoded_addresses='[]'
                 AND Listings.primary_listing_image IS NULL) THEN 'Without GeoLoc & Image'
           WHEN (Listings.published IS FALSE
                 AND (Listings.geocoded_addresses!='[]'
                      OR Listings.primary_listing_image IS NOT NULL)) THEN 'Other Reason' /*Not published*/
           ELSE 'Not'
       END AS Error_Reason,
FROM
  (SELECT String(listing_id) AS Listing_ID,
          INTEGER(marketingGroup_id) AS marketingGroup_id,
          marketingGroup_name AS Feed_Client,
          agent_name AS Agent
   FROM [djomniture:devspark.MG_Hierarchy_Listing]
   WHERE (marketingGroup_id = '{{mg_id}}' and  '{{status}}' != 'Failed')
   GROUP BY Listing_id,
            marketingGroup_id,
            Feed_Client,
            Agent) AS Listings_MG
JOIN EACH
  (SELECT STRING(id) AS id,
          geocoded_addresses,
          published,
          primary_listing_image,
          mls_id,
   FROM [djomniture:devspark.MG_Listings]
   WHERE master_listing_id IS NULL
     AND last_published IS NULL
     AND published IS FALSE /*ver esto*/
     AND '{{status}}' != 'Failed'
   and  Date(created_at)=DATE('{{listing_table_date}}')
  ) AS Listings ON Listings_MG.Listing_ID=Listings.id
ORDER BY Error_Reason
