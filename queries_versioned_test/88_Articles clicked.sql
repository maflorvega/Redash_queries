/*
Name: Articles clicked
Data source: 4
Created By: Admin
Last Update At: 2015-10-16T17:19:36.167643+00:00
*/
SELECT replace(replace(REGEXP_EXTRACT(page_url, r'&source_url=(.*)&target_url='),'http%3A%2F%2Fwww.mansionglobal.com%2Farticles%2F',''),'%',' ') AS ARTICLE,
       count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%article_page_subzero_widget%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-10-10')
  AND DATE(date_time) <= DATE('{{enddate}}')
GROUP BY article
ORDER BY Clicks DESC
