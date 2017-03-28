/*
Name: Number of actions by entry mod code...
Data source: 4
Created By: Admin
Last Update At: 2016-03-17T19:12:41.828898+00:00
*/
SELECT v.mod_code AS mod_code,
       count(*) AS Number_of_leads,
FROM
  (SELECT *
   FROM
     ( SELECT LOWER(CASE WHEN post_prop10 = '' THEN 'no mod code' ELSE post_prop10 END) As mod_code,
              /*LOWER(ref_domain) AS Referrer_domain,*/
              visit_page_num,
              visid_high,
              post_prop10,
              visid_low,
              visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")')))v
   JOIN
     (SELECT LOWER(CASE WHEN post_prop10 = '' THEN 'no mod code' ELSE post_prop10 END) As mod_code,
             visid_high,
             visid_low,
             visit_num,
             post_prop10,
             visit_page_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND (post_prop13 = 'LeadSubmited')
   /*AND post_prop19 = 'home'*/ ) AS det ON det.visid_high = v.visid_high
   AND det.visid_low = v.visid_low
   AND det.visit_num = v.visit_num)
WHERE v.visit_page_num = '1'
GROUP BY mod_code,
ORDER BY Number_of_leads DESC
