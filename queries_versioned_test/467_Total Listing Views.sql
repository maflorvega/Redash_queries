/*
Name: Total Listing Views
Data source: 4
Created By: Admin
Last Update At: 2016-11-08T14:49:00.770872+00:00
*/
SELECT COUNT(*) AS Views,
FROM
  (SELECT post_prop20 AS Listing
   /*Listing properties per listing*/
    FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PageView Calls*/
     AND post_prop19 = 'listing' /* Counting Listings */
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}') )c
/*List of valid listings (active/no active)*/
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
