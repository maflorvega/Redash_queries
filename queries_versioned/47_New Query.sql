/*
Name: New Query
Data source: 4
Created By: Admin
Last Update At: 2015-09-08T14:56:26.470158+00:00
*/
SELECT '<a href="?p_mgid='+ v.mgid + '" onClick="gotoMyURL(href)">' + marketingGroup + '</a>' marketingGroup,
       Amount_of_Listings,
       Views,
       Visits,
       Visitors,
       nvl(integer(Leads),integer(0)) AS Leads,
       nvl(integer(CLICKS.ExternalClicks),integer(0)) as ExternalClicks
FROM
  (SELECT marketingGroup,
          mgid,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT Listing) AS Amount_of_Listings,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT MG_HL.marketingGroup_name AS marketingGroup, MG_HL.marketingGroup_id AS mgid,
             Listing, post_visid_high, post_visid_low, visit_num
      FROM
        (
          
          SELECT nvl(L.Listing,v.Listing) as Listing, post_visid_high, post_visid_low, visit_num 
          FROM (
              SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,post_visid_high,post_visid_low,visit_num
             FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
             WHERE post_page_event = "0" /*condition indicated by kevin chen*/
               AND DATE(date_time) >= DATE('{{startdate}}')
               AND DATE(date_time) <= DATE('{{enddate}}')
               AND post_prop19 = 'listing' /* Counting Listings */ 
           ) v 
          FULL OUTER JOIN each (Select string(id) as Listing from [djomniture:devspark.MG_Listings] ) AS  L ON v.Listing = L.Listing   
        ) v
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS  MG_HL ON v.Listing = MG_HL.listing_id)   
   GROUP BY marketingGroup,
            mgid) v

ORDER BY marketingGroup
