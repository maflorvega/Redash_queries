/*
Name: UserLogins Count by date
Data source: 4
Created By: Admin
Last Update At: 2016-02-11T20:14:31.298696+00:00
*/
SELECT date, COUNT(*) AS Logins,
FROM (
SELECT string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date,
       post_prop23
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE 1=1 /*post_page_event = "0" /*PageView Calls*/
     AND post_prop23 = 'User Login Succeed' /* Counting Logins */
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}') )L
group by date
