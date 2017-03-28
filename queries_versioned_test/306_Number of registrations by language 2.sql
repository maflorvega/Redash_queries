/*
Name: Number of registrations by language 2
Data source: 4
Created By: Admin
Last Update At: 2016-03-02T19:18:40.965174+00:00
*/
SELECT post_prop64 as Languaje,
       Registrations from
  (SELECT post_prop64, COUNT(*) AS Registrations,
   FROM
     (SELECT post_prop64, post_prop23
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop23 = "User Registration Succeed" /* Counting user registrations */ and post_page_event = "100"
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}'))L
   GROUP BY post_prop64) v
order by Registrations desc
