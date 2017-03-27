/*
Name: Number of users per browser language
Data source: 4
Created By: Admin
Last Update At: 2016-03-02T13:38:05.895119+00:00
*/
SELECT post_prop64 AS BrowserLanguage,
       count(*) AS Users from
  (SELECT post_prop64, post_prop24
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "100"
     AND (post_prop23 = "User Registration Succeed" /* Counting registrations */
          OR post_prop23 = 'User Login Succeed'
          OR post_prop23='FB User Login Succeed' /* Counting Logins */)
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   GROUP BY post_prop64, post_prop24)
GROUP BY BrowserLanguage
