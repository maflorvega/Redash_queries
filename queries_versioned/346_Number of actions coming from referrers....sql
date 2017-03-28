/*
Name: Number of actions coming from referrers...
Data source: 4
Created By: Admin
Last Update At: 2016-03-17T19:03:37.400949+00:00
*/
SELECT v.Referrer_domain AS Referrer_domain,
       count(*) AS Number_of_actions,
FROM
  (SELECT *
   FROM
     ( SELECT LOWER(CASE WHEN ref_domain = '' THEN 'no referrer domain' ELSE ref_domain END) As Referrer_domain,
              /*LOWER(ref_domain) AS Referrer_domain,*/
              visit_page_num,
              visid_high,
              visid_low,
              visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")')))v
   JOIN
     (SELECT visid_high,
             visid_low,
             visit_num,
             post_prop19,
             visit_page_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND (post_prop13 = 'LeadSubmited')
   /*AND post_prop19 = 'home'*/ ) AS det ON det.visid_high = v.visid_high
   AND det.visid_low = v.visid_low
   AND det.visit_num = v.visit_num)
WHERE v.visit_page_num = '1'
GROUP BY Referrer_domain
ORDER BY Number_of_actions DESC
