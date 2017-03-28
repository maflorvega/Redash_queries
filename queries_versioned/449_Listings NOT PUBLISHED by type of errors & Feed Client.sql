/*
Name: Listings NOT PUBLISHED by type of errors & Feed Client
Data source: 4
Created By: Admin
Last Update At: 2016-10-18T18:48:56.800346+00:00
*/
SELECT Error_Reason,
count(*) AS Listing_Ingested
FROM [djomniture:devspark.MG_Datablade_Listing_without_img_geoloc]
WHERE (STRING(MG_ID) = '{{mg_id}}'
       AND '{{status}}' != 'Failed'
      and DATE(created_at)=DATE('{{startdate}}'))
group by Error_Reason
order by Listing_Ingested DESC

