/*
Name: ref-path-bhhs
Data source: 4
Created By: Admin
Last Update At: 2016-03-03T15:03:22.395309+00:00
*/
SELECT v.visid_high AS Start_session_number,
       v.date AS Date,
       v.User AS User,
       v.visit_num AS Visit_number,
       v.Article_listing AS Action,
       v.City AS City,
       GL.Country AS Country,
       v.Amount_of_pages AS Number_of_Clicks,
       det.Listings AS Listings,
       det.Articles AS Articles
FROM
  (SELECT visid_high,
          visid_low,
          string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date,
          /*REGEXP_REPLACE(post_prop24,'','Anonymous') AS User,*/
          (CASE WHEN post_prop24 = '' THEN 'Anonymous' ELSE post_prop24 END) As User,
          visit_num,
          post_prop1 AS Article_listing,
          UPPER(LEFT(geo_city,1))+LOWER(SUBSTRING(geo_city,2,LENGTH(geo_city))) AS City,
          UPPER(geo_country) AS Country,
          count(*) AS Amount_of_pages,
          sum(CASE WHEN post_prop1 = 'listing' THEN 1 ELSE 0 END) AS Listings,
          sum(CASE WHEN post_prop1 = 'article' THEN 1 ELSE 0 END) AS Articles
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2015-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}') //visit_num > '1'
     AND (post_prop1 = 'listing'
          OR post_prop1 = 'article')
     AND post_prop75 = 'article_page_berkshire_hathaway_widget'
   GROUP BY date, visid_high, User,visid_low, Visit_num,
                              Article_listing,
                              City,
                              Country,
   ORDER BY date, Article_listing, visid_high,
                  Visit_num DESC)v //Indica comienzo de visita //new_visit = 1 //visid_new = 'Y'
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.Country
JOIN 
  (SELECT visid_high,
          visid_low,
          visit_num,
          sum(CASE WHEN post_prop1 = 'listing' THEN 1 ELSE 0 END) AS Listings,
          sum(CASE WHEN post_prop1 = 'article' THEN 1 ELSE 0 END) AS Articles
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE('{{startdate}}') >= DATE('2015-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}') //visit_num > '1'
   GROUP BY visid_high, visid_low,Visit_num) AS det ON det.visid_high = v.visid_high AND det.visid_low = v.visid_low AND det.visit_num = v.visit_num
