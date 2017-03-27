/*
Name: Listings Clicked
Data source: 4
Created By: Admin
Last Update At: 2016-04-11T19:08:52.579354+00:00
*/
SELECT * from
  ( SELECT Listing, count(*) AS clicks
   FROM
     (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing, post_page_event
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND date(date_time) > date('2016-02-02')
        AND post_prop10 = 'home_hero'
        AND post_prop1 = 'listing')
   GROUP BY Listing)v
LEFT OUTER JOIN
  (SELECT post_prop34,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) > date('2016-02-02')
     AND post_prop33 = 'MG_HomeHero_Impressions') Clicks ON Clicks.post_prop34 = v.Listing
