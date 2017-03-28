/*
Name: Top 10 listings views
Data source: 4
Created By: Admin
Last Update At: 2015-10-02T15:30:53.958203+00:00
*/
SELECT v.marketingGroup AS MarketingGroup,
       v.Listing AS Listing,
       v.street_address AS Street_Address,
       v.city AS City,
       v.ZipCode AS ZipCode,
       v.country AS Country,
       v.Views AS Views,
       v.range_rank AS Rank,
       previousweek.range_rank AS PreviousWeekRank,
       IF((previousweek.range_rank - v.range_rank) > 0, concat('+',string(previousweek.range_rank - v.range_rank)), string(previousweek.range_rank - v.range_rank)) AS Status
FROM
  (SELECT marketingGroup,
          Listing,
      
          Street_Address,
          City,
          ZipCode,
          Country,
          RANK() OVER (PARTITION BY dummy
                       ORDER BY Views DESC) AS range_rank,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT 1 dummy,
               MG_HL.marketingGroup_name AS marketingGroup,
               Listing,
              
               Lis_Det.street_address AS Street_Address,
               Lis_Det.city AS City,
               Lis_Det.zip_code AS ZipCode,
               Lis_Det.country AS Country,
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
            WHERE post_page_event = "0" /*Page View Calls*/
              AND DATE(date_time) >= DATE('{{startdate}}')
              AND DATE(date_time) <= DATE('{{enddate}}')
              AND post_prop19 = 'listing' /* Counting Listings */ ) v FULL
         OUTER JOIN EACH
           (SELECT string(id) AS Listing
            FROM [djomniture:devspark.MG_Listings]) AS L ON v.Listing = L.Listing) v
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id
      JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON Listing = Lis_Det.id)
   GROUP BY marketingGroup,
            Listing,
           
            Street_Address,
   City,
            ZipCode,
            Country,
            dummy) v
JOIN
  (SELECT marketingGroup,
          Listing,
          
          Street_Address,
          City,
          ZipCode,
          Country,
          RANK() OVER (PARTITION BY dummy
                       ORDER BY Views DESC) AS range_rank,
                 COUNT(visit_num) AS Views,
                 COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
                                                                                          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT 1 dummy,
               MG_HL.marketingGroup_name AS marketingGroup,
               Listing,
               
               Lis_Det.street_address AS Street_Address,
               Lis_Det.city AS City,
               Lis_Det.zip_code AS ZipCode,
               Lis_Det.country AS Country,
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
            WHERE post_page_event = "0" /*Page View Calls*/
              AND DATE(date_time) >= DATE(DATE_ADD(DATE('{{startdate}}'),-15,"Day"))
              AND DATE(date_time) <= DATE(DATE_ADD(DATE('{{enddate}}'),-8,"Day"))
              AND post_prop19 = 'listing' /* Counting Listings */ ) v FULL
         OUTER JOIN EACH
           (SELECT string(id) AS Listing
            FROM [djomniture:devspark.MG_Listings]) AS L ON v.Listing = L.Listing) v
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id
      JOIN [djomniture:devspark.MG_Listing_Address] AS Lis_Det ON Listing = Lis_Det.id)
   GROUP BY marketingGroup,
            Listing,
           
            Street_Address,
            City,
            ZipCode,
            Country,
            dummy) AS previousweek ON v.Listing = previousweek.Listing
ORDER BY v.Views DESC LIMIT 10
