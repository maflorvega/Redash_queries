/*
Name: Amount of searches saved per day
Data source: 4
Created By: Admin
Last Update At: 2016-02-29T20:49:02.601179+00:00
*/
SELECT
       string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date,
       count(*) AS Save_count
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE date(date_time) > date('2016-02-02')
  AND post_page_event = "100"
 AND DATE(date_time) >= DATE('{{startdate}}')
AND DATE(date_time) <= DATE('{{enddate}}')
  AND (post_prop25 = "searchSaved")
GROUP BY date
