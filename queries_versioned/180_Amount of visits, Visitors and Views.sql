/*
Name: Amount of visits, Visitors and Views
Data source: 4
Created By: Admin
Last Update At: 2016-02-11T15:05:18.062968+00:00
*/

SELECT GL.Country AS Country,
       v.Views as Views,
       v.Visits as Visits,
       v.Visitors as Visitors,
FROM
  (SELECT UPPER(geo_country) AS geo_country,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE LOWER(post_prop19)='home'
     AND post_prop10 LIKE '%djcm_pdadcn_baidu%'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   AND DATE('{{startdate}}') >= DATE('2015-02-02')
     AND post_page_event = "0" /*Page View Calls*/
   GROUP BY geo_country
   ORDER BY Views DESC, Visits DESC, Visitors DESC)v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.geo_country
