/*
Name: test22
Data source: 4
Created By: Admin
Last Update At: 2016-02-01T20:17:06.165616+00:00
*/
SELECT post_prop72, post_prop10
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop10 in (select widget_name from [djomniture:devspark.MG_Widgets])



