/*
Name: Developments saved
Data source: 4
Created By: Admin
Last Update At: 2016-02-24T18:48:52.708692+00:00
*/

SELECT COUNT(*) DevelopmentsSaved,
FROM
  (SELECT string(post_prop26) AS Developments,
          COUNT(DISTINCT string(post_prop26)) save,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "developmentSaved")
   GROUP BY Developments)
