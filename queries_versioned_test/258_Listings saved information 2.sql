/*
Name: Listings saved information 2
Data source: 4
Created By: Admin
Last Update At: 2016-02-22T19:48:03.941249+00:00
*/
SELECT s.Listing_id,
       MG_HL.listing_address AS ListingAddress,
       MG_HL.marketingGroup_name AS MarketingGroup,
       MG_HL.brokerage_name AS Brokerage,
       MG_HL.branch_name AS Branch,
       MG_HL.agent_name AS Agent,
  s.Saves
from
  ( SELECT TOP(s.Listing_id) AS Listing_id,count(*) s Saves,
   FROM
     (SELECT string(post_prop26) AS Listing_id, COUNT(DISTINCT post_prop24 + "-" + string(post_prop26)) ListingSaved
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event='100'
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND (post_prop25 = "listingSaved")
      GROUP BY Listing_id)) s
LEFT OUTER JOIN
  (SELECT string(id) AS Listing
   FROM [djomniture:devspark.MG_Listings]) AS L ON s.Listing_id = L.Listing
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON s.Listing_id = MG_HL.listing_id
