/*
Name: Total Development Views
Data source: 4
Created By: Admin
Last Update At: 2016-11-08T14:52:04.651141+00:00
*/
SELECT count(*) AS views
FROM
  (SELECT post_prop20 AS Development,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*Page View Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop19 = 'development' /* Counting development */ ) v
JOIN
  (SELECT string(id) AS did
   FROM[djomniture:devspark.MG_Developments]) AS D ON D.did=v.Development
