/*
Name: Searches from (grouped by city)
Data source: 4
Created By: Admin
Last Update At: 2016-02-16T14:54:29.370461+00:00
*/
SELECT UPPER(geo_country) AS Country,
       geo_region AS Region,
       geo_city AS City,
       COUNT(visit_num) AS Views,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
FROM
  (SELECT geo_country,
          UPPER(geo_region) AS geo_region,
          UPPER(LEFT(geo_city,1))+LOWER(SUBSTRING(geo_city,2,LENGTH(geo_city))) AS geo_city,
          post_visid_high,
          post_visid_low,
          visit_num,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     /*AND REGEXP_MATCH(page_url, '(search\?)(.)*(formatted_address%5D=)({{locationto}})(%2C|&)')) s*/
   AND lower(REPLACE(REGEXP_EXTRACT(PAGE_URL, r'formatted_address%5D=([^&]*)'),'%2C',',')) CONTAINS lower('{{locationto}}')) s /*Using + instead spaces*/ 
JOIN
  (SELECT ctr
   FROM
     (SELECT split('{{locationfrom}}',',') ctr
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")')))
   GROUP BY ctr) AS countries ON countries.ctr = s.geo_country
GROUP BY Country,
         Region,
         City
ORDER BY Views DESC,
         Visits DESC,
         Visitors DESC
