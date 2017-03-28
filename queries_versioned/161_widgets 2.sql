/*
Name: widgets 2
Data source: 4
Created By: Admin
Last Update At: 2016-02-01T19:43:20.020656+00:00
*/
SELECT date, sum(CASE WHEN MOD = 'mansion_global_search_cn_wsj_realestate' THEN Amount ELSE integer('0') END) AS search_cn_wsj_realestate,
             sum(CASE WHEN MOD = 'mansion_global_sponsor_unit_single_cn_wsj_home' THEN Amount ELSE integer('0') END) AS sponsor_unit_single_cn,
             sum(Amount) AS TotalFromWSJCN
FROM
  ( SELECT integer(count(*)) AS Amount, date, MOD from
     ( SELECT string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date,post_prop10 AS MOD
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop10 IN (select widget_name from djomniture:devspark.MG_Widgets)
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}'))
   GROUP BY date,MOD
   ORDER BY date DESC)
GROUP BY date
