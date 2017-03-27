/*
Name: Number of Newsletter Subscribed
Data source: 4
Created By: Admin
Last Update At: 2016-02-23T18:25:19.473585+00:00
*/
SELECT count(*) AS Amount_of_NewsletterSubscribe,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE DATE(date_time) >= DATE('{{startdate}}')
  AND DATE('{{startdate}}') >= DATE('2015-02-01')
  AND DATE(date_time) <= DATE('{{enddate}}') //visit_num > '1'
  AND (post_prop23 = 'NewsletterSubscribe')
