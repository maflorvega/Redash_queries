/*
Name: Searches for London from Russia
Data source: 4
Created By: Admin
Last Update At: 2016-01-29T15:35:28.578290+00:00
*/
SELECT geo_city as City,
       COUNT(visit_num) AS Views,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
FROM
  (SELECT geo_country,geo_city,
          post_visid_high,
          post_visid_low,
          visit_num,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%search?%'
     AND page_url LIKE '%formatted_address%'
     AND page_url LIKE '%5D=London%'
     and geo_country= 'rus') v
group by City
order by Views desc, Visits desc, Visitors desc

