/*
Name: Amount of internal clicks 3
Data source: 4
Created By: Admin
Last Update At: 2016-03-04T13:36:25.356608+00:00
*/

SELECT count(*)
FROM
  (SELECT page_url,
          post_visid_high,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop10= 'berkshire_hathaway_widget'
     AND post_prop72 = ''
     AND geo_city != 'tandil'
     AND post_visid_high='3084409357591191069'
     AND post_page_event='0'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2016-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}')
   GROUP BY page_url,
            post_visid_high)
