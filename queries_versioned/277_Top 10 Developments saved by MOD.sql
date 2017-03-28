/*
Name: Top 10 Developments saved by MOD
Data source: 4
Created By: Admin
Last Update At: 2016-02-24T19:15:54.138130+00:00
*/

SELECT TOP(nvl(M.DisplayName,post_prop10),10) AS Top10MOD,
       count(*) AS Saved_count
FROM
  (SELECT string(post_prop26) AS developments_id,
          COUNT(DISTINCT string(post_prop26)) DevelopmentsSaved,  post_prop10,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "developmentSaved")
   GROUP BY developments_id,post_prop10) s

JOIN [djomniture:devspark.MODS] M ON s.post_prop10 = MOD
