/*
Name: Users successfully registered by date
Data source: 4
Created By: Admin
Last Update At: 2016-02-11T20:33:45.006668+00:00
*/
SELECT date, COUNT(*) AS Registrations,
FROM (
SELECT string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date,
       post_prop23
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE 
     post_prop23 = "User Registration Succeed" /* Counting user registrations */ and post_page_event = "100"
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}') )L
group by date
