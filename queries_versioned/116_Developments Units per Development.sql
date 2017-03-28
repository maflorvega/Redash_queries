/*
Name: Developments Units per Development
Data source: 4
Created By: Admin
Last Update At: 2015-11-25T19:37:36.398428+00:00
*/
SELECT dev.development_id AS development_id,
       dev.unit_id AS unit_id,
       dev.unit_name AS unit_name,
       dev.ListingId as ListingId,
       dev.address AS address,
       lis.Views AS Views,
       lis.Visits AS Visits,
       lis.Visitors AS Visitors,
       lis.Leads AS Leads,
       lis.ExternalClicks AS ExternalClicks
FROM
  ( SELECT development_id,
           unit_id,
           unit_name,
           l.id AS ListingId,
           l.address AS address,
   FROM [djomniture:devspark.MG_Listing_Address] l
   JOIN
     (SELECT string(listing_id) AS listing_id,
             development_id,
             unit_name,
             unit_id
      FROM [djomniture:devspark.MG_Development_Units]) du ON l.id = listing_id
   WHERE string(development_id) = '{{devid}}') dev
JOIN
  ( SELECT Listing,
           Views,
           Visits,
           Visitors,
           nvl(integer(Leads),integer(0)) AS Leads,
           nvl(integer(CLICKS.ExternalClicks),integer(0)) AS ExternalClicks
   FROM
     (SELECT Listing,
             COUNT(visit_num) AS Views,
             COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
             COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
      FROM
        (SELECT Listing,
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
               FROM [djomniture:devspark.MG_Listings]
               where DATE(created_at) <= DATE('{{enddate}}')) AS L ON v.Listing = L.Listing ) v )
      GROUP BY Listing ) v /*OUTER JOIN TO SELECT LEADS OR EMAILS SENT BY MGID*/
   LEFT OUTER JOIN
     (SELECT count(Lead) AS Leads,
             Listing_id
      FROM
        (SELECT 1 AS Lead,
                l.Listing_id
         FROM [djomniture:devspark.MG_Leads] l
         WHERE (DATE(date) >= DATE('{{startdate}}')
                AND DATE(date) <= DATE('{{enddate}}'))) l
      GROUP BY Listing_id) AS LEADS ON v.Listing = LEADS.Listing_id /*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY MGID*/
   LEFT OUTER JOIN
     (SELECT COUNT(CLICK) AS ExternalClicks,
             Listing_id
      FROM
        (SELECT 1 AS Click,
                FIRST(SPLIT(post_prop20, '-')) AS Listing_id
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE post_prop68='ExternalClick'
        and date_time >= date('2016-11-18')
        and post_prop1='development'
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}'))
      GROUP BY Listing_id) AS CLICKS ON v.Listing = CLICKS.Listing_id)lis ON dev.ListingId = lis.Listing
ORDER BY Views DESC
