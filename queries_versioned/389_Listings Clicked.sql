/*
Name: Listings Clicked
Data source: 4
Created By: Admin
Last Update At: 2016-04-11T14:57:30.468565+00:00
*/
SELECT Listing,
       post_page_event,
       date(date_time) as date_time,
       count(*) AS clicks
FROM
  (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
          post_page_event,
          date_time
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) > date('2016-02-02')
     AND post_prop10 = 'home_hero'
     AND post_prop1 = 'listing' )
GROUP BY Listing,
         post_page_event,
         date_time
