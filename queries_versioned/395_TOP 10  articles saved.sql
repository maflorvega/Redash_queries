/*
Name: TOP 10  articles saved
Data source: 4
Created By: Admin
Last Update At: 2016-04-13T13:41:47.178102+00:00
*/
SELECT  post_prop26 as Article,count(*) Article_Saved
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE  date(date_time) > date('2016-02-02')
and post_page_event='100'
and post_prop25 ='articleSaved'
group by Article
order by Article_Saved desc
LIMIT 10

