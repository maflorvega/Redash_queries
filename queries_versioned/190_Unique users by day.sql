/*
Name: Unique users by day
Data source: 4
Created By: Admin
Last Update At: 2016-02-11T20:57:21.854128+00:00
*/



(SELECT   string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) as date,
 COUNT(DISTINCT date(date_time) + post_prop24) Users,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "100"
     AND (post_prop23 = "User Registration Succeed" /* Counting registrations */
          OR post_prop23 = 'User Login Succeed'
          OR post_prop23='FB User Login Succeed' /* Counting Logins */)
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
 group by date
order by date
   )
