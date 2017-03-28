/*
Name: Widg
Data source: 4
Created By: Admin
Last Update At: 2015-10-15T19:13:19.919214+00:00
*/
select  page_url,
             date_time,
            
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}'))"))
WHERE page_url LIKE '%article_page_subzero_widget%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')

