/*
Name: Leads Listing View Details
Data source: 4
Created By: Admin
Last Update At: 2015-10-05T18:53:59.535568+00:00
*/
SELECT 
	   MG_HL.marketingGroup_name as Marketing_Group,
       l.listing_id as listing_id,
	   date(date) AS date,
       Email AS Email_Address,
       Subject as Subject,
       contact_Name as Contact_Name,
       contact_email AS Contact_Email,
       contact_phone Contact_Phone,
       NTH(2, SPLIT(regexp_replace(string(text),'\n',' '), '>')) AS Inquiry,
FROM [djomniture:devspark.MG_Leads] l
JOIN (SELECT string(id) AS Listing,created_at
               FROM [djomniture:devspark.MG_All_Listings]
               where DATE(created_at) <= DATE('{{enddate}}')) as Lis on Lis.Listing= l.Listing_id
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON l.Listing_id = MG_HL.Listing_id
WHERE DATE(date) >= DATE('{{startdate}}')
AND DATE(date) <= DATE('{{enddate}}')
AND contact_email NOT LIKE '%@devspark.com%'
and {{mgid}}!= 0
and MG_HL.marketingGroup_id = '{{mgid}}'
