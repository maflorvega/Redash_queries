/*
Name: Amount of Searches saved 2
Data source: 4
Created By: Admin
Last Update At: 2016-09-26T13:37:22.499847+00:00
*/
SELECT  date_time
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE  date(date_time) > date('2016-02-02')
and post_page_event='100'
and post_prop25 ='searchSaved'
order by date_time asc



