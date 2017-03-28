/*
Name: Unique listings saved per user total
Data source: 4
Created By: Admin
Last Update At: 2016-02-24T14:20:58.192233+00:00
*/
SELECT s.Listing_id as Listing_id,post_prop24,
       MG_HL.listing_address AS ListingAddress,
       MG_HL.marketingGroup_name AS MarketingGroup,
       MG_HL.brokerage_name AS Brokerage,
       MG_HL.branch_name AS Branch,
       MG_HL.agent_name AS Agent,count(*) as Save_Count
FROM
  (SELECT string(post_prop26) AS Listing_id,
          post_prop24 
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "listingSaved")
  ) s
LEFT OUTER JOIN
  (SELECT string(id) AS Listing
   FROM [djomniture:devspark.MG_Listings]) AS L ON s.Listing_id = L.Listing
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON s.Listing_id = MG_HL.listing_id
group by Listing_id,ListingAddress,MarketingGroup,Brokerage,Branch,Agent,post_prop24
order by Listing_id desc
