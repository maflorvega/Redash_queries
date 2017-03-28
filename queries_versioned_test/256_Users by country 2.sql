/*
Name: Users by country 2
Data source: 4
Created By: Admin
Last Update At: 2016-02-22T18:03:22.981504+00:00
*/
SELECT g.code AS Country,
       g.lat AS lat,
       g.lng AS lng,
       v.users AS Users
FROM
  (SELECT geo_country,
          count(DISTINCT(post_prop24+ geo_country)) AS users
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "100"
     AND (post_prop23 = "User Registration Succeed" /* Counting registrations */
          OR post_prop23 = 'User Login Succeed'
          OR post_prop23='FB User Login Succeed' /* Counting Logins */)
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   GROUP BY geo_country,
   ORDER BY users DESC ) v
JOIN
  (SELECT lower(Country_code) AS code,
          lat,
          lng
   FROM [djomniture:devspark.Geo_Loc])AS g ON v.geo_country = g.code
