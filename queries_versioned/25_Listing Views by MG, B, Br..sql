/*
Name: Listing Views by MG, B, Br.
Data source: 4
Created By: Admin
Last Update At: 2015-08-24T20:10:14.060906+00:00
*/
SELECT marketingGroup,
       Brokerage,
       mgid,
       BrokerageId ,
       v.BranchId AS branchId,
       Branch ,
       Amount_of_Listings,
       Views,
       Visits,
       Visitors,
       nvl(integer(Leads),integer(0)) AS Leads,
       nvl(integer(CLICKS.ExternalClicks),integer(0)) AS ExternalClicks
FROM
  (SELECT marketingGroup,
          mgid,
          Brokerage,
          BrokerageId,
          Branch,
          BranchId,
          COUNT(DISTINCT Listing) AS Amount_of_Listings,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT MG_HL.marketingGroup_name AS marketingGroup,
             MG_HL.marketingGroup_id AS mgid,
             MG_HL.brokerage_name AS Brokerage,
             MG_HL.brokerage_id AS BrokerageId,
             MG_HL.branch_name AS Branch,
             MG_HL.branch_id AS BranchId,
             post_visid_high,
             post_visid_low,
             Listing,
             visit_num
      FROM
        (SELECT nvl(L.Listing,v.Listing) AS Listing,
                post_visid_high,
                post_visid_low,
                visit_num
         FROM
           (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
                   post_visid_high,
                   post_visid_low,
                   visit_num
            FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
            WHERE post_page_event = "0" /*Page View Calls*/
              AND DATE(date_time) >= DATE('{{startdate}}')
              AND DATE(date_time) <= DATE('{{enddate}}')
              AND post_prop19 = 'listing' /* Counting Listings */ ) v FULL
         OUTER JOIN EACH
           (SELECT string(id) AS Listing
            FROM [djomniture:devspark.MG_Listings]
           where DATE(created_at) <= DATE('{{enddate}}')) AS L ON v.Listing = L.Listing) v
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id)
   WHERE (mgid = '{{mgid}}')
     AND (BrokerageId = '{{brokerageid}}')
   GROUP BY marketingGroup,
            mgid,
            Brokerage,
            BrokerageId,
            Branch,
            BranchId ) v /*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY MGID*/
LEFT OUTER JOIN
  (SELECT string(count(Lead)) AS Leads,
          branch_id
   FROM
     ( SELECT 1 AS Lead,
              MG_HL.branch_id AS branch_id
      FROM [djomniture:devspark.MG_Leads] l
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON l.Listing_id = MG_HL.Listing_id
      WHERE (DATE(date) >= DATE('{{startdate}}')
             AND DATE(date) <= DATE('{{enddate}}')) ) l
   GROUP BY branch_id) AS LEADS ON v.BranchId = LEADS.branch_id /*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY MGID*/
LEFT OUTER JOIN
  ( SELECT string(COUNT(CLICK)) AS ExternalClicks ,
           branch_id
   FROM
     ( SELECT Click,
              MG_HL.branch_id AS branch_id
      FROM
        ( SELECT 1 AS Click,
                 FIRST(SPLIT(post_prop20, '-')) AS Listing_id
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE post_prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
           AND post_prop68 = 'ExternalClick'
           AND DATE(date_time) >= '2016-11-18'
           AND post_prop1 = 'listing'
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}')) c
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing_id = MG_HL.Listing_id)
   GROUP BY branch_id ) AS CLICKS ON v.BranchId = CLICKS.branch_id
ORDER BY marketingGroup,
         Brokerage,
         Branch
