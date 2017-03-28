/*
Name: Amount of Searches saved
Data source: 4
Created By: Admin
Last Update At: 2016-02-29T18:44:39.683321+00:00
*/
SELECT  count(*) as Save_count
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE  date(date_time) > date('2016-02-02')
 AND DATE(date_time) >= DATE('{{startdate}}')
AND DATE(date_time) <= DATE('{{enddate}}')
and post_page_event='100'
and post_prop25 ='searchSaved'




