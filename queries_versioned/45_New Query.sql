/*
Name: New Query
Data source: 4
Created By: Admin
Last Update At: 2015-09-03T20:39:55.976933+00:00
*/
SELECT marketingGroup,Brokerage,Branch,Agent,Listing,Listing_Address,Amount_of_Listings,Views,Visits,Visitors,Leads,ExternalClicks
FROM (  
/*PRIMER QUERY: VALORES X MG*/
SELECT 
	v1.marketingGroup as marketingGroup,
    v1.mgid as mgid,
    string(v1.Amount_of_Listings) as Amount_of_Listings,
	v1.Views as Views,
	v1.Visits as Visits,
	v1.Visitors as Visitors,
    nvl(Leads,'0') AS Leads,
    nvl(CLICKS.ExternalClicks,'0') as ExternalClicks
FROM
  (SELECT marketingGroup,mgid,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT Listing) AS Amount_of_Listings,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT MG_HL.marketingGroup_name AS marketingGroup,MG_HL.marketingGroup_id AS mgid,Listing,post_visid_high,post_visid_low,visit_num,
      FROM
        ( SELECT nvl(L.Listing,v.Listing) as Listing, post_visid_high, post_visid_low, visit_num FROM (
          SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,post_visid_high,post_visid_low,visit_num
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE post_page_event = "0" /*PageView Call*/
          AND post_prop19 = 'listing' /* Counting Listings */ 
          AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}')
         ) v FULL OUTER JOIN each (Select string(id) as Listing from [djomniture:devspark.MG_Listings] ) AS  L ON v.Listing = L.Listing  
        ) a
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS  MG_HL ON a.Listing = MG_HL.listing_id
     )   
    WHERE mgid = '{{mg_id}}'
   GROUP BY marketingGroup,mgid) v1

/*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY MGID*/
LEFT OUTER JOIN
  ( 
    SELECT string(count(Lead)) as Leads,mgid
    FROM (
          SELECT  1 as Lead,MG_HL.marketingGroup_id AS mgid
            FROM [djomniture:devspark.MG_Leads] l
           JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON l.Listing_id = MG_HL.Listing_id   
           WHERE (DATE(date) >= DATE('{{startdate}}') AND DATE(date) <= DATE('{{enddate}}'))
          ) l
    GROUP BY mgid 
  ) AS LEADS ON v1.mgid = LEADS.mgid

/*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY MGID*/
LEFT OUTER JOIN
(
  SELECT string(COUNT(CLICK)) AS ExternalClicks ,mgid FROM (
	Select Click,MG_HL.marketingGroup_id AS mgid      
       from (
       SELECT 1 as Click,FIRST(SPLIT(post_prop20, '-')) AS Listing_id
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE  prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
                AND prop72 != ''
                AND prop72 != '__'
                AND DATE(date_time) >= DATE('{{startdate}') AND DATE(date_time) <= DATE('{{enddate}}')  
          ) c
    JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing_id = MG_HL.Listing_id      
	) GROUP BY mgid
 ) AS CLICKS ON v1.mgid = CLICKS.mgid
) L1 ,
(
/*SEGUNDO QUERY: VALORES X BROKERAGE*/
SELECT 
	v2.marketingGroup as marketingGroup,
    v2.mgid as mgid,
	v2.Brokerage as Brokerage,
    v2.BrokerageId as BrokerageId,
    string(v2.Amount_of_Listings) as Amount_of_Listings,
	v2.Views as Views,
	v2.Visits as Visits,
	v2.Visitors as Visitors,
    nvl(Leads,'0') AS Leads,
    nvl(CLICKS.ExternalClicks,'0') as ExternalClicks
FROM
  (SELECT marketingGroup,mgid,Brokerage,BrokerageId,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT Listing ) AS Amount_of_Listings,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT MG_HL.marketingGroup_name AS marketingGroup,
             MG_HL.marketingGroup_id AS mgid,
             MG_HL.brokerage_name AS Brokerage,
             MG_HL.brokerage_id AS BrokerageId,
             post_visid_high,post_visid_low,Listing,visit_num
      FROM
        ( SELECT nvl(L.Listing,v.Listing) as Listing, post_visid_high, post_visid_low, visit_num FROM (
          SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,post_visid_high,post_visid_low,visit_num
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE post_page_event = "0" /*PageView calls*/
           AND post_prop19 = 'listing' /* Counting Listings */ 
           AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}')
         ) v FULL OUTER JOIN each (Select string(id) as Listing from [djomniture:devspark.MG_Listings] ) AS  L ON v.Listing = L.Listing  
		   ) a
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS  MG_HL ON a.Listing = MG_HL.listing_id)     
      WHERE mgid = '{{mg_id}}'
   GROUP BY marketingGroup,mgid,Brokerage,BrokerageId) v2

