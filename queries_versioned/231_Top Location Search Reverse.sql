/*
Name: Top Location Search Reverse
Data source: 4
Created By: Admin
Last Update At: 2016-02-17T20:05:15.908081+00:00
*/
SELECT REPLACE(REPLACE(REGEXP_EXTRACT(PAGE_URL, r'formatted_address%5D=([^&]*)'),'+',' '),'%2C',',') AS formatted_address,
       count(*) AS Amount
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event = "0" /* Pageview Calls*/
  AND page_url LIKE '%formatted_address%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND page_url LIKE '%search?%'
  AND page_url LIKE '%formatted_address%'
  AND REGEXP_MATCH(page_url, '(search\?)(.)*(formatted_address%5D=)({{locationto}})(%2C|&)')
GROUP BY formatted_address
ORDER BY Amount DESC LIMIT 15

