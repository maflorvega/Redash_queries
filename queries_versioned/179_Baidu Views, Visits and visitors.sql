/*
Name: Baidu Views, Visits and visitors
Data source: 4
Created By: Admin
Last Update At: 2016-02-10T20:36:24.019817+00:00
*/
SELECT string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date,
       COUNT(visit_num) AS Views,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
FROM
  (SELECT date_time,
          visit_num,
          post_visid_high,
          post_visid_low,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE LOWER(post_prop19)='home'
     AND post_prop10 LIKE '%djcm_pdadcn_baidu%'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND DATE('{{startdate}}') >= DATE('2015-02-02')
     AND post_page_event = "0" /*Page View Calls*/ )
GROUP BY date
