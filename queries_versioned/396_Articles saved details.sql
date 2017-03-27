/*
Name: Articles saved details
Data source: 4
Created By: Admin
Last Update At: 2016-04-14T18:24:25.906105+00:00
*/
SELECT v.post_prop20 AS Article,
       a.title_long AS Title,
       a.,
       a.locale,
FROM
  (SELECT post_prop20,
          page_url,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "articleSaved")
   GROUP BY post_prop20,
            page_url) v
LEFT  JOIN [djomniture:devspark.MG_Articles] AS a ON v.post_prop20=a.id
ORDER BY Title ASC
