/*
Name: Top 10 countries searched by Date
Data source: 4
Created By: Admin
Last Update At: 2015-09-02T16:27:55.177647+00:00
*/
SELECT TOP(country, 10) TOP10Countries,
       count(*) AS Amount
FROM
  ( SELECT nvl(UPPER(C1.displayName),UPPER(C2.country)) AS Country
   FROM [djomniture:devspark.COUNTRIES] C1 FULL
   OUTER JOIN EACH
     (SELECT LOWER(RTRIM(LTRIM(last(split(last(split(formatted_address,',')),'-'))))) country,
      FROM
        (SELECT REPLACE(REPLACE(REGEXP_EXTRACT(PAGE_URL, r'formatted_address%5D=([^&]*)'),'+',' '),'%2C',',') AS formatted_address
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE post_page_event = "0" /* Pageview Calls*/
           AND page_url LIKE '%formatted_address%'
           AND page_url LIKE '%/search%'
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}'))) C2 ON C1.country=C2.country)
