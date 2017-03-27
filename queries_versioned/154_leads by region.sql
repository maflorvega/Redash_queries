/*
Name: leads by region
Data source: 4
Created By: Admin
Last Update At: 2016-01-29T15:30:06.169674+00:00
*/
SELECT 

       Lis_Det.country as Country,
FROM [djomniture:devspark.MG_Leads] b
LEFT OUTER JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON b.Listing_id = Lis_Det.id
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS Hier_List ON Lis_Det.id = Hier_List.listing_id
WHERE date(date) >= DATE('{{startdate}}')
  AND date(date) <= DATE('{{enddate}}')
  AND Email not like '%@devspark.com%'
  AND Email not like '%@dowjones.com%'
ORDER BY date ASC
