/*
Name: Amount of articles saved
Data source: 4
Created By: Admin
Last Update At: 2016-05-13T18:10:33.631362+00:00
*/

SELECT COUNT(*) ArticleSaved
FROM
  (SELECT post_prop26
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND DATE(date_time) > DATE('2016-04-18')
     AND (post_prop25 = "articleSaved")
   GROUP BY post_prop26)
