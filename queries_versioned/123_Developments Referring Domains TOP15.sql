/*
Name: Developments Referring Domains TOP15
Data source: 4
Created By: Admin
Last Update At: 2015-12-14T19:05:56.295558+00:00
*/
SELECT TOP(ref_domain, 15) as referring_domain,count(*) Amount
from (
  SELECT REGEXP_REPLACE(replace(replace(replace(ref_domain,'https://',''),'http://',''),'',''),'/$','') as ref_domain
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
   AND post_prop19 = 'development'
   and ref_domain is not null
   and ref_domain != ''
   AND DATE(date_time) >= DATE('{{startdate}}')
   AND DATE(date_time) <= DATE('{{enddate}}') 
)
