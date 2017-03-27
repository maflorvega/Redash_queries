/*
Name: Q
Data source: 4
Created By: Admin
Last Update At: 2015-10-14T19:06:48.448250+00:00
*/
SELECT * 
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) " ))
      WHERE
       REGEXP_MATCH(post_prop5, 'article_page_subzero_widget')        
limit 2
