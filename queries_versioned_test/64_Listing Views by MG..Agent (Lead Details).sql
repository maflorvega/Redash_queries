/*
Name: Listing Views by MG..Agent (Lead Details)
Data source: 4
Created By: Admin
Last Update At: 2015-10-01T14:18:29.268801+00:00
*/
select 
nvl(MarketingGroup_name,Lead_marketingGroup_name) as MarketingGroup,
nvl(Brokerage_name,Lead_brokerage_name) as Brokerage,
nvl(Branch_name,Lead_branch_name) as Branch,
nvl(Agent_name,Lead_agent_name) as Agent,
nvl(Listing,Leads_Listing) as Listing,
nvl(ListingAddress,Leads_ListingAddress) as ListingAddress,
Views,Visits,Visitors,Leads,ExternalClicks,
Leads_date,Leads_Contact_Name,Leads_Email,Leads_Phone,Leads_Inquiry
from (
  SELECT * FROM (
  SELECT 
    marketingGroup_name,
    brokerage_name,
    branch_name,
    agent_name,
    Listing,
    ListingAddress,
    Views,Visits,Visitors,
    nvl(integer(Leads),integer(0)) AS Leads,
    nvl(integer(CLICKS.ExternalClicks),integer(0)) as ExternalClicks,
  FROM
  (Select 
   marketingGroup_name,marketingGroup_id,brokerage_name,brokerage_id,branch_name,branch_id,agent_name,agent_id,Views,Listing,
   Lis_Det.address as ListingAddress,Visits,Visitors
   from
    (SELECT marketingGroup_name,
            marketingGroup_id,
            brokerage_name,
            brokerage_id,
            branch_name,
            branch_id,
            agent_name,
            agent_id,
            COUNT(visit_num) AS Views,
            Listing,
            COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
            COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
     FROM
       (SELECT MG_HL1.marketingGroup_name as marketingGroup_name,
               MG_HL1.marketingGroup_id as marketingGroup_id,
               MG_HL1.brokerage_name as brokerage_name,
               MG_HL1.brokerage_id as brokerage_id,
               MG_HL1.branch_name as branch_name,
               MG_HL1.branch_id as branch_id,
               MG_HL1.agent_name as agent_name,
               MG_HL1.agent_id as agent_id,
               post_visid_high,
               post_visid_low,
               visit_num,
               t2.Listing as Listing
        FROM
          (SELECT nvl(L.Listing,t1.Listing) as Listing, post_visid_high, post_visid_low, visit_num 
            FROM ( SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
                  post_visid_high,
                  post_visid_low,
                  visit_num
           FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
           WHERE post_page_event = "0" /*PageViewCalls*/
             AND DATE(date_time) >= DATE('{{startdate}}')
             AND DATE(date_time) <= DATE('{{enddate}}')
             AND post_prop19 = 'listing' /* Counting Listings */) t1
           FULL OUTER JOIN each (Select string(id) as Listing from [djomniture:devspark.MG_Listings] ) AS  L ON t1.Listing = L.Listing) t2
        JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS  MG_HL1 ON t2.Listing = MG_HL1.listing_id)   
     WHERE (marketingGroup_id = '{{mgid}}')
       AND (brokerage_id = '{{brokerageid}}')
       AND (branch_id = '{{branchid}}')
     GROUP BY marketingGroup_name,
              marketingGroup_id,
              brokerage_name,
              brokerage_id,
              branch_name,
              branch_id,
              agent_name,
              agent_id,
              Listing) t3
  JOIN [djomniture:devspark.MG_Listing_Address]  AS Lis_Det ON Listing = Lis_Det.id
  ) t4


  /*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY MGID*/
  LEFT OUTER JOIN
    ( 
      SELECT string(count(Lead)) as Leads,Listing_id
      FROM (
            SELECT  1 as Lead,MG_HL2.Listing_id AS Listing_id
              FROM [djomniture:devspark.MG_Leads] l
             JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL2 ON l.Listing_id = MG_HL2.Listing_id   
             WHERE (DATE(date) >= DATE('{{startdate}}')
               AND DATE(date) <= DATE('{{enddate}}'))
            ) l
      GROUP BY Listing_id 
    ) AS LEADS ON t4.Listing = LEADS.Listing_id

  /*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY MGID*/
  LEFT OUTER JOIN
  (
    SELECT string(COUNT(CLICK)) AS ExternalClicks ,Listing_id FROM (
      Select Click,MG_HL3.Listing_id AS Listing_id      
         from (
         SELECT 1 as Click,FIRST(SPLIT(post_prop20, '-')) AS Listing_id
           FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
           WHERE  prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
                  AND prop72 != ''
                  AND prop72 != '__'
                  AND DATE(date_time) >= DATE('{{startdate}}')
                  AND DATE(date_time) <= DATE('{{enddate}}')  
            ) c
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL3 ON c.Listing_id = MG_HL3.Listing_id      
      ) GROUP BY Listing_id
   ) AS CLICKS ON t4.Listing = CLICKS.Listing_id
  ),
  
  (SELECT 
         Hier_List.marketingGroup_name as Lead_marketingGroup_name,
         Hier_List.brokerage_name Lead_brokerage_name,
         Hier_List.branch_name Lead_branch_name,
         Hier_List.agent_name Lead_agent_name,
         b.listing_id as Leads_Listing,
         Lis_Det.address as Leads_ListingAddress,
         date(date) AS leads_date,
         b.contact_Name as leads_Contact_Name,
         b.contact_email AS leads_Email,
         b.contact_phone leads_Phone,
         NTH(2, SPLIT(regexp_replace(string(text),'\n',' '), '>')) AS leads_Inquiry,
  FROM [djomniture:devspark.MG_Leads] b
  JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS Hier_List ON b.Listing_id = Hier_List.listing_id
  JOIN [djomniture:devspark.MG_Listing_Address]  AS Lis_Det ON b.Listing_id = Lis_Det.id  
  WHERE date(date) >= DATE('{{startdate}}')
    AND date(date) <= DATE('{{enddate}}')
    AND (Hier_List.marketingGroup_id = '{{mgid}}')
    AND (Hier_List.brokerage_id = '{{brokerageid}}')
    AND (Hier_List.branch_id = '{{branchid}}')  
    AND b.listing_id is not null )
) f
ORDER BY 1,2,3,4,5,6
