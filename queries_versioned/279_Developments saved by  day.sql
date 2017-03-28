/*
Name: Developments saved by  day
Data source: 4
Created By: Admin
Last Update At: 2016-02-24T20:20:10.713876+00:00
*/

  (SELECT string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date,
          string(post_prop26) AS dev,
          COUNT(DISTINCT string(post_prop26) + string(DAY(date_time))+string(YEAR(date_time))+ string(MONTH(date_time))) save,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "100"
     AND (post_prop25 = "developmentSaved")
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   GROUP BY date,dev
   ORDER BY date asc)

