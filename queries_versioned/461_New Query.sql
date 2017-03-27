/*
Name: New Query
Data source: 4
Created By: Admin
Last Update At: 2016-11-01T14:04:01.636017+00:00
*/
  select 	* FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}') AND DATE(date_time) <= DATE('{{enddate}}')
     AND page_url LIKE '%/search?%'

