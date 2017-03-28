/*
Name: Impression MG with links
Data source: 4
Created By: Admin
Last Update At: 2015-09-07T19:55:23.035233+00:00
*/
SELECT 
   MGID , MarketingGroup ,
  sum(Hero_Imp) as Hero_Imp,
  sum(Hero_Views) as Hero_Views,
  sum(Featured_Imp) as Featured_Imp,
  sum(Featured_Views) as Featured_Views,
  sum(Views) as Views,
  sum(Leads) as Leads
FROM (
  SELECT 
    MG_HL.marketingGroup_name AS MarketingGroup,V.Listing,V.Views,V.Visits,V.Visitors,
    MG_HL.marketingGroup_id AS MGID,
    nvl(integer(HHCI.Impressions),0) as Hero_Imp,
    nvl(integer(V_HHC.Views),0) as Hero_Views,
    nvl(integer(HFLI.Impressions),0) as Featured_Imp,
    nvl(integer(V_HFL.Views),0) as Featured_Views,
    nvl(integer(V.Views),0) as Views,
    nvl(integer(L.Leads),0) as Leads
  FROM [djomniture:devspark.MG_Hierarchy_Listing] MG_HL

  /****   SELECT FOR TOTAL VIEWS, VISITS AND VISITORS      ****/
  LEFT OUTER JOIN EACH 
    (SELECT Listing,
              COUNT(*) AS Views,
              COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
              COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
        FROM
          (SELECT NTH(1, SPLIT(post_prop20, '-')) AS Listing,
                  post_visid_high,post_visid_low, visit_num
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
           WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
             AND DATE(date_time) >= DATE('{{startdate}}')
             AND DATE(date_time) <= DATE('{{enddate}}')
             AND post_prop20 != '' /* listing id is not null*/
             AND post_prop19 = 'listing' /* Counting Listings */ ) a
      GROUP BY Listing
  ) V ON MG_HL.listing_id = V.Listing

  /****   SELECT FOR LEADS      ****/
  LEFT OUTER JOIN EACH 
    (SELECT count(*) Leads, string(Listing_id) AS Listing_ID
     FROM [djomniture:devspark.MG_Leads]
     WHERE DATE(date) >= DATE('{{startdate}}')
     AND DATE(date) <= DATE('{{enddate}}')
     GROUP BY Listing_ID) AS L ON MG_HL.listing_id = L.Listing_ID

  /****   SELECT FOR IMPRESSIONS:home_hero_carousel      ****/
  LEFT OUTER JOIN EACH 
  (SELECT listing_id,Impressions
    FROM (
      SELECT desc,HHC.listing_id as listing_id, count(*) Impressions
      FROM (
        SELECT SPLIT(post_prop69, ',') as listing_id,'home_hero_carousel' as desc
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
        WHERE post_page_event = "0" /*Page View Calls*/
          and DATE(date_time) >= DATE('{{startdate}}')
          and DATE(date_time) <= DATE('{{enddate}}')   
          and post_prop1 = 'home' /*Impressions Made in Home*/
          and post_prop69 != '' /*impressions_home_hero_carousel*/
          and post_prop70 != '' /*impressions_home_featured_developments*/
          and post_prop71 != '' /*impressions_home_featured_listings*/
        ) HHC
      group by desc,listing_id
    )    
  ) HHCI
  ON MG_HL.listing_id = HHCI.listing_id

  /****   SELECT FOR IMPRESSIONS:home_featured_listings      ****/
  LEFT OUTER JOIN EACH 
  (
      SELECT HFL.listing_id as listing_id, count(*) Impressions
      FROM (
        SELECT SPLIT(post_prop71, ',') as listing_id,'home_featured_listings' as desc
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
        WHERE post_page_event = "0" /*Page View Calls*/
          and DATE(date_time) >= DATE('{{startdate}}')
          and DATE(date_time) <= DATE('{{enddate}}')   
          and post_prop1 = 'home' /*Impressions Made in Home*/
          and post_prop69 != '' /*impressions_home_hero_carousel*/
          and post_prop70 != '' /*impressions_home_featured_developments*/
          and post_prop71 != '' /*impressions_home_featured_listings*/
        ) HFL
      group by desc,listing_id
    ) HFLI
  ON MG_HL.listing_id = HFLI.listing_id  

  /****   SELECT FOR VIEWS:home_featured_listing      ****/
  LEFT OUTER JOIN EACH 
  (SELECT Listing,
          COUNT(*) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
        FROM
          (SELECT NTH(1, SPLIT(post_prop20, '-')) AS Listing,
                  prop10,post_visid_high,post_visid_low,visit_num
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
           WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
             AND DATE(date_time) >= DATE('{{startdate}}')
             AND DATE(date_time) <= DATE('{{enddate}}')   
             AND post_prop20 != '' /* listing id is not null*/
             AND post_prop19 = 'listing' /* Counting Listings */ ) a
        JOIN [djomniture:devspark.MODS] M ON prop10 = MOD 
        WHERE mod IN ('home_featured_listing')
      GROUP BY Listing
  ) V_HFL ON MG_HL.listing_id = V_HFL.Listing

  /****   SELECT FOR VIEWS:home_hero      ****/
  LEFT OUTER JOIN EACH 
  (SELECT Listing,
          COUNT(*) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
        FROM
          (SELECT NTH(1, SPLIT(post_prop20, '-')) AS Listing,
                  prop10,post_visid_high,post_visid_low,visit_num
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
           WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
             AND DATE(date_time) >= DATE('{{startdate}}')
             AND DATE(date_time) <= DATE('{{enddate}}')   
             AND post_prop20 != '' /* listing id is not null*/
             AND post_prop19 = 'listing' /* Counting Listings */ ) a
        JOIN [djomniture:devspark.MODS] M ON prop10 = MOD 
        WHERE mod IN ('home_hero')          
      GROUP BY Listing
  ) V_HHC ON MG_HL.listing_id = V_HHC.Listing

)
group by MarketingGroup,MGID
