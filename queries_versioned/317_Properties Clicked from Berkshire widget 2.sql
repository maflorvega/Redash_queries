/*
Name: Properties Clicked from Berkshire widget 2
Data source: 4
Created By: Admin
Last Update At: 2016-03-04T13:38:15.387395+00:00
*/
SELECT REGEXP_EXTRACT(page_url,r'/listings\/(.+)\?.+') AS Property,
       count(*) AS Clicks,
       FROM
  (SELECT page_url, post_visid_high,DATE(date_time) as date_t
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop10= 'berkshire_hathaway_widget'
     AND post_prop72 = ''
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2016-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}')
   GROUP BY page_url, post_visid_high,date_t)
GROUP BY Property,
ORDER BY Clicks DESC
