/*
Name: Amount of clicks to Berkshire web page test
Data source: 4
Created By: Admin
Last Update At: 2016-02-16T18:21:33.961819+00:00
*/

SELECT 
       page_url,post_prop72,post_prop20,post_prop75,
       
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE page_url LIKE '%target_url=http%3A%2F%2Fwww.berkshirehathawayhs.com%'
  AND post_prop10=''
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}')
 and post_prop75= 'article_page_berkshire_hathaway_widget'


