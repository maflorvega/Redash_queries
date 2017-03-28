/*
Name: ref-path-action
Data source: 4
Created By: Admin
Last Update At: 2016-02-10T19:49:47.733646+00:00
*/
SELECT v.visid_high AS Start_session_number,
       v.date AS Date,
       v.User AS User,
       v.visit_num AS Visit_number,
       v.LeadSubmited_NewsletterSubscribe AS Action,
       v.City AS City,
       GL.Country AS Country,
       v.Amount_of_pages AS Amount_of_Lead_Newsletter,
       det.Listings AS Listings,
       det.Developments AS Developments,
       det.Articles AS Articles
FROM
  (SELECT visid_high,
          visid_low,
          string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date,
          /*REGEXP_REPLACE(post_prop24,'','Anonymous') AS User,*/
          (CASE WHEN post_prop24 = '' THEN 'Anonymous' ELSE post_prop24 END) As User,
          visit_num,
          CONCAT(post_prop13, post_prop23) AS LeadSubmited_NewsletterSubscribe,
          UPPER(LEFT(geo_city,1))+LOWER(SUBSTRING(geo_city,2,LENGTH(geo_city))) AS City,
          UPPER(geo_country) AS Country,
          count(*) AS Amount_of_pages,
          sum(CASE WHEN post_prop19 = 'listing' THEN 1 ELSE 0 END) AS Listings,
          sum(CASE WHEN post_prop19 = 'development' THEN 1 ELSE 0 END) AS Developments,
          sum(CASE WHEN post_prop19 = 'article' THEN 1 ELSE 0 END) AS Articles
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2015-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}') //visit_num > '1'
     AND (post_prop13 = 'LeadSubmited'
          OR post_prop23 = 'NewsletterSubscribe')
   GROUP BY date, visid_high, User,visid_low, Visit_num,
                              LeadSubmited_NewsletterSubscribe,
                              City,
                              Country,
   ORDER BY date, LeadSubmited_NewsletterSubscribe, visid_high,
                  Visit_num DESC)v //Indica comienzo de visita //new_visit = 1 //visid_new = 'Y'
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.Country
JOIN 
  (SELECT visid_high,
          visid_low,
          visit_num,
          sum(CASE WHEN post_prop19 = 'listing' THEN 1 ELSE 0 END) AS Listings,
          sum(CASE WHEN post_prop19 = 'development' THEN 1 ELSE 0 END) AS Developments,
          sum(CASE WHEN post_prop19 = 'article' THEN 1 ELSE 0 END) AS Articles
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2015-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}') //visit_num > '1'
   GROUP BY visid_high, visid_low,Visit_num) AS det ON det.visid_high = v.visid_high AND det.visid_low = v.visid_low AND det.visit_num = v.visit_num
