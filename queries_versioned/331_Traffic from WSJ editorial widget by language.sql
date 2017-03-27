/*
Name: Traffic from WSJ editorial widget by language
Data source: 4
Created By: Admin
Last Update At: 2016-03-11T13:36:04.392585+00:00
*/

SELECT REGEXP_EXTRACT(lower(accept_language),r'^([a-z]{2})-.*') AS lAN , accept_language,page_url,
       count(*) AS Clicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_prop10 ='mansion_global_articles_cn_wsj_home'
GROUP BY LAN,accept_language,page_url
ORDER BY Clicks DESC
