/*
Name: Listing Views by MG..Agent (Drill Down)
Data source: 4
Created By: Admin
Last Update At: 2015-08-24T20:48:37.049735+00:00
*/
SELECT 
  marketingGroup,
  Brokerage,
  Branch,
  '<p "?p_mgid='+ mgid + '&p_brokerageid=' + BrokerageId + '&p_branchid=' + BranchId + '&p_agentid=' + Agent + '">' + Agent + '</p>' Agent,
  Listing,
  ListingAddress,
  Views,Visits,Visitors,
  nvl(integer(Leads),integer(0)) AS Leads,
  nvl(integer(CLICKS.ExternalClicks),integer(0)) as ExternalClicks
FROM
(Select 
 marketingGroup,mgid,Brokerage,BrokerageId,Branch,BranchId,Agent,AgentId,Views,Listing,Lis_Det.address as ListingAddress,Visits,Visitors
 from
  (SELECT marketingGroup,
          mgid,
          Brokerage,
          BrokerageId,
          Branch,
          BranchId,
          Agent,
          AgentId,
          COUNT(visit_num) AS Views,
          Listing,
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
             v.Listing as Listing
      FROM
        (SELECT nvl(L.Listing,v.Listing) as Listing, post_visid_high, post_visid_low, visit_num 
          FROM ( SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
                post_visid_high,
                post_visid_low,
                visit_num
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE post_page_event = "0" /*PageViewCalls*/
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}')
           AND post_prop19 = 'listing' /* Counting Listings */) v
         FULL OUTER JOIN each (Select string(id) as Listing from [djomniture:devspark.MG_Listings] ) AS  L ON v.Listing = L.Listing    ) v
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS  MG_HL ON v.Listing = MG_HL.listing_id)   
   WHERE (mgid = '{{mgid}}')
     AND (BrokerageId = '{{brokerageid}}')
     AND (BranchId = '{{branchid}}')
   GROUP BY marketingGroup,
            mgid,
            Brokerage,
            BrokerageId,
            Branch,
            BranchId,
            Agent,
            AgentId,
            Listing) a
JOIN [djomniture:devspark.MG_Listing_Address]  AS Lis_Det ON Listing = Lis_Det.id
) v


/*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY MGID*/
LEFT OUTER JOIN
  ( 
    SELECT string(count(Lead)) as Leads,Listing_id
    FROM (
          SELECT  1 as Lead,MG_HL.Listing_id AS Listing_id
            FROM [djomniture:devspark.MG_Leads] l
           JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON l.Listing_id = MG_HL.Listing_id   
           WHERE (DATE(date) >= DATE('{{startdate}}')
             AND DATE(date) <= DATE('{{enddate}}'))
          ) l
    GROUP BY Listing_id 
  ) AS LEADS ON v.Listing = LEADS.Listing_id

/*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY MGID*/
LEFT OUTER JOIN
(
  SELECT string(COUNT(CLICK)) AS ExternalClicks ,Listing_id FROM (
	Select Click,MG_HL.Listing_id AS Listing_id      
       from (
       SELECT 1 as Click,FIRST(SPLIT(post_prop20, '-')) AS Listing_id
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE  prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
                AND prop72 != ''
                AND prop72 != '__'
                AND DATE(date_time) >= DATE('{{startdate}}')
                AND DATE(date_time) <= DATE('{{enddate}}')  
          ) c
    JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing_id = MG_HL.Listing_id      
	) GROUP BY Listing_id
 ) AS CLICKS ON v.Listing = CLICKS.Listing_id



ORDER BY marketingGroup,
         Brokerage,
         Branch,
         Agent
