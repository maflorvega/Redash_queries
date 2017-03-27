/*
Name: Articles saved
Data source: 4
Created By: Admin
Last Update At: 2016-04-06T12:51:51.093301+00:00
*/
select page_url,post_prop20, count(*) Save_count
from(
SELECT Post_prop24,post_prop20, page_url
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "articleSaved"))
group by post_prop20,page_url
order by Save_count desc
