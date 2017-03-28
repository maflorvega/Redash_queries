/*
Name: Listing Views by MG test
Data source: 4
Created By: Admin
Last Update At: 2016-02-16T18:24:49.934315+00:00
*/

SELECT  page_url,post_prop72,
         post_prop5
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE post_prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
           AND post_prop72 != ''
           AND post_prop72 != '__'
          
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) >= '2015-10-10'
           AND DATE(date_time) <= DATE('{{enddate}}') 
 
                
	

