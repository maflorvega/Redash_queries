/*
Name: Listings Impressions > Views > Leads
Data source: 4
Created By: Admin
Last Update At: 2015-09-03T18:12:49.858418+00:00
*/
SELECT MG_HL.marketingGroup_name AS MarketingGroup,
       MG_HL.brokerage_name AS Brokerage,
       MG_HL.branch_name AS Branch,
       MG_HL.agent_name AS Agent,
       MG_HL.listing_id+'-'+nvl(MG_HL.listing_address,'') AS Listing,
       sum(nvl(integer(HHCI.Impressions),0)) AS Hero_Imp,
       sum(nvl(integer(V_HHC.Views),0)) AS Hero_Views,
       sum(nvl(integer(HFLI.Impressions),0)) AS Featured_Imp,
       sum(nvl(integer(V_HFL.Views),0)) AS Featured_Views,
       sum(nvl(integer(V.Views),0)) AS Views,
       sum(nvl(integer(L.Leads),0)) AS Leads
FROM [djomniture:devspark.MG_Hierarchy_Listing] MG_HL /****   SELECT FOR TOTAL VIEWS, VISITS AND VISITORS      ****/
JOIN EACH
  (SELECT Listing,
          COUNT(*) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
   FROM
     (SELECT NTH(1, SPLIT(post_prop20, '-')) AS Listing,
             post_visid_high,
             post_visid_low,
             visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND post_prop20 != '' /* listing id is not null*/
        AND post_prop19 = 'listing' /* Counting Listings */ ) a
   GROUP BY Listing) V ON MG_HL.listing_id = V.Listing /****   SELECT FOR LEADS      ****/
LEFT OUTER JOIN EACH
  (SELECT count(*) Leads,
                   string(Listing_id) AS Listing_ID
   FROM [djomniture:devspark.MG_Leads]
   WHERE DATE(date) >= DATE('{{startdate}}')
     AND DATE(date) <= DATE('{{enddate}}')
   GROUP BY Listing_ID) AS L ON MG_HL.listing_id = L.Listing_ID /****   SELECT FOR IMPRESSIONS:home_hero_carousel      ****/
LEFT OUTER JOIN EACH
  (SELECT listing_id,
          Impressions
   FROM
     ( SELECT DESC,HHC.listing_id AS listing_id,
                   count(*) Impressions
      FROM
        ( SELECT SPLIT(post_prop69, ',') AS listing_id,
                 'home_hero_carousel' AS DESC
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE post_page_event = "0" /*Page View Calls*/
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}')
           AND post_prop1 = 'home' /*Impressions Made in Home*/
           AND post_prop69 != '' /*impressions_home_hero_carousel*/
           AND post_prop70 != '' /*impressions_home_featured_developments*/
           AND post_prop71 != '' /*impressions_home_featured_listings*/ ) HHC
      GROUP BY DESC,listing_id )) HHCI ON MG_HL.listing_id = HHCI.listing_id /****   SELECT FOR IMPRESSIONS:home_featured_listings      ****/
LEFT OUTER JOIN EACH
  ( SELECT HFL.listing_id AS listing_id,
           count(*) Impressions
   FROM
     ( SELECT SPLIT(post_prop71, ',') AS listing_id,
              'home_featured_listings' AS DESC
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" /*Page View Calls*/
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND post_prop1 = 'home' /*Impressions Made in Home*/
        AND post_prop69 != '' /*impressions_home_hero_carousel*/
        AND post_prop70 != '' /*impressions_home_featured_developments*/
        AND post_prop71 != '' /*impressions_home_featured_listings*/ ) HFL
   GROUP BY DESC,listing_id ) HFLI ON MG_HL.listing_id = HFLI.listing_id /****   SELECT FOR VIEWS:home_featured_listing      ****/
LEFT OUTER JOIN EACH
  (SELECT Listing,
          COUNT(*) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
   FROM
     (SELECT NTH(1, SPLIT(post_prop20, '-')) AS Listing,
             post_prop10,
             post_visid_high,
             post_visid_low,
             visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND post_prop20 != '' /* listing id is not null*/
        AND post_prop19 = 'listing' /* Counting Listings */ ) a
   JOIN [djomniture:devspark.MODS] M ON post_prop10 = MOD
   WHERE MOD IN ('home_featured_listing')
   GROUP BY Listing) V_HFL ON MG_HL.listing_id = V_HFL.Listing /****   SELECT FOR VIEWS:home_hero      ****/
LEFT OUTER JOIN EACH
  (SELECT Listing,
          COUNT(*) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
   FROM
     (SELECT NTH(1, SPLIT(post_prop20, '-')) AS Listing,
             post_prop10,
             post_visid_high,
             post_visid_low,
             visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND {{mgid}} != 0
        AND post_prop20 != '' /* listing id is not null*/
        AND post_prop19 = 'listing' /* Counting Listings */ ) a
   JOIN [djomniture:devspark.MODS] M ON post_prop10 = MOD
   WHERE MOD IN ('home_hero')
   GROUP BY Listing) V_HHC ON MG_HL.listing_id = V_HHC.Listing
WHERE MG_HL.marketingGroup_id = '{{mgid}}'
GROUP BY ROLLUP (MarketingGroup,
                 Brokerage,
                 Branch,
                 Agent,
                 Listing)
ORDER BY MarketingGroup,
         Brokerage,
         Branch,
         Agent,
         Listing
