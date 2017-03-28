/*
Name: Searches for London from South East Asia by country
Data source: 4
Created By: Admin
Last Update At: 2016-01-29T15:53:22.435605+00:00
*/

SELECT R.country_name AS Country,
       geo_city AS City,
       COUNT(visit_num) AS Views,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
FROM
  (SELECT geo_country,
          geo_city,
          post_visid_high,
          post_visid_low,
          visit_num,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%search?%'
     AND page_url LIKE '%formatted_address%'
     AND page_url LIKE '%5D=London%') v
JOIN [djomniture:devspark.Regions] R ON v.geo_country = R.country_code
WHERE R.region='south_east_asia'
  AND v.geo_country IN
    (SELECT country_code
     FROM djomniture:devspark.Regions)
GROUP BY Country,City,
         
ORDER BY Views DESC,
         Visits DESC,
         Visitors DESC
