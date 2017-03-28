/*
Name: Terri Export
Data source: 4
Created By: Admin
Last Update At: 2015-12-17T18:35:25.012541+00:00
*/
SELECT 
/*marketingGroup,Brokerage,Branch,Agent,*/
Listing,Address,City,ZipCode,Country,Views,Visits,Visitors,
       nvl(integer(Leads),integer(0)) AS Leads,
       nvl(integer(CLICKS.ExternalClicks),integer(0)) AS ExternalClicks,
FROM
  (SELECT marketingGroup,mgid,Brokerage,BrokerageId,Branch,BranchId,Agent,AgentId,Views,Listing,
          Lis_Det.street_address AS Address,Lis_Det.city AS City,Lis_Det.zip_code AS ZipCode,
          Lis_Det.country AS Country,Visits,Visitors
   FROM
     (SELECT marketingGroup,mgid,Brokerage,BrokerageId,Branch,BranchId,Agent,AgentId,COUNT(visit_num) AS Views,Listing,
             COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
             COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
      FROM
        (SELECT MG_HL.marketingGroup_name AS marketingGroup,
                MG_HL.marketingGroup_id AS mgid,
                MG_HL.brokerage_name AS Brokerage,
                MG_HL.brokerage_id AS BrokerageId,
                MG_HL.branch_name AS Branch,
                MG_HL.branch_id AS BranchId,
                MG_HL.agent_name AS Agent,
                MG_HL.agent_id AS AgentId,
                post_visid_high,
                post_visid_low,
                visit_num,
                v.Listing AS Listing
         FROM
           (SELECT nvl(L.Listing,v.Listing) AS Listing,post_visid_high,post_visid_low,visit_num
            FROM
              (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,post_visid_high,post_visid_low,visit_num
               FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
               WHERE post_page_event = "0" /*PageViewCalls*/
                 AND DATE(date_time) >= DATE('{{startdate}}')
                 AND DATE(date_time) <= DATE('{{enddate}}')
                 AND post_prop19 = 'listing' /* Counting Listings */) v FULL
            
            OUTER JOIN EACH
              (SELECT string(id) AS Listing FROM [djomniture:devspark.MG_Listings]) AS L ON v.Listing = L.Listing) v
         JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id)
      WHERE (mgid = '{{mgid}}')
        AND (BrokerageId = '{{brokerageid}}')
        AND (BranchId = '{{branchid}}')
      GROUP BY marketingGroup,mgid,Brokerage,BrokerageId,Branch,BranchId,Agent,AgentId,
               Listing) a
   JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON Listing = Lis_Det.id) v /*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY MGID*/


LEFT OUTER JOIN
  (SELECT string(count(Lead)) AS Leads,Listing_id
   FROM
     (SELECT 1 AS Lead,MG_HL.Listing_id AS Listing_id
      FROM [djomniture:devspark.MG_Leads] l
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON l.Listing_id = MG_HL.Listing_id
      WHERE (DATE(date) >= DATE('{{startdate}}')
             AND DATE(date) <= DATE('{{enddate}}'))) l
   GROUP BY Listing_id) AS LEADS ON v.Listing = LEADS.Listing_id /*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY MGID*/


LEFT OUTER JOIN
  (SELECT string(COUNT(CLICK)) AS ExternalClicks,Listing_id  FROM
     (SELECT Click,MG_HL.Listing_id AS Listing_id  FROM
        (SELECT 1 AS Click,FIRST(SPLIT(post_prop20, '-')) AS Listing_id
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
           AND prop72 != ''
           AND prop72 != '__'
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}')) c
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing_id = MG_HL.Listing_id)
   GROUP BY Listing_id) AS CLICKS ON v.Listing = CLICKS.Listing_id
ORDER BY Listing