/*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY BrokerageId*/
LEFT OUTER JOIN
  ( 
    SELECT string(count(Lead)) as Leads,brokerage_id
    FROM (
          SELECT  1 as Lead,MG_HL.brokerage_id AS brokerage_id
            FROM [djomniture:devspark.MG_Leads] l
           JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON l.Listing_id = MG_HL.Listing_id   
           WHERE (DATE(date) >= DATE('{{startdate}}') AND DATE(date) <= DATE('{{enddate}}'))
          ) l
    GROUP BY brokerage_id 
  ) AS LEADS ON v2.BrokerageId = LEADS.brokerage_id

/*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY brokerage_id*/
LEFT OUTER JOIN
(
  SELECT string(COUNT(CLICK)) AS ExternalClicks,brokerage_id FROM (
	Select Click,MG_HL.brokerage_id AS brokerage_id      
       from (
       SELECT 1 as Click,FIRST(SPLIT(post_prop20, '-')) AS Listing_id
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE  prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
                AND prop72 != ''
                AND prop72 != '__'
                AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')  
          ) c
    JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing_id = MG_HL.Listing_id      
	) GROUP BY brokerage_id
 ) AS CLICKS ON v2.BrokerageId = CLICKS.brokerage_id
) L2 ,

(/*TERCER QUERY: VALORES X BRANCH*/
SELECT 
	v3.marketingGroup as marketingGroup,
    v3.mgid as mgid,
	v3.Brokerage as Brokerage,
    v3.BrokerageId as BrokerageId,
	v3.Branch as Branch,
  	v3.BranchId as BranchId,
    string(v3.Amount_of_Listings) as Amount_of_Listings,
	v3.Views as Views,
	v3.Visits as Visits,
	v3.Visitors as Visitors,
    nvl(Leads,'0') AS Leads,
    nvl(CLICKS.ExternalClicks,'0') as ExternalClicks
FROM
  (SELECT marketingGroup,mgid,Brokerage,BrokerageId,Branch,BranchId,
          COUNT(DISTINCT Listing ) AS Amount_of_Listings,
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
             post_visid_high,post_visid_low,Listing,visit_num
      FROM
        ( SELECT nvl(L.Listing,v.Listing) as Listing, post_visid_high, post_visid_low, visit_num FROM (
          SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,post_visid_high,post_visid_low,visit_num
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE post_page_event = "0" /*condition indicated by kevin chen*/
           AND post_prop19 = 'listing' /* Counting Listings */ 
           AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
         ) v FULL OUTER JOIN each (Select string(id) as Listing from [djomniture:devspark.MG_Listings] ) AS  L ON v.Listing = L.Listing  
		   ) a
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS  MG_HL ON a.Listing = MG_HL.listing_id)   
   WHERE mgid = '{{mg_id}}'
   GROUP BY marketingGroup,mgid,Brokerage,BrokerageId,Branch,BranchId
            ) v3

/*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY MGID*/
LEFT OUTER JOIN
  ( 
    SELECT string(count(Lead)) as Leads,branch_id
    FROM (
          SELECT  1 as Lead,MG_HL.branch_id AS branch_id
            FROM [djomniture:devspark.MG_Leads] l
           JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON l.Listing_id = MG_HL.Listing_id   
           WHERE (DATE(date) >= DATE('{{startdate}}') AND DATE(date) <= DATE('{{enddate}}'))
          ) l
    GROUP BY branch_id 
  ) AS LEADS ON v3.BranchId = LEADS.branch_id

