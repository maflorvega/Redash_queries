/*
Name: TestQ limitited
Data source: 4
Created By: Admin
Last Update At: 2016-03-23T18:09:03.268317+00:00
*/
SELECT MG_HL.street_address AS Street_Address,
       MG_HL.city AS City,
       MG_HL.zip_code AS Zip_code,
       MG_LA.state AS STATE,
       MG_HL.country AS Country,
       v.page_url AS URL,
       MG_HL.agent_name AS Agent,
       count(*) AS Clicks,
FROM
  (SELECT page_url,
          FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop10= 'berkshire_hathaway_widget'
     AND post_prop72 = ''
     AND post_page_event='0'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2016-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}'))v
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id
LEFT JOIN [djomniture:devspark.MG_Listing_Address_UNA2] AS MG_LA ON v.Listing = MG_LA.Listing_id
GROUP BY URL,
         Agent,
         Street_Address,
         City,
         Zip_code,
         STATE,
         Country
ORDER BY Clicks DESC
