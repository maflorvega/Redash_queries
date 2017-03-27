/*
Name: Listings saved by  Brokerage
Data source: 4
Created By: Admin
Last Update At: 2016-02-22T20:57:10.243482+00:00
*/
SELECT MG_HL.brokerage_name AS Brokerage,
       count(*) AS Amount,
FROM
  (SELECT string(post_prop26) AS Listing_id,
          COUNT(DISTINCT string(post_prop26)) ListingSaved
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "listingSaved")
   GROUP BY Listing_id) s
LEFT OUTER JOIN
  (SELECT string(id) AS Listing
   FROM [djomniture:devspark.MG_Listings]) AS L ON s.Listing_id = L.Listing
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON s.Listing_id = MG_HL.listing_id
GROUP BY Brokerage
ORDER BY Amount DESC
