/*
Name: Old external clicks
Data source: 4
Created By: Admin
Last Update At: 2016-03-15T19:35:30.743768+00:00
*/

SELECT date(date_time) AS date
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
  AND post_prop72 != ''
  AND post_prop72 != '__'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) >= date('2015-10-10')
  AND post_prop75=''
  AND post_prop72 NOT LIKE '%/listings/%'
  AND DATE(date_time) <= DATE('{{enddate}}')

ORDER BY date
