/*
Name: Successfully logins by date
Data source: 4
Created By: Admin
Last Update At: 2016-02-18T17:45:25.277934+00:00
*/
SELECT string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS Date,
       integer(count(*)) AS Logins
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE (post_prop23 = 'User Login Succeed')
  AND post_page_event = "100"
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
GROUP BY Date
