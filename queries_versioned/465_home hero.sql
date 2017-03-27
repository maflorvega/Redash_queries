/*
Name: home hero
Data source: 4
Created By: Admin
Last Update At: 2016-11-02T19:55:29.201393+00:00
*/
select * from
(SELECT date_time,post_prop34
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) >= date('2016-05-04')
     AND post_prop35 ='' /*is a listing*/
   and post_page_event='100'
     AND post_prop33 = 'MG_HomeHero_Impressions'
    and post_prop34='347805' 
order by date_time desc) v
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34


