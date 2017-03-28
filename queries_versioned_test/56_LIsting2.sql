/*
Name: LIsting2
Data source: 4
Created By: Admin
Last Update At: 2015-09-22T18:42:57.256159+00:00
*/
SELECT COUNT(*) as Views,
FROM
  (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing /*Listing properties per listing*/
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE post_page_event = "0" /*PageView Calls*/
     AND post_prop19 = 'listing' /* Counting Listings */
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}'))c /*List of valid listings (active/no active)*/
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
