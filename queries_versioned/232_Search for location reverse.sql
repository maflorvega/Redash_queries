/*
Name: Search for location reverse
Data source: 4
Created By: Admin
Last Update At: 2016-02-18T13:29:46.919657+00:00
*/
SELECT gloc.Country Country,
       Amount AS Amount_of_Searches
FROM
  (SELECT upper(geo_country) AS geo_country,
          COUNT(*) AS Amount
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND lower(REPLACE(REGEXP_EXTRACT(PAGE_URL, r'formatted_address%5D=([^&]*)'),'%2C',','))CONTAINS(lower('{{locationto}}')) /*Using + instead spaces*/
   GROUP BY geo_country) AS s
JOIN [djomniture:devspark.Geo_Loc] AS gloc ON gloc.Country_code = s.geo_country /*Joined to show completed country name*/
ORDER BY Amount DESC LIMIT 1000
