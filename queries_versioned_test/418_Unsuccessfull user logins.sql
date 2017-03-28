/*
Name: Unsuccessfull user logins
Data source: 4
Created By: Admin
Last Update At: 2016-08-11T14:19:33.364410+00:00
*/
SELECT sum(CASE WHEN DATE(date_time) >= DATE('2016-09-01')
           AND REGEXP_EXTRACT(post_prop28,r'(.*)\|') !='FE' THEN integer('1') WHEN DATE(date_time) < DATE('2016-09-01')THEN integer('1') ELSE integer('0') END) AS Registrations,
FROM
  (SELECT post_prop23,
          post_prop28,
          date_time
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop23 = "User Login Failed" /* Counting registrations */
     AND post_page_event = "100"
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}'))L
