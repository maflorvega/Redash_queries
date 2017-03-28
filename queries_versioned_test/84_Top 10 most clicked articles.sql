/*
Name: Top 10 most clicked articles
Data source: 4
Created By: Admin
Last Update At: 2015-10-16T14:29:35.221278+00:00
*/
SELECT NVL(TOP(replace(post_prop65,'MG_article_',''), 10),'empty') as Article ,
       count(*) AS Amount
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}'))"))
WHERE page_url LIKE '%article_page_subzero_widget%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
