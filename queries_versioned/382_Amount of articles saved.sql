/*
Name: Amount of articles saved
Data source: 4
Created By: Admin
Last Update At: 2016-04-06T12:52:22.244504+00:00
*/

SELECT COUNT(*) ArticleSaved,
FROM
  (SELECT string(post_prop26) as Article,
          COUNT(DISTINCT string(post_prop26)) save,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "articleSaved")
  group by Article)



