/*
Name: Listing information by MOD
Data source: 4
Created By: Admin
Last Update At: 2016-01-27T17:47:44.841254+00:00
*/
SELECT Brokerage,
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
       nvl(integer(CLICKS.ExternalClicks),integer(0)) AS ExternalClicks
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
          post_prop10
   FROM
     (SELECT MG_HL.marketingGroup_id AS mgid,
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
             visit_num,
             post_prop10
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
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id
      JOIN [djomniture:devspark.MG_Listing_Address] AS MG_LA ON v.Listing = MG_LA.id
      LEFT OUTER JOIN [djomniture:devspark.MODS] M ON post_prop10 = M.MOD)
   WHERE mgid = '92'
     AND BrokerageId= STRING({{brokerageid}})
   GROUP BY Brokerage,
            Branch,
            Agent,
            Listing,
            ModDisplayName,
            Street_address,
            City,
            ZipCode,
            Country,mgid, post_prop10) v
LEFT JOIN
  (SELECT COUNT(CLICK) AS ExternalClicks,
          Listing_id,post_prop10
   FROM
     (SELECT 1 AS Click,
             FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing_id,post_prop10
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
        and date_time >= date('2016-11-18')
        and post_prop1='listing'
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')) c
   GROUP BY Listing_id,post_prop10) AS CLICKS ON ( v.listing = CLICKS.Listing_id and v.post_prop10 = CLICKS.post_prop10)

ORDER BY Brokerage,
         Branch,
          Views desc, visits desc,
