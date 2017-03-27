/*
Name: Joche Country
Data source: 4
Created By: Admin
Last Update At: 2016-03-04T17:39:28.945973+00:00
*/
SELECT UPPER(geo_country) AS geo_country,count(*) AS Clicks
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop10= 'berkshire_hathaway_widget'
     AND post_prop72 = ''
     /*AND geo_city != 'tandil'*/
     AND post_page_event='0' /*added by joche*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2016-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}')
GROUP BY geo_country

