/*
Name: Historical Listings NOT PUBLISHED by Feed Client
Data source: 4
Created By: Admin
Last Update At: 2016-10-18T19:25:57.948809+00:00
*/
SELECT Feed_Client,
       Listing_ID,
       Mls_id,
       Agent,
       Error_Reason
FROM [djomniture:devspark.MG_Datablade_Listing_without_img_geoloc]
WHERE (string(MG_ID) = '{{mg_id}}'
       AND '{{status}}' != 'Failed'
       and Date(created_at)=DATE('{{startdate}}'))
