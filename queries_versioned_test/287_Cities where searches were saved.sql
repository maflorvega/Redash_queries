/*
Name: Cities where searches were saved
Data source: 4
Created By: Admin
Last Update At: 2016-02-29T19:13:33.049735+00:00
*/
SELECT geo_city,
       count(*) AS Save_count
FROM
  (SELECT geo_city,
          post_prop26,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE date(date_time) > date('2016-02-02')
     AND post_page_event='100'
     AND post_prop25 ='searchSaved'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   GROUP BY geo_city,
            post_prop26)
GROUP BY geo_city
ORDER BY Save_count DESC
