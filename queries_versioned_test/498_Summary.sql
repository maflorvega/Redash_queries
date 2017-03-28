/*
Name: Summary
Data source: 4
Created By: Admin
Last Update At: 2017-02-22T20:15:45.797437+00:00
*/
SELECT 
       Reports,
       TotalCurrentWeek as TotalCurrentPeriod,
       '('+ STRING(StartFirst)+' TO '+STRING(EndFirst)+')' AS PreviousPeriod,       
       TotalPastWeek as TotalPreviousPeriod,
   (CASE WHEN (((TotalCurrentWeek-TotalPastWeek)/ TotalPastWeek)*100)>=0  THEN SUBSTRING(STRING(((TotalCurrentWeek-TotalPastWeek)/ TotalPastWeek)*100),1,4) ELSE SUBSTRING(STRING(((TotalCurrentWeek-TotalPastWeek)/ TotalPastWeek)*100),1,6) END) as PercentageOfChange
FROM



(SELECT DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day")) StartFirst,
      DATE(DATE_ADD('{{startdate}}',-1,"Day")) EndFirst,
       DATE('{{startdate}}') startSecond,
       DATE('{{enddate}}') endSecond,	   
       Reports,
       sum(TotalCurrentWeek) AS TotalCurrentWeek,
       sum(TotalPastWeek) AS TotalPastWeek,
FROM
(SELECT 'Total Listing Views' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT post_prop20 AS Listing, 
             count(*) AS Total,            
      FROM  (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" 
        AND post_prop19 = 'listing' 
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
      GROUP BY Listing)c 
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
   GROUP BY Reports) ,

  (SELECT 'Total Listing Views' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      WHERE post_page_event = "0" /*PageView Calls*/
        AND post_prop19 = 'listing' /* Counting Listings */
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))  
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day"))
        
      GROUP BY Listing)c /*List of valid listings (active/no active)*/
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
   GROUP BY Reports)
 
,

 (SELECT 'Total Development Views' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT post_prop20 AS Development, 
             count(*) AS Total,            
      FROM  (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" 
        AND post_prop19 = 'development' 
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
      GROUP BY Development)V 
   JOIN (SELECT string(id) AS did
   FROM[djomniture:devspark.MG_Developments]) AS D ON D.did=v.Development
   GROUP BY Reports) ,

  (SELECT 'Total Development Views' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT post_prop20 AS Development,
             count(*) AS Total,             
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      WHERE post_page_event = "0" /*PageView Calls*/
        AND post_prop19 = 'development' /* Counting Listings */
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))  
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day"))
        
      GROUP BY Development)V /*List of valid listings (active/no active)*/
  JOIN (SELECT string(id) AS did
   FROM[djomniture:devspark.MG_Developments]) AS D ON D.did=v.Development
   GROUP BY Reports)
 ,

(SELECT 'Total Listing Views through article body' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) AS Total,            
      FROM  (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" 
        AND post_prop19 = 'listing' 
        and post_prop10 = 'article_body' 
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
      GROUP BY Listing)c 
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
   GROUP BY Reports) ,

  (SELECT 'Total Listing Views through article body' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) AS Total,
             /*Listing properties per listing*/
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      
      WHERE post_page_event = "0" /*PageView Calls*/
        AND post_prop19 = 'listing' /* Counting Listings */
       and post_prop10 = 'article_body' 
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))  
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day"))
        
      GROUP BY Listing)c /*List of valid listings (active/no active)*/
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
   GROUP BY Reports)
 
,
(SELECT 'Total Leads' AS Reports,
          Integer(count(*)) AS TotalCurrentWeek
   FROM [djomniture:devspark.MG_Leads]
   WHERE DATE(Date) >= DATE('{{startdate}}')
   AND (development_id IS NOT NULL
       OR listing_id IS NOT NULL)
     AND DATE(Date) <= DATE('{{enddate}}')),  
 
(SELECT 'Total Leads' AS Reports ,
          Integer(count(*)) AS TotalPastWeek,
   FROM [djomniture:devspark.MG_Leads]
   WHERE DATE(Date) <= DATE(DATE_ADD('{{startdate}}',-1,"Day"))
    AND (development_id IS NOT NULL
       OR listing_id IS NOT NULL)
     AND DATE(Date) >= DATE(DATE_ADD('{{startdate}}',-(DAYOFYEAR('{{enddate}}') - DAYOFYEAR('{{startdate}}'))-1,"Day"))),



(SELECT 'Total Social Shares' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) AS Total,            
      FROM  (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE 
       (post_prop21 = 'Social_Click'
       OR post_prop21 = 'Email_Click')/*IT IS AN SOCIAL CLICK*/
        AND post_prop22 NOT LIKE 'MG_%'
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
      GROUP BY Listing)c 
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
   GROUP BY Reports) ,

  (SELECT 'Total Social Shares' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) AS Total,
             /*Listing properties per listing*/
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      WHERE (post_prop21 = 'Social_Click'
       OR post_prop21 = 'Email_Click')/*IT IS AN SOCIAL CLICK*/
  		AND post_prop22 NOT LIKE 'MG_%'
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))  
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day"))
        
      GROUP BY Listing)c /*List of valid listings (active/no active)*/
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
   GROUP BY Reports)
 ,
 (SELECT 'Amount of total external Clicks' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
        AND date_time >= date('2016-11-18')
        AND (post_prop1='listing'
             OR post_prop1='development'
             OR (post_prop1='article' AND post_prop75='article_page_berkshire_hathaway_widget'))
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}') )c
   GROUP BY Reports) ,
 