/*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY MGID*/
LEFT OUTER JOIN
(
  SELECT string(COUNT(CLICK)) AS ExternalClicks ,branch_id FROM (
	Select Click,MG_HL.branch_id AS branch_id      
       from (
       SELECT 1 as Click,FIRST(SPLIT(post_prop20, '-')) AS Listing_id
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE  prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
                AND prop72 != ''
                AND prop72 != '__'
                AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')  
          ) c
    JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing_id = MG_HL.Listing_id      
	) GROUP BY branch_id
 ) AS CLICKS ON v3.BranchId = CLICKS.branch_id
) L3 , (
/*CUARTO QUERY: VALORES X AGENTE Y LISTING*/
SELECT 
	v4.marketingGroup as marketingGroup,
    v4.mgid as mgid,
	v4.Brokerage as Brokerage,
    v4.BrokerageId as BrokerageId,
	v4.Branch as Branch,
	v4.BranchId as BranchId,
	v4.Agent as Agent,
	v4.AgentId as AgentId,
	v4.Listing as Listing,
	ListingAddress as Listing_Address,
	v4.Views as Views,
	v4.Visits as Visits,
	v4.Visitors as Visitors,
    nvl(Leads,'0') AS Leads,
    nvl(CLICKS.ExternalClicks,'0') as ExternalClicks
FROM
(    SELECT marketingGroup,mgid,Brokerage,BrokerageId,Branch,BranchId,Agent,AgentId,Listing,ListingAddress,
          COUNT(visit_num) AS Views,  
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) AS Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) AS Visitors,
   FROM
     (SELECT MG_HL.marketingGroup_name AS marketingGroup,
             MG_HL.marketingGroup_id AS mgid,
             MG_HL.brokerage_name AS Brokerage,
             MG_HL.brokerage_id AS BrokerageId,
             MG_HL.branch_name AS Branch,
             MG_HL.branch_id AS BranchId,
             MG_HL.agent_name AS Agent,
             MG_HL.agent_id AS AgentId,
             Lis_Det.address as ListingAddress,
             Listing,post_visid_high,post_visid_low,visit_num
      FROM
        ( SELECT nvl(L.Listing,v.Listing) as Listing, post_visid_high, post_visid_low, visit_num FROM (
          SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,post_visid_high,post_visid_low,visit_num
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE post_page_event = "0" /*PageView Calls*/
           AND post_prop19 = 'listing' /* Counting Listings */ 
           AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
         ) v FULL OUTER JOIN each (Select string(id) as Listing from [djomniture:devspark.MG_Listings] ) AS  L ON v.Listing = L.Listing   
        ) a
        JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS  MG_HL ON a.Listing = MG_HL.listing_id  
        JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON Listing = Lis_Det.id
      ) b
   WHERE mgid = '{{mg_id}}'
   GROUP BY marketingGroup,mgid,Brokerage,BrokerageId,Branch,BranchId,Agent,AgentId,Listing,ListingAddress
) v4

/*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY MGID*/
LEFT OUTER JOIN
  ( 
    SELECT string(count(Lead)) as Leads,Listing_id
    FROM (
          SELECT  1 as Lead,MG_HL.Listing_id AS Listing_id
            FROM [djomniture:devspark.MG_Leads] l
            JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON l.Listing_id = MG_HL.Listing_id   
           WHERE (DATE(date) >= DATE('{{startdate}}') AND DATE(date) <= DATE('{{enddate}}'))
          ) l
    GROUP BY Listing_id 
  ) AS LEADS ON v4.Listing = LEADS.Listing_id

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
 ) AS CLICKS ON v4.Listing = CLICKS.Listing_id
)L4
Order by marketingGroup,Brokerage,Branch,Agent,Listing asc

