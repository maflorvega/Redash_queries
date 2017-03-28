/*
Name: ref-path-bhhs-per-session
Data source: 4
Created By: Admin
Last Update At: 2016-03-03T17:01:56.666012+00:00
*/
SELECT v.visit_page_num AS Visit_page_num, /*Orden*/
       v.User AS User,
       v.visid_high AS Start_session_number,
       v.visid_low AS End_session_number,
       v.date AS Date, /*Fecha vista de pagina*/
       v.geo_city AS City,
       GL.Country AS Country,
       v.post_prop75 AS Action_click,
       v.Action AS Article_or_listing,
       v.visit_num AS Visit_number,
       v.ip AS IP,
       v.ref_domain AS Ref_domain, /*Dominio que refirio a MG*/       
       v.visit_start_page_url AS visit_start_page_url, /*Primer pagina vista en MG*/       
       v.page_url AS page_url, /*pagina vista*/
FROM (SELECT /*REGEXP_REPLACE(post_prop24,'','Anonymous') AS User,*/(CASE WHEN post_prop24 = '' THEN 'Anonymous' ELSE post_prop24 END) As User,
       visid_high,
       visid_low,
       string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date, /*Fecha vista de pagina*/
       UPPER(LEFT(geo_city,1))+LOWER(SUBSTRING(geo_city,2,LENGTH(geo_city))) AS geo_city,
       UPPER(geo_country) AS Country,
       (CASE WHEN post_prop75 = 'article_page_berkshire_hathaway_widget' AND post_prop1 = 'listing' THEN 'Internal Click' WHEN post_prop75 = 'article_page_berkshire_hathaway_widget' AND post_prop1 = 'article' THEN 'External Click' ELSE post_prop75 END) as post_prop75,
       LOWER(CASE WHEN post_prop1 != 'article' AND post_prop1 != 'listing' THEN '---' ELSE post_prop1 END) as Action,
       visit_page_num, /*Orden*/
       visit_num,
       ip,
       ref_domain, /*Dominio que refirio a MG*/       
       visit_start_page_url, /*Primer pagina vista en MG*/       
       page_url, /*pagina vista*/ 
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND visid_high = '{{start_sn}}'
  AND visit_num = '{{visit_n}}'
ORDER BY date_time LIMIT 1000) v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.Country
