/*
Name: Amount of Searches by Lat&Lng
Data source: 4
Created By: Admin
Last Update At: 2015-08-28T20:06:54.597509+00:00
*/
SELECT lat,
       lng,
       Amount
FROM
  (SELECT REGEXP_REPLACE(REPLACE(REPLACE(REGEXP_EXTRACT(PAGE_URL, r'%5Blat%5D=([^&]*)'),'+',' '),'%2C',','),r'^((-)?[0-9]*\.[0-9]{2})([0-9]*)','\\1') AS lat,
          REGEXP_REPLACE(REPLACE(REPLACE(REGEXP_EXTRACT(PAGE_URL, r'%5Blng%5D=([^&]*)'),'+',' '),'%2C',','),r'^((-)?[0-9]*\.[0-9]{2})([0-9]*)','\\1') AS lng,
          count(*) AS Amount
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
     AND page_url LIKE '%lat%'
     AND page_url LIKE '%lng%'
     AND page_url LIKE '%formatted_address%'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   GROUP BY lat,
            lng
   ORDER BY Amount DESC)
WHERE lat !=''
  AND lat !='-'
  AND lng !=''
  AND lng !='-'
