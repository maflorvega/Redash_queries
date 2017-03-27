/*
Name: Number of registrations by language
Data source: 4
Created By: Admin
Last Update At: 2016-03-01T20:33:28.064750+00:00
*/
SELECT post_prop64 as BrowserLanguage,count(*) as Registrations,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop23 = "User Registration Succeed" /* Counting user registrations */ and post_page_event = "100"
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
  GROUP BY BrowserLanguage
order by Registrations desc
