/*
Name: SOCIAL MODS
Data source: 4
Created By: Admin
Last Update At: 2015-10-19T16:20:39.397927+00:00
*/
SELECT '<a href="?p_mgid='+ v.mgid + '&p_mod=' + ModDisplayName + '" onClick="gotoMyURL(href)">' + marketingGroup + '</a>' as MG,
       Amount_of_Listings,
       ModDisplayName AS MOD,
       Views,
       Visits,
       Visitors,
FROM
  (SELECT marketingGroup,
          mgid,
          COUNT(DISTINCT Listing) AS Amount_of_Listings,
          ModDisplayName,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT MG_HL.marketingGroup_name AS marketingGroup,
             MG_HL.marketingGroup_id AS mgid,
             nvl(M.DisplayName_s,post_prop10) AS ModDisplayName,
             Listing,
             post_visid_high,
             post_visid_low,
             visit_num
      FROM
        (SELECT nvl(L.Listing,v.Listing) AS Listing,
                post_visid_high,
                post_visid_low,
                visit_num,
                post_prop10
         FROM
           (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
                   post_visid_high,
                   post_visid_low,
                   visit_num,
                   post_prop10
            FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
            WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
              AND DATE(date_time) >= DATE('{{startdate}}')
              AND DATE(date_time) <= DATE('{{enddate}}')
              AND post_prop19 = 'listing' /* Counting Listings */ ) v FULL
         OUTER JOIN EACH
           (SELECT string(id) AS Listing
            FROM [djomniture:devspark.MG_Listings]) AS L ON v.Listing = L.Listing) v
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id
      JOIN [djomniture:devspark.MG_Social_Mods] M ON post_prop10 = MOD_s)
   GROUP BY marketingGroup,
            mgid,
            ModDisplayName) v
ORDER BY marketingGroup,
         Amount_of_Listings,
         ModDisplayName
