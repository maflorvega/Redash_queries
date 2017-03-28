/*
Name: Listings NOT PUBLISHED by type of errors & Feed Client old
Data source: 4
Created By: Admin
Last Update At: 2016-08-26T19:36:23.813629+00:00
*/

  SELECT CASE WHEN (geocoded_addresses='[]' AND primary_listing_image IS NOT NULL) THEN 'Without GeoLoc' 
              WHEN (primary_listing_image IS NULL AND geocoded_addresses!='[]') THEN 'Without Image' 
              WHEN (geocoded_addresses='[]'AND primary_listing_image IS NULL) THEN 'Without GeoLoc & Image' 
              WHEN (Listings.published IS FALSE AND (geocoded_addresses!='[]'
     OR primary_listing_image IS NOT NULL)) THEN 'Other Reason' /*Not published*/ 
              WHEN (Listings.published IS TRUE) THEN 'NO ERROR' /*Published successfully*/
           ELSE '' END AS Error_Reason, count(*) AS Listing_Ingested
   FROM
    (SELECT String(listing_id) AS Listing_ID,
     FROM [djomniture:devspark.MG_Hierarchy_Listing]
     WHERE (marketingGroup_id = '{{mg_id}}' and  '{{status}}' != 'Failed')
     GROUP BY Listing_id) AS Listings_MG
       JOIN EACH
    (SELECT STRING(id) AS id, geocoded_addresses, published, primary_listing_image
     FROM [djomniture:devspark.MG_Listings]
     WHERE master_listing_id IS NULL
       AND last_published IS NULL
       and  '{{status}}' != 'Failed'
       AND published IS FALSE
       AND Date(created_at)= DATE('{{listing_table_date}}')) AS Listings ON Listings_MG.Listing_ID=Listings.id
       GROUP BY Error_Reason
       ORDER BY Listing_Ingested DESC
