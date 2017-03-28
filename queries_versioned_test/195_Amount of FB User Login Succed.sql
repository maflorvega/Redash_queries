/*
Name: Amount of FB User Login Succed
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T15:37:25.590277+00:00
*/
SELECT COUNT(*) AS FB_Logins,
FROM
  (SELECT post_prop23
    FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "100" and post_prop23 = 'FB User Login Succeed' /* Counting Logins */
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}') )L
