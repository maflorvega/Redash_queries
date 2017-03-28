/*
Name: Amount of views for Baidu2
Data source: 4
Created By: Admin
Last Update At: 2016-02-10T20:31:22.023402+00:00
*/

SELECT 
       count(*) AS value
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE LOWER(post_prop19)='home'
  AND post_prop10 LIKE '%djcm_pdadcn_baidu%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_page_event = "0" /*Page View Calls*/

  

