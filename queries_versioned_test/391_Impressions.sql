/*
Name: Impressions
Data source: 4
Created By: Admin
Last Update At: 2016-04-11T19:43:15.265424+00:00
*/
SELECT date_time,post_prop34,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) > date('2016-02-02')
     AND post_prop33 = 'MG_HomeHero_Impressions'

