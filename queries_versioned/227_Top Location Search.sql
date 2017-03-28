/*
Name: Top Location Search
Data source: 4
Created By: Admin
Last Update At: 2016-02-17T17:50:32.314456+00:00
*/
/*select formatted_address,sum(amount_of_searches) from (*/
SELECT REPLACE(REPLACE(REGEXP_EXTRACT(PAGE_URL, r'formatted_address%5D=([^&]*)'),'+',' '),'%2C',',') AS formatted_address,
       count(*) AS Amount_of_Searches
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event = "0" /* Pageview Calls*/
  AND page_url LIKE '%formatted_address%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND page_url LIKE '%search?%'
  AND page_url LIKE '%formatted_address%'
  AND (geo_country= '{{locationfrom}}'
       OR geo_city= REPLACE(lower('{{locationfromcity}}'),'+',' '))
GROUP BY formatted_address
ORDER BY Amount_of_Searches DESC /*) group by formatted_address*/
