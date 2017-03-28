/*
Name: Information external Leads - Manual listings
Data source: 4
Created By: Admin
Last Update At: 2015-11-19T20:18:04.678280+00:00
*/
SELECT date(date) AS date,
       b.Email AS Email_Address,
       b.Subject as Subject,
       b.development_id as Development_id,
       b.listing_id as listing_id,
	   Hier_List.marketingGroup_name as Marketing_Group,
 		Hier_List.marketingGroup_id as MG_id,
       Lis_Det.address AS ListingAddress,
       b.contact_Name as Contact_Name,
       b.contact_email AS Email,
       b.contact_phone Phone,

       NTH(2, SPLIT(regexp_replace(string(text),'\n',' '), '>')) AS Inquiry,
       STATE AS Status,
                Tags,
                Opens,
                Clicks
FROM [djomniture:devspark.MG_Leads] b
LEFT OUTER JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON b.Listing_id = Lis_Det.id
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS Hier_List ON Lis_Det.id = Hier_List.listing_id
WHERE date(date) >= DATE('{{startdate}}')
  AND date(date) <= DATE('{{enddate}}')
    Hier_List.marketingGroup_id =  '92'
ORDER BY date DESC
