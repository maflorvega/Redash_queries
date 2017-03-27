/*
Name: Ingested Listing
Data source: 4
Created By: Admin
Last Update At: 2016-10-18T18:31:55.282498+00:00
*/

SELECT Feed_Client,
       MG_ID,
       Total_listings_count,
       Total_transformed_Candidates,
       Listings_Live,
       Listings_Not_Published,
       Not_Ingested_forX_Reason,
       '{{status}}' AS Status,
     
FROM [djomniture:devspark.MG_Datablade_Ingested_listings]
WHERE DATE(created_at) = Date('{{startdate}}')
and '{{status}}'='Success'
