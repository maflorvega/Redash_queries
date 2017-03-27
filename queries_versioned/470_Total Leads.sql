/*
Name: Total Leads
Data source: 4
Created By: Admin
Last Update At: 2016-11-08T15:02:37.293145+00:00
*/
SELECT count(*) AS Leads
FROM [djomniture:devspark.MG_Leads]
WHERE DATE(date) >= DATE('{{startdate}}')
  AND DATE(date) <= DATE('{{enddate}}')
  AND (development_id IS NOT NULL
       OR listing_id IS NOT NULL)
