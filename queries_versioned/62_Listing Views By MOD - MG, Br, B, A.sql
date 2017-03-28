/*
Name: Listing Views By MOD - MG, Br, B, A
Data source: 4
Created By: Admin
Last Update At: 2015-09-29T20:06:17.998562+00:00
*/
SELECT marketingGroup,
       Brokerage,
       Branch,
       mgid,
       BrokerageId,
       BranchId,
       Agent ,
       Listing,
       Street_address,
       City,
       ZipCode,
       Country,
       ModDisplayName AS MOD,
       Views,
       Visits,
       Visitors,
FROM
  (SELECT marketingGroup,
          mgid,
          Brokerage,
          BrokerageId,
          Branch,
          BranchId,
          Agent,
          AgentId,
          Listing,
          Street_address,
          City,
          ZipCode,
          Country,
          ModDisplayName,
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
             MG_HL.agent_name AS Agent,
             MG_HL.agent_id AS AgentId,
             nvl(M.DisplayName,post_prop10) AS ModDisplayName,
             Listing,
             Lis_Det.street_address AS Street_address,
             Lis_Det.City AS City,
             Lis_Det.zip_code AS ZipCode,
             Lis_Det.country AS Country,
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
            FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
            WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
              AND DATE(date_time) >= DATE('{{startdate}}')
              AND DATE(date_time) <= DATE('{{enddate}}')
              AND post_prop19 = 'listing' /* Counting Listings */ ) v FULL
         OUTER JOIN EACH
           (SELECT string(id) AS Listing
            FROM [djomniture:devspark.MG_Listings]
           where DATE(created_at) <= DATE('{{enddate}}')) AS L ON v.Listing = L.Listing) v
      JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON v.Listing = Lis_Det.id
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id
      JOIN [djomniture:devspark.MODS] M ON post_prop10 = MOD)
   WHERE mgid = '{{mgid}}'
     AND brokerageId = '{{brokerageid}}'
     AND branchId = '{{branchid}}'
     AND ModDisplayName = '{{mod}}'
   GROUP BY marketingGroup,
            mgid,
            Brokerage,
            BrokerageId,
            Branch,
            BranchId,
            Agent,
            AgentId,
            Listing,
            Street_address,
            City,
            ZipCode,
            Country,
            ModDisplayName) v
ORDER BY marketingGroup,
         Brokerage,
         Branch,
         Agent,
         ModDisplayName
