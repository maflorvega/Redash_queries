/*
Name: Listing Views through article body
Data source: 4
Created By: Admin
Last Update At: 2016-11-21T20:04:41.577692+00:00
*/
SELECT Listing, 
MG_LA.street_address +','+ MG_LA.city+','+MG_LA.zip_code  + MG_LA.country Listing_address,   
MG_HL.agent_name as Agent,
nvl(MG_HL.brokerage_name,"") as Brokerage,
sum(Views) as Views
FROM
  (SELECT post_prop20 AS Listing,page_url,
   COUNT(*) AS Views,
   /*Listing properties per listing*/
    FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PageView Calls*/
     AND post_prop19 = 'listing' /* Counting Listings */
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}') 
     and post_prop10 = 'article_body' 
   group by Listing,page_url
  )c
/*List of valid listings (active/no active)*/
JOIN each (select * from [djomniture:devspark.MG_Listing_Address])AS MG_LA ON c.Listing = MG_LA.id
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
group by Listing,Listing_address, Agent, Brokerage
order by Views desc
