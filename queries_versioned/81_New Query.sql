/*
Name: New Query
Data source: 4
Created By: Admin
Last Update At: 2015-10-15T19:59:46.381452+00:00
*/
SELECT Development,
	      RANK() OVER (PARTITION BY dummy order by Views desc) as range_rank,
          COUNT(visit_num) AS Views,
FROM ( 
  SELECT 1 dummy,FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Development, visit_num
    FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) " ))
    WHERE post_page_event = "0" /*Page View Calls*/
      AND DATE(date_time) >= DATE('{{startdate}}')
      AND DATE(date_time) <= DATE('{{enddate}}')
      AND post_prop19 = 'development' /* Counting Listings */ 
)
GROUP BY Development,dummy
