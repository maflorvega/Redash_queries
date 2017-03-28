/*
Name: MG Views From Widgets detailing target
Data source: 4
Created By: Admin
Last Update At: 2015-10-09T15:22:15.170538+00:00
*/
SELECT date, replace(widget,'mansion_global_','') AS widget,
             sum(CASE WHEN page_url CONTAINS '/developments/' THEN Amount ELSE integer('0') END) AS Developments,
             sum(CASE WHEN page_url CONTAINS '/listings/' THEN Amount ELSE integer('0') END) AS Listings,
             sum(CASE WHEN page_url CONTAINS '/search?' THEN Amount ELSE integer('0') END) AS SEARCH,
             sum(CASE WHEN page_url CONTAINS '/?' THEN Amount ELSE integer('0') END) AS Home,
             sum(CASE WHEN (page_url CONTAINS '/london/'
                            OR page_url CONTAINS '/miami/'
                            OR page_url CONTAINS '/newyork/') THEN Amount ELSE integer('0') END) AS TopMarkets,
             sum(Amount) AS total from
  ( SELECT date, MOD AS widget, page_url, integer(count(*)) AS Amount, from
     ( SELECT string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date,post_prop10 AS MOD, page_url
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop10 IN ('mansion_global_search_cn_wsj_realestate','mansion_global_sponsor_unit_single_cn_wsj_home')
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}'))
   GROUP BY date, widget, page_url
   ORDER BY date DESC)
GROUP BY date, widget
