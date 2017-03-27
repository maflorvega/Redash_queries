/*
Name: Search saved parameters
Data source: 4
Created By: Admin
Last Update At: 2016-02-29T18:40:18.089696+00:00
*/
SELECT sum(CASE WHEN page_url LIKE '%max_price%' THEN Searches ELSE integer('0') END) AS max_price,
       sum(CASE WHEN page_url LIKE '%min_price%' THEN Searches ELSE integer('0') END) AS min_price,
sum(CASE WHEN page_url LIKE '%min_bathrooms%' THEN Searches ELSE integer('0') END) AS min_bathrooms,
sum(CASE WHEN page_url LIKE '%min_bedrooms%' THEN Searches ELSE integer('0') END) AS min_bedrooms,
sum(CASE WHEN page_url LIKE '%lifestyles%' THEN Searches ELSE integer('0') END) AS lifestyles

FROM(


select page_url,  integer(count(*)) AS Searches
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE date(date_time) > date('2016-02-02')
  AND post_page_event='100'
  AND post_prop25 ='searchSaved'
  AND DATE(date_time) >= DATE('{{startdate}}')
AND DATE(date_time) <= DATE('{{enddate}}')
group by page_url)
