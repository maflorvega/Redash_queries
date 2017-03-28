/*
Name: Listing Views by MG details - 7 Days
Data source: 4
Created By: Admin
Last Update At: 2015-08-19T13:48:29.891511+00:00
*/
SELECT marketingGroup,Brokerage,Branch,Agent,Listing+'-'+ListingAddress as Listing,Views,Visits,Visitors,
nvl(Leads,'0') AS Leads,
nvl(CLICKS.ExternalClicks,'0') as ExternalClicks
FROM
(Select 
 marketingGroup,Brokerage,Branch,Agent,Listing,Lis_Det.address as ListingAddress,Views,Visits,Visitors
 from
  (SELECT marketingGroup,Brokerage,Branch,Agent,Listing,
          COUNT(*) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     ( SELECT MG_HL.marketingGroup_name AS marketingGroup,
              MG_HL.brokerage_name AS Brokerage,
              MG_HL.branch_name AS Branch,
              MG_HL.agent_name AS Agent,
              Listing,
              post_visid_high,
              post_visid_low,
              visit_num
      FROM
        (SELECT /*NTH(1, SPLIT(post_prop7, '_')) AS agentId,*/
                FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
                post_visid_high,
                post_visid_low,
                visit_num
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "table_id CONTAINS '2015_'
                           AND length(table_id) >= 4
                           AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
                           AND month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) IN (month(CURRENT_DATE()),(month(CURRENT_DATE())-1))"))
         WHERE post_page_event = "0" /*condition indicated by kevin chen*/
           AND date(date_time) >= date(DATE_ADD(CURRENT_TIMESTAMP(), -7, "DAY"))
           /*AND post_prop20 != '' /* listing id is not null*/
           AND post_prop19 = 'listing' /* Counting Listings */ ) v
       JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS  MG_HL ON v.Listing = MG_HL.listing_id)
   GROUP BY marketingGroup,Brokerage,Branch,Agent,Listing
  ) a
JOIN [djomniture:devspark.MG_Listing_Address]  AS Lis_Det ON Listing = Lis_Det.id
) b

LEFT OUTER JOIN
  ( SELECT string(count(*)) Leads,string(Listing_id) AS Listing_ID
   FROM [djomniture:devspark.MG_Leads]
   WHERE month(DATE(date)) IN (month(CURRENT_DATE()),
                               month(CURRENT_DATE())-1)
     AND date(date) >= date(DATE_ADD(CURRENT_TIMESTAMP(), -7, "DAY"))
   GROUP BY Listing_ID ) AS LEADS ON a.Listing = LEADS.Listing_ID


LEFT OUTER JOIN
(SELECT agentId,Listing_ID,ExternalClicks
FROM
  (SELECT agentId,string(Listing_id) AS Listing_ID,string(count(*)) AS ExternalClicks
   FROM
        ( SELECT NTH(1, SPLIT(post_prop7, '_')) AS agentId,
                 FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing_id
         		 /*NTH(1, SPLIT(post_prop20, '-')) AS Listing_id*/
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "table_id CONTAINS '2015_'
                           AND length(table_id) >= 4
                           AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
                           AND month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) IN (month(CURRENT_DATE()),(month(CURRENT_DATE())-1))"))
         WHERE  prop72 IS NOT NULL
                AND prop72 != ''
                AND prop72 != '__'
                AND date(date_time) >= date(DATE_ADD(CURRENT_TIMESTAMP(), -7, "DAY")) )
   GROUP BY agentId,Listing_ID
  ) b)  AS CLICKS ON a.Listing = CLICKS.Listing_ID

ORDER BY marketingGroup,
         Brokerage,
         Branch,
         Agent,
         a.Listing
