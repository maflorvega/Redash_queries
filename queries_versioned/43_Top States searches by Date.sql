/*
Name: Top States searches by Date
Data source: 4
Created By: Admin
Last Update At: 2015-09-02T17:37:40.031047+00:00
*/


SELECT STATE,
       country,
       count(*) AS Amount
FROM
  (SELECT REGEXP_REPLACE(REPLACE(STATE,' ',''),'[0-9]*','') AS STATE,
          country
   FROM
     (SELECT formatted_address,
             nth(2,split(formatted_address,',')) STATE,
                                                 REPLACE(last(split(last(split(formatted_address,',')),'-')),' ','') country
      FROM
        (SELECT REPLACE(REPLACE(REGEXP_EXTRACT(PAGE_URL, r'formatted_address%5D=([^&]*)') ,'+',' '),'%2C',',') AS formatted_address
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE post_page_event = "0" /* Pageview Calls*/
           AND page_url LIKE '%formatted_address%'
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}'))
      WHERE regexp_match(formatted_address, r'(.)+,(.)+,(.)+'))
   WHERE country IN ('USA',
                     'UnitedStates'))
WHERE length(STATE) = 2
  AND regexp_match(STATE, r'([A-Z]){2}')
GROUP BY STATE,
         country
ORDER BY Amount DESC
