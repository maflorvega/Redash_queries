/*
Name: Developments saved by Country
Data source: 4
Created By: Admin
Last Update At: 2016-02-25T18:38:09.230805+00:00
*/
SELECT Development,
       geo_country AS Country,
       count(*) AS Amount,
FROM
  (SELECT string(post_prop26) AS Development,
          geo_country
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "listingSaved")
   GROUP BY Development,
            Country) s
group by Development,Country
