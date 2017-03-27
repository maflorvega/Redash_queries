/*
Name: Number of logins by browser language 2
Data source: 4
Created By: Admin
Last Update At: 2016-03-11T13:14:22.983080+00:00
*/
SELECT post_prop64 AS BrowserLanguage,count(*) as Logins
     
FROM
  (SELECT post_prop64,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop23 = 'User Login Succeed')
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_page_event = "100" )v
group by BrowserLanguage
order by Logins desc
