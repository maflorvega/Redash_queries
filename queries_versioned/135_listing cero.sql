/*
Name: listing cero
Data source: 4
Created By: Admin
Last Update At: 2016-01-12T13:29:08.493849+00:00
*/
SELECT Listing,post_prop10,
       COUNT(visit_num) AS Views,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
       FROM(
              (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing, post_visid_high, post_visid_low, visit_num,post_prop10,
               FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
               WHERE post_page_event = "0" /*Page View calls*/
                 AND DATE(date_time) >= DATE('{{startdate}}')
                 AND DATE(date_time) <= DATE('{{enddate}}')
                 AND post_prop19 = 'listing' /* Counting Listings */ ) )
WHERE Listing ='123623'
GROUP BY Listing,post_prop10
