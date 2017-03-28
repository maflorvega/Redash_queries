/*
Name: ref-path-lead-per-session
Data source: 4
Created By: Admin
Last Update At: 2016-03-17T20:20:15.122464+00:00
*/
SELECT v.visit_page_num AS Visit_page_num, /*Orden*/
       v.User AS User,
       v.visid_high AS Start_session_number,
       v.visid_low AS End_session_number,
       v.date AS Date, /*Fecha vista de pagina*/
       v.geo_city AS City,
       GL.Country AS Country,
       v.LeadSubmited AS Lead_Submited,
       v.visit_num AS Visit_number,
       v.post_prop10 AS mod_code,
       v.Page_type AS Page_type,
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
       (CASE WHEN CONCAT(post_prop13, post_prop23) = '' THEN '---' ELSE CONCAT(post_prop13, post_prop23) END) as LeadSubmited,
       visit_page_num, /*Orden*/
       visit_num,
       (CASE WHEN post_prop19 = '' THEN 'search' ELSE post_prop19 END) AS Page_type,
       ip,
       ref_domain, /*Dominio que refirio a MG*/       
       visit_start_page_url, /*Primer pagina vista en MG*/       
       page_url, /*pagina vista*/ 
       post_prop10,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND visid_high = '{{start_sn}}'
  AND visit_num = '{{visit_n}}'
ORDER BY date_time LIMIT 1000) v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.Country
