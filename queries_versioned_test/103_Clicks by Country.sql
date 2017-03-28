/*
Name: Clicks by Country
Data source: 4
Created By: Admin
Last Update At: 2015-11-11T18:38:23.351037+00:00
*/
SELECT TOP(geo_country,15) AS Country,
       COUNT (*) AS COUNT,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE (post_prop10 = 'mansion_global_sponsor_unit_single_cn_wsj_home')
  AND (post_prop72 IS NULL
       OR post_prop72 = ''
       OR post_prop72 = '__'/*IT  IS NOT AN EXTERNAL REDIRECTION*/)
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
