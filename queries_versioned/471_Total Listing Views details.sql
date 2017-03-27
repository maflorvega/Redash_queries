/*
Name: Total Listing Views details
Data source: 4
Created By: Admin
Last Update At: 2016-11-21T19:56:43.136046+00:00
*/
SELECT c.Listing as Listing, 
MG_LA.street_address +','+ MG_LA.city+','+MG_LA.zip_code  + MG_LA.country Listing_address,   
nvl(MG_HL.agent_name,MG_HL.agent_id) as Agent_name,
nvl(MG_HL.brokerage_name,"") as Brokerage,
sum(c.Views) as Views
FROM
(SELECT post_prop20 AS Listing,count(*) as Views,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event = "0" /*Page View Calls*/
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_prop19 = 'listing' /* Counting development */ 
group by Listing
) c
JOIN each (select * from [djomniture:devspark.MG_Listing_Address])AS MG_LA ON c.Listing = MG_LA.id

left JOIN each [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
group by Listing, Agent_name, Brokerage,Listing_address
order by Views desc
