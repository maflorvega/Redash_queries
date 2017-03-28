/*
Name: rrrr
Data source: 4
Created By: Admin
Last Update At: 2016-02-10T13:28:01.614661+00:00
*/
SELECT string(STRFTIME_UTC_USEC(DATE(date), "%m/%d/%Y")) AS LeadDate,
       b.Email AS Email_Address,
       b.Subject as Subject,
       b.development_id as Development_id,
       b.listing_id as listing_id,
	   Hier_List.marketingGroup_name as Marketing_Group,
       
       Lis_Det.street_address as Address, 
       Lis_Det.city as City, 
       Lis_Det.zip_code as ZipCode,
       Lis_Det.country as Country,
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
  AND Email not like '%@devspark.com%'
  AND Email not like '%@dowjones.com%'
ORDER BY date ASC
