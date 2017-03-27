/*
Name: ddddd
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T15:22:11.338906+00:00
*/
SELECT post_page_event,date, post_prop23,post_prop24,post_prop25,post_prop26
FROM
  (SELECT post_page_event,Date(date_time) as date,post_prop23,post_prop24,post_prop25,post_prop26
    FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE 1=1 /*post_page_event = "0" /*PageView Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}') and post_page_event = "100" )L

