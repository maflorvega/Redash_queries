/*
Name: TestQ with some states
Data source: 4
Created By: Admin
Last Update At: 2016-03-23T18:25:05.761956+00:00
*/
SELECT MG_LA.street_address AS Street_Address,
       MG_LA.city AS City,
       MG_LA.zip_code AS Zip_code,
       MG_LA_US.Abbreviation AS STATE,
       MG_LA.country AS Country,
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
left JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id
LEFT JOIN [djomniture:devspark.MG_Listing_Address] AS MG_LA ON v.Listing = MG_LA.id
LEFT JOIN [djomniture:devspark.usa_stated_limited] AS MG_LA_US ON  (MG_LA.zip_code = MG_LA_US.Zip_code
                                                              AND MG_LA.city = MG_LA_US.City)
GROUP BY URL,
         Agent,
         Street_Address,
         City,
         Zip_code,
         STATE,
         Country
ORDER BY Clicks DESC
