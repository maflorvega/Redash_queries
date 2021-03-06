/*
Name: Listings 09 Listing Views by Manual MG new external clicks
Data source: 4
Created By: Admin
Last Update At: 2016-03-29T18:30:17.232935+00:00
*/
SELECT Brokerage,
       Branch,
       Agent,
       Listing,
       Street_address,
       City,
       ZipCode,
       Country,
       Views,
       Visits,
       Visitors,
       nvl(Leads,'0') AS Leads,
       nvl(CLICKS.ExternalClicks,'0') AS ExternalClicks
FROM
  (SELECT marketingGroup,
          Brokerage,
          Branch,
          Agent,
          Listing,
          Lis_Det.street_address AS Street_address,
          Lis_Det.City AS City,
          Lis_Det.zip_code AS ZipCode,
          Lis_Det.country AS Country,
          Views,
          Visits,
          Visitors
   FROM
     (SELECT marketingGroup,
             Brokerage,
             Branch,
             Agent,
             mgid,
             Listing,
             COUNT(visit_num) AS Views,
             COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
             COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
      FROM
        (SELECT MG_HL.marketingGroup_name AS marketingGroup,
                MG_HL.brokerage_id AS BrokerageId,
                MG_HL.brokerage_name AS Brokerage,
                MG_HL.branch_name AS Branch,
                MG_HL.agent_name AS Agent,
                MG_HL.marketingGroup_id AS mgid,
                Listing,
                post_visid_high,
                post_visid_low,
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
               WHERE post_page_event = "0" /*Page View calls*/
                 AND DATE(date_time) >= DATE('{{startdate}}')
                 AND DATE(date_time) <= DATE('{{enddate}}')
                 AND post_prop19 = 'listing' /* Counting Listings */ ) v /*ADDING ALL THE ACTIVE LISTINGS + INACTIVE LISTINGS WHICH HAVE ACTIVITY*/ FULL
            OUTER JOIN EACH
              (SELECT string(id) AS Listing
               FROM [djomniture:devspark.MG_Listings]) AS L ON v.Listing = L.Listing) v
         JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id) /*TO OBTAIN THE HIERARCHY DETAILS*/
      WHERE mgid = '92'
        AND BrokerageId = STRING({{brokerageid}})
      GROUP BY marketingGroup,
               Brokerage,
               Branch,
               Agent,
               mgid,
               Listing) a
   JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON Listing = Lis_Det.id) b /*ADDING THE LEADS*/
LEFT OUTER JOIN
  (SELECT string(count(*)) Leads,
                           string(Listing_id) AS Listing_ID
   FROM [djomniture:devspark.MG_Leads]
   WHERE DATE(date) >= DATE('{{startdate}}')
     AND DATE(date) <= DATE('{{enddate}}')
   GROUP BY Listing_ID) AS LEADS ON Listing = LEADS.Listing_ID /*ADDING THE EXTERNAL CLICKS*/
LEFT OUTER JOIN
  (SELECT agentId,
          Listing_ID,
          ExternalClicks
   FROM
     (SELECT agentId,
             string(Listing_id) AS Listing_ID,
             string(count(*)) AS ExternalClicks
      FROM
        (SELECT NTH(1, SPLIT(post_prop7, '_')) AS agentId,
                FIRST(SPLIT(post_prop20, '-')) AS Listing_id
         FROM [djomniture:devspark.External_Clicks]
         WHERE DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}'))
   GROUP BY agentId,
            Listing_ID) b) AS CLICKS ON a.Listing = CLICKS.Listing_ID
ORDER BY Views DESC,
         marketingGroup,
         Brokerage,
         Branch,
         Agent,
         Listing
