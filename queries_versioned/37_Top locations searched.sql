/*
Name: Top locations searched
Data source: 4
Created By: Admin
Last Update At: 2015-08-28T13:42:55.178786+00:00
*/
SELECT REPLACE(REPLACE(REGEXP_EXTRACT(PAGE_URL, r'formatted_address%5D=([^&]*)'),'+',' '),'%2C',',') AS formatted_address,
       count(*) AS Amount
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event = "0" /* Pageview Calls*/
  AND page_url LIKE '%formatted_address%'
  AND page_url LIKE '%/search%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
GROUP BY formatted_address
ORDER BY Amount DESC
