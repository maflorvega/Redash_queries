/*
Name: sss
Data source: 4
Created By: Admin
Last Update At: 2016-02-29T20:34:25.855278+00:00
*/
SELECT count(*)
FROM(


select page_url,  integer(count(*)) AS Searches
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE date(date_time) > date('2016-02-02')
  AND post_page_event='100'
  AND post_prop25 ='searchSaved' and page_url like '%lifestyles%'
group by page_url)
