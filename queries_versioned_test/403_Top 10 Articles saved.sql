/*
Name: Top 10 Articles saved
Data source: 4
Created By: Admin
Last Update At: 2016-05-13T18:14:31.589580+00:00
*/
select a.title_long AS Title,
       v.post_prop26 AS Article_id,
       CASE 
              WHEN (post_prop64='Spanish') THEN 'http://www.mansionglobal.com/es/articles/'+post_prop26
              WHEN (post_prop64='Chinese') THEN 'http://www.mansionglobal.com/cn/articles/'+post_prop26
              WHEN (post_prop64='English') THEN 'http://www.mansionglobal.com/articles/'+post_prop26
       END AS Url,

       sum(Saved) as Times_Saved
FROM 
(SELECT post_prop26,post_prop64,
        COUNT(DISTINCT post_prop24 + "-" + post_prop26 + post_prop64) Saved,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND DATE(date_time) > DATE('2016-04-18')
     AND (post_prop25 = "articleSaved")
   GROUP BY post_prop26,post_prop64) v 
LEFT  JOIN [djomniture:devspark.MG_Articles] AS a ON v.post_prop26=a.id
group by Title, Article_id,Url
order by Times_Saved desc
