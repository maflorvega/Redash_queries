/*
Name: Clicks from WSJ CN widget to MG Website
Data source: 4
Created By: Admin
Last Update At: 2016-03-11T17:21:41.539920+00:00
*/
SELECT count(*)
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop10 ='mansion_global_articles_cn_wsj_home'


