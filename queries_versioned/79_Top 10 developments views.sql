/*
Name: Top 10 developments views
Data source: 4
Created By: Admin
Last Update At: 2015-10-15T17:56:42.928741+00:00
*/
SELECT 
  d.Development as Development,
  la.address as DevelopmentAddress,
  d.Views as Views,
  d.range_rank as Rank,
  previousweek.range_rank as PreviousWeekRank,
  IF((previousweek.range_rank - d.range_rank) > 0, concat('+',string(previousweek.range_rank - d.range_rank)), string(previousweek.range_rank - d.range_rank))  as Status

FROM ( 
    SELECT Development,
	      RANK() OVER (PARTITION BY dummy order by Views desc) as range_rank,
          COUNT(visit_num) AS Views
      FROM ( 
        SELECT 1 as dummy,FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Development, visit_num
          FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) " ))
          WHERE post_page_event = "0" /*Page View Calls*/
            AND DATE(date_time) >= DATE('{{startdate}}')
            AND DATE(date_time) <= DATE('{{enddate}}')
            AND post_prop19 = 'development' /* Counting Listings */ 
      )
      GROUP BY Development,dummy
  ) d
	JOIN (
      SELECT Development,
	   		 RANK() OVER (PARTITION BY dummy order by Views desc) as range_rank,
       		 COUNT(visit_num) AS Views,
   	    FROM
     	 (SELECT 1 as dummy,FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Development, visit_num
            	   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) " ))
            	  WHERE post_page_event = "0" /*Page View Calls*/
              	    AND DATE(date_time) >= DATE(DATE_ADD(DATE('{{startdate}}'),-15,"Day"))
              	    AND DATE(date_time) <= DATE(DATE_ADD(DATE('{{enddate}}'),-8,"Day"))
              	    AND post_prop19 = 'development' /* Counting Listings */
     	)
   		GROUP BY Development, dummy
      ) AS previousweek ON d.Development = previousweek.Development
/*OUTER JOIN TO ADD DEVELOPMENT ADDRESS*/
LEFT OUTER JOIN
 ( SELECT id,address FROM [djomniture:devspark.MG_Development_Address] ) AS LA ON d.Development = LA.id

/*JOIN TO ADD VALID DEVELOPMENT ID*/
JOIN
 ( SELECT string(id) AS did FROM [djomniture:devspark.MG_Developments] ) AS LID ON d.Development = LID.did
ORDER BY Views DESC 
LIMIT 10
