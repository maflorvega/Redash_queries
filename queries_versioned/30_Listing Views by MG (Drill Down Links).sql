/*
Name: Listing Views by MG (Drill Down Links)
Data source: 4
Created By: Admin
Last Update At: 2015-08-26T18:35:02.142348+00:00
*/
SELECT '<a href="?p_mgid='+ mgid + '" onClick="gotoMyURL(href)">' + marketingGroup + '</a>' marketingGroup,
       Listing AS [Amount_of_Listings],
       Views,
       Visits,
       Visitors,
       nvl(Leads,'0') AS Leads
FROM
  (SELECT marketingGroup,
          mgid,
          COUNT(*) AS Views,
          COUNT(DISTINCT Listing) AS Listing,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
          sum(Leads) AS Leads
   FROM
     (SELECT MG_H.marketingGroup_name AS marketingGroup,
             MG_H.marketingGroup_id AS mgid,
             Listing,
             post_visid_high,
             post_visid_low,
             visit_num,
             LEADS.Leads AS Leads
      FROM
        (SELECT NTH(1, SPLIT(post_prop7, '_')) AS agentId,
                NTH(1, SPLIT(post_prop20, '-')) AS Listing,
                post_visid_high,
                post_visid_low,
                visit_num
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE post_page_event = "0" /*condition indicated by kevin chen*/
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}')
           AND post_prop20 != '' /* listing id is not null*/
           AND post_prop19 = 'listing' /* Counting Listings */ ) a
      JOIN [djomniture:devspark.MG_Hierarchy] AS MG_H ON a.agentId = MG_H.agent_id
      LEFT OUTER JOIN
        (SELECT count(*) Leads,
                         string(Listing_id) AS Listing_ID
         FROM [djomniture:devspark.MG_Leads]
         WHERE (DATE(date) >= DATE('{{startdate}}')
                AND DATE(date) <= DATE('{{enddate}}'))
         GROUP BY Listing_ID) AS LEADS ON Listing = LEADS.Listing_ID)
   GROUP BY marketingGroup,
            mgid) a
ORDER BY marketingGroup
