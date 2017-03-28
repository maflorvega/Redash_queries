/*
Name: New QueryLis2
Data source: 4
Created By: Admin
Last Update At: 2015-09-24T14:05:50.768311+00:00
*/
SELECT '<p href="?p_mgid='+ v.mgid + '" onClick="gotoMyURL(href)">' + marketingGroup + '</p>' marketingGroup,
       Amount_of_Listings,
       Views,
       Visits,
       Visitors,
       nvl(integer(Leads),integer(0)) AS Leads,
       nvl(integer(CLICKS.ExternalClicks),integer(0)) AS ExternalClicks
FROM
  (SELECT marketingGroup,
          mgid,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT Listing) AS Amount_of_Listings,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT MG_HL.marketingGroup_name AS marketingGroup,
             MG_HL.marketingGroup_id AS mgid,
             Listing,
             post_visid_high,
             post_visid_low,
             visit_num
      FROM
        ( SELECT nvl(L.Listing,v.Listing) AS Listing,
                 post_visid_high,
                 post_visid_low,
                 visit_num
         FROM
           ( SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
                    post_visid_high,
                    post_visid_low,
                    visit_num
            FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) " ))
            WHERE post_page_event = "0" /*Page View Calls*/
              AND DATE(date_time) >= DATE('{{startdate}}')
              AND DATE(date_time) <= DATE('{{enddate}}')
              AND post_prop19 = 'listing' /* Counting Listings */ ) v FULL
         OUTER JOIN EACH
           (SELECT string(id) AS Listing
            FROM [djomniture:devspark.MG_Listings]) AS L ON v.Listing = L.Listing) v
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id)
   GROUP BY marketingGroup,
            mgid) v /*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY MGID*/
LEFT OUTER JOIN
  (SELECT count(Lead) AS Leads,
          mgid
   FROM
     ( SELECT 1 AS Lead,
              MG_HL.marketingGroup_id AS mgid
      FROM [djomniture:devspark.MG_Leads] l
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON l.Listing_id = MG_HL.Listing_id
      WHERE (DATE(date) >= DATE('{{startdate}}')
             AND DATE(date) <= DATE('{{enddate}}')) ) l
   GROUP BY mgid) AS LEADS ON v.mgid = LEADS.mgid /*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY MGID*/
LEFT OUTER JOIN
  ( SELECT COUNT(CLICK) AS ExternalClicks ,
           mgid
   FROM
     ( SELECT Click,
              MG_HL.marketingGroup_id AS mgid
      FROM
        ( SELECT 1 AS Click,
                 FIRST(SPLIT(post_prop20, '-')) AS Listing_id
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) " ))
         WHERE post_prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
           AND post_prop72 != ''
           AND post_prop72 != '__'
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}')) c
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing_id = MG_HL.Listing_id)
   GROUP BY mgid ) AS CLICKS ON v.mgid = CLICKS.mgid
ORDER BY  Views DESC   ,marketingGroup
