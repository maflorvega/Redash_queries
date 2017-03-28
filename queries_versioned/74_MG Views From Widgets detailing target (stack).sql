/*
Name: MG Views From Widgets detailing target (stack)
Data source: 4
Created By: Admin
Last Update At: 2015-10-09T17:09:12.241292+00:00
*/
select 
  date,
  page,
  count(*) as Amount,
from(
  SELECT 
  date,
  mod as widget, 
  CASE 
    WHEN page_url contains '/developments/' THEN 'developments'
    WHEN page_url contains '/listings/' THEN 'listings'
    WHEN page_url contains '/search?' THEN 'search'
    WHEN page_url contains '/?' THEN 'home'
    WHEN ( 
         page_url contains '/london/' or 
         page_url contains '/miami/' or 
         page_url contains '/sanfranscisco/' or 
         page_url contains '/sydney/' or 
         page_url contains '/newyork/'
         ) THEN 'TopMarkets'
  END AS page,
  from(
    select string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) as date, post_prop10 as mod, page_url 
     FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
    where post_prop10 in ('mansion_global_search_cn_wsj_realestate','mansion_global_sponsor_unit_single_cn_wsj_home')
      AND DATE(date_time) >= DATE('{{startdate}}')
      AND DATE(date_time) <= DATE('{{enddate}}')  
  )
)  
where widget in ('mansion_global_search_cn_wsj_realestate')
group by date, widget, page
order by date, widget, page desc

