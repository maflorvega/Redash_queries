/*
Name: New Querydddddd
Data source: 4
Created By: Admin
Last Update At: 2016-10-21T16:43:03.723887+00:00
*/
SELECT  Brokerage,
       Branch,
       Agent,
       Listing,
       Street_address,
       City,
       ZipCode,
       Country,
       ModDisplayName,
       Views,
       Visits,
       Visitors,
FROM
  (SELECT mgid,
          Brokerage,
          Branch,
          Agent,
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
     (SELECT MG_HL.marketingGroup_id AS mgid,
      MG_HL.marketingGroup_name AS MarketingGroup,
             MG_HL.brokerage_id AS BrokerageId,
             MG_HL.brokerage_name AS Brokerage,
             MG_HL.branch_name AS Branch,
             MG_HL.agent_name AS Agent,
             nvl(M.DisplayName,post_prop10) AS ModDisplayName,
             Listing,
             MG_LA.address AS Street_address,
             MG_LA.city AS City,
             MG_LA.zip_code AS ZipCode,
             MG_LA.country AS Country,
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
            FROM djomniture:cipomniture_djmansionglobal.2016_06
            WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
              AND DATE(date_time) >= DATE('{{startdate}}')
              AND DATE(date_time) <= DATE('{{enddate}}')
              AND post_prop19 = 'listing' /* Counting Listings */ ) v full outer
         JOIN EACH
           (SELECT string(id) AS Listing, created_at
            FROM [djomniture:devspark.MG_All_Listings]
            where  
             DATE(created_at) <= DATE('{{enddate}}') 
           ) AS L ON v.Listing = L.Listing) v
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id
      left JOIN [djomniture:devspark.MG_Listing_Address] AS MG_LA ON v.Listing = MG_LA.id
      LEFT OUTER JOIN [djomniture:devspark.MODS] M ON post_prop10 = M.MOD)
   WHERE  mgid = '7'
   GROUP BY Brokerage,
            Branch,
            Agent,
            Listing,
            ModDisplayName,
            Street_address,
            City,
            ZipCode,
            Country,mgid) v
ORDER BY Brokerage,
         
         Views desc, visits desc
