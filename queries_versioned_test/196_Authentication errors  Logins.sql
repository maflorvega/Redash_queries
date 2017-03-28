/*
Name: Authentication errors  Logins
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T15:40:42.245791+00:00
*/
SELECT COUNT(*) AS Logins,
FROM
  (SELECT post_prop23
    FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "100"
     AND post_prop23 = 'User Login Failed' /* Counting Logins */
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}') )L
