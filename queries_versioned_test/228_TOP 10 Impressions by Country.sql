/*
Name: TOP 10 Impressions by Country
Data source: 4
Created By: Admin
Last Update At: 2016-02-17T18:02:38.966273+00:00
*/
SELECT 
       TOP(GL.Country,10) AS Top10Country,
       count(*) AS Impressions
FROM
  (SELECT post_prop34,
          upper(geo_country) AS Country,
          
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   AND date(date_time) >= date('2016-05-04')
   and post_page_event='100'
     AND post_prop33 = 'MG_HomeHero_Impressions') v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.Country





