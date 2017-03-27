/*
Name: PUBLISHED Listing without Email information
Data source: 4
Created By: Admin
Last Update At: 2016-10-18T18:27:47.036218+00:00
*/
SELECT Marketing_Group,
       Listing_ID,
       Agent,
       Phone
FROM [djomniture:devspark.MG_Listing_without_email_contact]
WHERE DATE(created_at)=DATE('{{startdate}}')
