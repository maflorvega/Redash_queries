/*
Name: Lead submitted - Email used by entry mod code.
Data source: 4
Created By: Admin
Last Update At: 2016-03-17T20:24:03.351198+00:00
*/
SELECT v.mod_code AS mod_code,
       det.User AS MyMG_email,
       count(*) AS Number_of_leads,
FROM
  (SELECT *
   FROM
     (SELECT (CASE WHEN post_prop24 = '' THEN 'Anonymous' ELSE post_prop24 END) AS USER,
             LOWER(CASE WHEN post_prop10 = '' THEN 'no mod code' ELSE post_prop10 END) AS mod_code,
             visit_page_num,
             visid_high,
             visid_low,
             visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")')))v
   JOIN
     (SELECT (CASE WHEN post_prop24 = '' THEN 'Anonymous' ELSE post_prop24 END) AS USER,
             LOWER(CASE WHEN post_prop10 = '' THEN 'no mod code' ELSE post_prop10 END) AS mod_code,
             visid_high,
             visid_low,
             visit_num,
             visit_page_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND (post_prop13 = 'LeadSubmited')
        AND (post_prop24 != '') /*filtra anonimos*/
        /*AND (CASE WHEN '{{mod}}' = 'no mod code' THEN '' ELSE '{{mod}}' END) = (CASE WHEN '{{mod}}' = 'no mod code' THEN '' ELSE '{{mod}}' END)*/) AS det ON det.visid_high = v.visid_high
   AND det.visid_low = v.visid_low
   AND det.visit_num = v.visit_num)
WHERE v.visit_page_num = '1'
  AND v.mod_code = '{{mod}}'/*(CASE WHEN '{{mod}}' = 'no mod code' THEN '' ELSE '{{mod}}' END)*/
GROUP BY MyMG_email,
         mod_code,
ORDER BY Number_of_leads DESC
