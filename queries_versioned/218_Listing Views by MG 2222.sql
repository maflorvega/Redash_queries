/*
Name: Listing Views by MG 2222
Data source: 4
Created By: Admin
Last Update At: 2016-02-16T19:37:35.220269+00:00
*/
SELECT 
       MG_HL.marketingGroup_id AS mgid,page_url,post_prop72,
         post_prop5
       Listing,
       post_visid_high,
       post_visid_low,
       visit_num
FROM
  (SELECT nvl(L.Listing,v.Listing) AS Listing,v.page_url as page_url,v.post_prop72 as post_prop72,v.post_prop5 as post_prop5,
          
          post_visid_high,
          post_visid_low,
          visit_num
   FROM
     (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,page_url,post_prop72,
         post_prop5,
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
JOIN
  (SELECT listing_id,
          marketingGroup_id
   FROM [djomniture:devspark.MG_Hierarchy_Listing]
   ) AS MG_HL ON v.Listing = MG_HL.listing_id

where mgid='96'
