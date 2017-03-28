/*
Name: widgets
Data source: 4
Created By: Admin
Last Update At: 2016-02-01T19:12:30.443243+00:00
*/
SELECT post_prop10,
       post_prop72,
       page_url
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop10 IN
    (SELECT widget_name
     FROM [djomniture:devspark.MG_Widgets])
GROUP BY post_prop10,
         post_prop72,
         page_url
