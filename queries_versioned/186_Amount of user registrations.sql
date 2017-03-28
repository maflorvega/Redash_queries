/*
Name: Amount of user registrations
Data source: 4
Created By: Admin
Last Update At: 2016-02-11T20:24:57.778550+00:00
*/
SELECT COUNT(*) AS Registrations,
FROM
  (SELECT post_prop23
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop23 = "User Registration Succeed" /* Counting registrations */
     AND post_page_event = "100"
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}'))L
