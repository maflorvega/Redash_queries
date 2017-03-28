/*
Name: # Listings views - Current Month
Data source: 4
Created By: Admin
Last Update At: 2015-08-18T20:31:46.002157+00:00
*/
SELECT COUNT(*) AS Views
FROM
  (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "length(table_id) >= 4
                     AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
                     AND month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = month(CURRENT_DATE())"))
   WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
     AND post_prop19 = 'listing' /* Counting Listings*/ ) C
JOIN (SELECT string(id) as id from [djomniture:devspark.MG_All_Listings]) AS L ON C.Listing = L.id /*Join to select just VALID ListingID*/
