/*
Name: Unique developments saved per user
Data source: 4
Created By: Admin
Last Update At: 2016-02-26T19:26:16.161033+00:00
*/
SELECT D.name AS Development,
       LA.street_address AS DevelopmentAddress, LA.city as City,LA.country as Country,
       count(*) AS Save_Count
FROM
  (SELECT string(post_prop26) AS development_id,
          COUNT(DISTINCT post_prop24 +string(post_prop26)) DevelopmentSaved
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "developmentSaved")
   GROUP BY development_id) s
LEFT OUTER JOIN
  (SELECT string(id) AS development,
          address,
          name
   FROM [djomniture:devspark.MG_Developments]) AS D ON s.development_id = D.development
LEFT OUTER JOIN
  (SELECT id,
          street_address, city, zip_code,country
   FROM [djomniture:devspark.MG_Development_Address]) AS LA ON D.Development = LA.id /*JOIN TO ADD VALID DEVELOPMENT ID*/
GROUP BY Development,
         DevelopmentAddress, City,Country
ORDER BY Save_Count desc
