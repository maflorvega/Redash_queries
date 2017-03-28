/*
Name: Information external Leads  for Manual MG
Data source: 4
Created By: Admin
Last Update At: 2015-11-20T15:20:29.423312+00:00
*/
SELECT date(date) AS date,
       b.Email AS Email_Address,
       b.Subject AS Subject,
       b.development_id AS Development_id,
       b.listing_id AS listing_id,
       Lis_Det.street_address AS Street_address,
       Lis_Det.City AS City,
       Lis_Det.zip_code AS ZipCode,
       Lis_Det.country AS Country,
       b.contact_Name AS Contact_Name,
       b.contact_email AS Email,
       b.contact_phone Phone,
       Hier_List.brokerage_id AS BrokerageId,
       NTH(2, SPLIT(regexp_replace(string(text),'\n',' '), '>')) AS Inquiry,
       STATE AS Status,
                Tags,
                Opens,
                Clicks
FROM [djomniture:devspark.MG_Leads] b
left JOIN
  (SELECT string(id) AS Listing
   FROM [djomniture:devspark.MG_Listings]
   WHERE DATE(created_at) <= DATE('{{enddate}}')) AS L ON b.Listing_id = L.Listing
LEFT OUTER JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON b.Listing_id = Lis_Det.id
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS Hier_List ON Lis_Det.id = Hier_List.listing_id
WHERE date(date) >= DATE('{{startdate}}')
  AND date(date) <= DATE('{{enddate}}')
  AND Hier_List.marketingGroup_id = '92'
  AND Hier_List.brokerage_id = STRING({{brokerageid}})
ORDER BY date DESC
