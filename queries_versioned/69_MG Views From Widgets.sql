/*
Name: MG Views From Widgets
Data source: 4
Created By: Admin
Last Update At: 2015-10-08T18:13:39.103580+00:00
*/
SELECT date,
       sum(CASE WHEN MOD = 'mansion_global_search_cn_wsj_realestate' THEN Amount ELSE integer('0') END) AS search_cn_wsj_realestate,
       sum(CASE WHEN MOD = 'mansion_global_sponsor_unit_single_cn_wsj_home' THEN Amount ELSE integer('0') END) AS sponsor_unit_single_cn,
       sum(Amount) AS TotalFromWSJCN
   FROM (
      SELECT integer(count(*)) as Amount, date, mod
      from(
        select string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) as date,post_prop10 as mod
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
        where post_prop10 in ('mansion_global_search_cn_wsj_realestate','mansion_global_sponsor_unit_single_cn_wsj_home')
          AND DATE(date_time) >= DATE('{{startdate}}')
          AND DATE(date_time) <= DATE('{{enddate}}')  
      )
      group by date,mod
      order by date desc
)
group by date
