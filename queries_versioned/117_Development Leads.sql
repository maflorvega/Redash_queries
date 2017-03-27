/*
Name: Development Leads
Data source: 4
Created By: Admin
Last Update At: 2015-11-25T19:57:51.292653+00:00
*/
/*
 * This query will display all the Leads related with a Development Id.
 * Due to a Development Id can be related with more than one listing id 
 * the query must be joined by DevelopmentId and by ListingId
 */
Select * from (
/*First Query to select all the leads given a DevelopmenId*/  
SELECT date(date) AS date,
       b.Email AS Email_Address,
       b.Subject as Subject,
       b.development_id as Development_id,
       '' as listing_id,
	   '' as Marketing_Group,
       '' AS ListingAddress,
       b.contact_Name as Contact_Name,
       b.contact_email AS Email,
       b.contact_phone Phone,
       NTH(2, SPLIT(regexp_replace(string(text),'\n',' '), '>')) AS Inquiry,
       b.STATE AS Status,
  	   b.Tags as Tags,
       b.Opens as Opens,
       b.Clicks as Clicks
FROM [djomniture:devspark.MG_Leads] b
WHERE date(date) >= DATE('{{startdate}}')
  AND date(date) <= DATE('{{enddate}}')
  AND development_id = '{{devid}}'
),(
/*Second Query to select all the leads related with the listingsId included in a given DevelopmentId*/  
SELECT date(date) AS date,
       b.Email AS Email_Address,
       b.Subject as Subject,
       b.development_id as Development_id,
       b.listing_id as listing_id,
	   Hier_List.marketingGroup_name as Marketing_Group,
       Lis_Det.address AS ListingAddress,
       b.contact_Name as Contact_Name,
       b.contact_email AS Email,
       b.contact_phone Phone,
       NTH(2, SPLIT(regexp_replace(string(text),'\n',' '), '>')) AS Inquiry,
       b.STATE AS Status,
  	   b.Tags as Tags,
       b.Opens as Opens,
       b.Clicks as Clicks  
FROM [djomniture:devspark.MG_Leads] b
JOIN (SELECT string(du.listing_id) listing_id FROM [djomniture:devspark.MG_Development_Units] du WHERE string(du.development_id) = '{{devid}}') du on du.listing_id = b.listing_id
LEFT OUTER JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON b.Listing_id = Lis_Det.id
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS Hier_List ON Lis_Det.id = Hier_List.listing_id 
WHERE date(date) >= DATE('{{startdate}}')
  AND date(date) <= DATE('{{enddate}}')
)
ORDER BY date DESC
