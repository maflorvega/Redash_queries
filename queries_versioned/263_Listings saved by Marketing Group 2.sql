/*
Name: Listings saved by Marketing Group 2
Data source: 4
Created By: Admin
Last Update At: 2016-02-23T13:50:41.740919+00:00
*/
SELECT date,MG_HL.marketingGroup_name AS MarketingGroup,s.Listing_id, user
FROM
  (SELECT date(date_time) as date,string(post_prop26) AS Listing_id,
          post_prop24 as user
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "listingSaved")
   ) s
LEFT OUTER JOIN
  (SELECT string(id) AS Listing
   FROM [djomniture:devspark.MG_Listings]
  ) AS L ON s.Listing_id = L.Listing
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON s.Listing_id = MG_HL.listing_id


order by s.Listing_id