(SELECT 'Amount of total external Clicks' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
        AND date_time >= date('2016-11-18')
        AND (post_prop1='listing'
             OR post_prop1='development'
             OR (post_prop1='article' AND post_prop75='article_page_berkshire_hathaway_widget'))
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day")) )c /*List of valid listings (active/no active)*/
   GROUP BY Reports)
 ,

 (SELECT 'Amount of external clicks for listings' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='listing')
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}') )c
   GROUP BY Reports) ,
 
(SELECT 'Amount of external clicks for listings' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='listing')
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day")) )c /*List of valid listings (active/no active)*/
   GROUP BY Reports)
 ,


 (SELECT 'Amount of external clicks for developments' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='development')
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}') )c
   GROUP BY Reports) ,
 
(SELECT 'Amount of external clicks for developments' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='development')
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day")) )c /*List of valid listings (active/no active)*/
   GROUP BY Reports)
 ,

(SELECT 'Amount of external clicks for Berkshire Widget' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='article')
  AND (post_prop75='article_page_berkshire_hathaway_widget')
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}') )c
   GROUP BY Reports) ,
 
(SELECT 'Amount of external clicks for Berkshire Widget' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='article')
  AND (post_prop75='article_page_berkshire_hathaway_widget')
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day")) )c /*List of valid listings (active/no active)*/
   GROUP BY Reports)
 ,

(SELECT 'Total Searches' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" /* Pageview Calls*/
        AND page_url LIKE '%/search%'
        AND page_url LIKE '%5Bformatted_address%'
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}'))c
   GROUP BY Reports) ,
  (SELECT 'Total Searches' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      WHERE post_page_event = "0" /* Pageview Calls*/
        AND page_url LIKE '%/search%'
        AND page_url LIKE '%5Bformatted_address%'
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day")))c /*List of valid listings (active/no active)*/
   GROUP BY Reports)
 ,
 
 (SELECT 'Amount of views for Listings located in US' AS Reports,
          Integer(sum(Total)) AS TotalCurrentWeek,
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) AS Total,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0"
        AND post_prop19 = 'listing'
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
      GROUP BY Listing)c
   JOIN each
     (SELECT *
      FROM [djomniture:devspark.MG_Listing_Address]
      WHERE (UPPER(country)='US'
             OR UPPER(country)='USA'
             OR UPPER(country)='UNITED STATES'))AS MG_LA ON c.Listing = MG_LA.id
   GROUP BY Reports) ,
 
  (SELECT 'Amount of views for Listings located in US' AS Reports,
          Integer(sum(Total)) AS TotalPastWeek,
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) AS Total,
             /*Listing properties per listing*/

      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") ,-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"),"%Y-%m-01")  and 
 STRFTIME_UTC_USEC(DATE_ADD(STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-31") ,-1,"Day"),"%Y-%m-31")'))
      WHERE post_page_event = "0" /*PageView Calls*/
        AND post_prop19 = 'listing' /* Counting Listings */
        AND DATE(Date_time) >= DATE(DATE_ADD('{{startdate}}',-(DATEDIFF("{{enddate}}","{{startdate}}"))-1,"Day"))
        AND DATE(Date_time) <= DATE(DATE_ADD('{{startdate}}',-1,"Day"))
      GROUP BY Listing)c /*List of valid listings (active/no active)*/
   JOIN each
     (SELECT *
      FROM [djomniture:devspark.MG_Listing_Address]
      WHERE (UPPER(country)='US'
             OR UPPER(country)='USA'
             OR UPPER(country)='UNITED STATES'))AS MG_LA ON c.Listing = MG_LA.id
   GROUP BY Reports),
 
(SELECT 'Total listings that were live' as Reports,Integer(count(*)) AS TotalCurrentWeek
FROM
  (SELECT string(id) as id
   FROM [djomniture:devspark.MG_All_Listings]
   WHERE (DATE(created_at) <= DATE('{{enddate}}')
          AND DATE(deleted_at) IS NULL) /*active listings*/
     OR (DATE(deleted_at) >= Date('{{startdate}}')
         AND DATE(deleted_at) <= Date('{{enddate}}'))
   GROUP BY id))
,
 
 (
SELECT 'Total listings that were live' as Reports,Integer(count(*)) AS TotalPastWeek
FROM
  (SELECT string(id) as id
   FROM [djomniture:devspark.MG_All_Listings]
   WHERE (DATE(created_at) <= DATE(DATE_ADD('{{startdate}}',-1,"Day"))
          AND DATE(deleted_at) IS NULL) /*active listings*/
     OR (DATE(deleted_at) >= DATE(DATE_ADD('{{startdate}}',-(DAYOFYEAR('{{enddate}}') - DAYOFYEAR('{{startdate}}'))-1,"Day"))
         AND DATE(deleted_at) <= DATE(DATE_ADD('{{startdate}}',-1,"Day")))
   GROUP BY id))

GROUP BY Reports)

