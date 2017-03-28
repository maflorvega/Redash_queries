/*
Name: Number of times saved by Language
Data source: 4
Created By: Admin
Last Update At: 2016-05-13T18:16:14.594548+00:00
*/
SELECT LANGUAGE,
       count(*) Times_Saved,
FROM
  (SELECT post_prop64 AS LANGUAGE,
          post_prop26,
          post_prop24
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND DATE(date_time) > DATE('2016-04-18')
     AND (post_prop25 = "articleSaved")
   GROUP BY post_prop26,
            post_prop24,
            LANGUAGE) v
LEFT  JOIN [djomniture:devspark.MG_Articles] AS a ON v.post_prop26=a.id
GROUP BY LANGUAGE
ORDER BY Times_Saved DESC
