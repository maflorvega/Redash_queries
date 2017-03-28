/*
Name: Sub Zero widget per Month
Data source: 4
Created By: Admin
Last Update At: 2015-10-16T16:12:17.117408+00:00
*/

SELECT month(date_time) AS MONTH,
       COUNT(clicks) AS clicks,
FROM
  ( SELECT date_time,
           clicks,
   FROM (
         SELECT count(*) as clicks,                
                
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))
         WHERE page_url LIKE '%article_page_subzero_widget%')
GROUP BY MONTH
ORDER BY 1 DESC
