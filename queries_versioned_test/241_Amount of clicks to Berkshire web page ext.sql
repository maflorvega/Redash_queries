/*
Name: Amount of clicks to Berkshire web page ext
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T14:09:44.960550+00:00
*/

SELECT post_prop10,
       page_url,
       post_prop1,
       count(*) AS ExternalClicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_prop75= 'article_page_berkshire_hathaway_widget'
  AND post_prop1 = 'article'
GROUP BY post_prop10,
         page_url,
         post_prop1
ORDER BY ExternalClicks DESC
