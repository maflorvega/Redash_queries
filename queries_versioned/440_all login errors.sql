/*
Name: all login errors
Data source: 4
Created By: Admin
Last Update At: 2016-09-08T17:29:15.125080+00:00
*/
SELECT post_prop28,
          nvl(REGEXP_EXTRACT(post_prop28,r'^.*\|(.*)$'),'Error Not Defined') as Error,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop23 = 'User Login Failed')
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
    AND DATE(date_time) >= DATE('2016-07-26')
     AND post_page_event = "100"
