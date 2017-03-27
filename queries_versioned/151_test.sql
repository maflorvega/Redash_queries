/*
Name: test
Data source: 4
Created By: Admin
Last Update At: 2016-01-28T15:14:15.911356+00:00
*/
SELECT Listing,
       post_prop10,
       COUNT(visit_num) AS Views,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
       from(
              (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing, post_visid_high, post_visid_low, visit_num, post_prop10,post_prop19
               FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
               WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
                 AND DATE(date_time) >= DATE('{{startdate}}')
                 AND DATE(date_time) <= DATE('{{enddate}}')
                 AND post_prop19 = 'listing' /* Counting Listings */ ))
GROUP BY Listing,
         post_prop10,
         post_prop19,
         post_visid_high,
         post_visid_low,
         visit_num
