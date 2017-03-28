/*
Name: Total views for Listings located in US
Data source: 4
Created By: Admin
Last Update At: 2017-01-02T18:00:10.856429+00:00
*/
SELECT c.Listing as Listing,
MG_LA.street_address +','+ MG_LA.city+','+MG_LA.zip_code   Listing_address,   
MG_HL.brokerage_name as Brokerage,
MG_HL.agent_name as Agent_name, 
sum(views) Views,
FROM
(SELECT post_prop20 AS Listing, count(*) as views
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event = "0" /*Page View Calls*/
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_prop19 = 'listing' /* Counting development */ 
group by Listing
) c

JOIN each (select * from [djomniture:devspark.MG_Listing_Address]
      where (UPPER(country)='US' or UPPER(country)='USA' or UPPER(country)='UNITED STATES'))AS MG_LA ON c.Listing = MG_LA.id

left JOIN each [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id

group by Listing, Listing_address,Brokerage, Agent_name
order by Views desc
