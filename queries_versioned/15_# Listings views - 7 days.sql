/*
Name: # Listings views - 7 days
Data source: 4
Created By: Admin
Last Update At: 2015-08-19T13:51:02.293857+00:00
*/
SELECT COUNT(*) AS Views
FROM
  (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,
             "table_id CONTAINS '2015_' AND length(table_id) >= 4 AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) in (month(CURRENT_DATE()),(month(CURRENT_DATE())-1))"))
   WHERE post_page_event = "0" /*pAGE vIEW CALLS*/
     AND date(date_time) >= date(DATE_ADD(CURRENT_TIMESTAMP(), -7, "DAY")) /*Just last 7th days*/
     AND post_prop19 = 'listing' /* Counting just Listings*/ )c
JOIN (SELECT string(id) as id from [djomniture:devspark.MG_All_Listings]) AS L ON C.Listing = L.id /*Join to select just VALID ListingID*/
