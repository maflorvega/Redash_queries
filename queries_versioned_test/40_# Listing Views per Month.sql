/*
Name: # Listing Views per Month
Data source: 4
Created By: Admin
Last Update At: 2015-09-01T18:06:01.914697+00:00
*/

SELECT year(date_time) AS YEAR,
       month(date_time) AS MONTH,
       COUNT(visit_num) AS Views,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
FROM
  ( SELECT date_time,
           post_visid_high,
           post_visid_low,
           visit_num
   FROM (/*STATS SAVE BY OMNITURE*/
         SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
                date_time,
                post_visid_high,
                post_visid_low,
                visit_num
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"length(table_id) >= 4"))
         WHERE post_page_event = "0" /* PAGE VIEW CALLS*/
           AND post_prop19 = 'listing' /* COUNT JUST LISTINGS */ ) v /*INCLUDE JUST VALID LISTING ID*/
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id)
GROUP BY YEAR,MONTH
ORDER BY 1,2 DESC
LIMIT 10
