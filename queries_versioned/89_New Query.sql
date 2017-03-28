/*
Name: New Query
Data source: 4
Created By: Admin
Last Update At: 2015-10-16T17:51:16.458193+00:00
*/

SELECT STRFTIME_UTC_USEC(date_time,
                  "%Y-%m-%d") AS DAY,
       
       count(*) AS clicks,

FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
WHERE page_url LIKE '%article_page_subzero_widget%'
GROUP BY DAY
ORDER BY CLICKS


