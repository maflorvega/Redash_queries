/*
Name: Amount of visits, Visitors and Views +
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T15:08:40.326706+00:00
*/

SELECT page_url, Visitors,
FROM
  (SELECT page_url, COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE LOWER(post_prop19)='home'
     AND post_prop10 LIKE '%djcm_pdadcn_baidu%'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND DATE('{{startdate}}') >= DATE('2015-02-02')
     AND post_page_event = "0" /*Page View Calls*/
   GROUP BY page_url
   ORDER BY Visitors DESC)
