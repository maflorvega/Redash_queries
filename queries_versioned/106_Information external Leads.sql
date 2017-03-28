/*
Name: Information external Leads
Data source: 4
Created By: Admin
Last Update At: 2015-11-16T19:42:46.730669+00:00
*/
SELECT string(STRFTIME_UTC_USEC(DATE(date), "%m/%d/%Y")) AS date,
       b.Email AS Email_Address,
       b.Subject AS Subject,
       b.development_id AS Development_id,
       b.listing_id AS listing_id,
       Hier_List.marketingGroup_name AS Marketing_Group,
       Hier_List.marketingGroup_id AS MG_id,
       Lis_Det.street_address AS Street_address,
       Lis_Det.City AS City,
       Lis_Det.zip_code AS ZipCode,
       Lis_Det.country AS Country,
       b.contact_Name AS Contact_Name,
       b.contact_email AS Email,
       b.contact_phone Phone,
       NTH(2, SPLIT(regexp_replace(string(text),'\n',' '), '>')) AS Inquiry,
       STATE AS Status,
                Tags,
                Opens,
                Clicks
FROM [djomniture:devspark.MG_Leads] b 
JOIN
  (SELECT string(id) AS id
FROM [djomniture:devspark.MG_Listings]
  where DATE(created_at) <= DATE('{{enddate}}')) AS Listing ON b.Listing_id = Listing.id
LEFT OUTER JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON b.Listing_id = Lis_Det.id
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS Hier_List ON Lis_Det.id = Hier_List.listing_id
WHERE date(date) >= DATE('{{startdate}}')
  AND date(date) <= DATE('{{enddate}}')
  AND string('{{mgid}}') = Hier_List.marketingGroup_id
ORDER BY date DESC
