/*
Name: New Query
Data source: 4
Created By: Admin
Last Update At: 2015-10-01T15:16:56.812405+00:00
*/
SELECT 
	   '<a ng-href="mailto:{row.leads_marketingGroup}">email</a>' as test,
       Hier_List.marketingGroup_name AS leads_marketingGroup,
       Hier_List.brokerage_name AS leads_Brokerage,
       Hier_List.branch_name AS leads_Branch,
       Hier_List.agent_name AS leads_Agent,  
  	   b.listing_id as leads_Listing,
  	   '' as ListingAddress1,
  	   '' as Views1,
  	   '' as Visits1,
  	   '' as Visitors1,
  	   null as Leads,
  	   null as ExternalClicks,
  	   date(date) AS leads_date,
       b.Email AS leads_Email_Address,
       b.Subject as leads_Subject,
       b.development_id as leads_Development_id,
       b.listing_id as leads_listing_id,
	   Hier_List.marketingGroup_name as leads_Marketing_Group,
       b.contact_Name as leads_Contact_Name,
       b.contact_email AS leads_Email,
       b.contact_phone leads_Phone,
       NTH(2, SPLIT(regexp_replace(string(text),'\n',' '), '>')) AS leads_Inquiry,
       STATE AS leads_Status,
       Tags AS leads_Tags,
       Opens AS leads_Opens,
       Clicks AS leads_Clicks
FROM [djomniture:devspark.MG_Leads] b
LEFT OUTER JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS Hier_List ON b.Listing_id = Hier_List.listing_id
WHERE date(date) >= DATE('2015-09-01')
  AND date(date) <= DATE('2015-09-31')
  AND b.listing_id is not null
ORDER BY date DESC
