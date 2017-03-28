/*
Name: Unique users by city
Data source: 4
Created By: Admin
Last Update At: 2016-02-24T17:25:06.409082+00:00
*/
SELECT geo_city AS City,
       count(*) as Users
FROM
  (SELECT geo_city,
          count(DISTINCT(post_prop24+ geo_city)) AS users
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "100"
     AND (post_prop23 = "User Registration Succeed" /* Counting registrations */
          OR post_prop23 = 'User Login Succeed'
          OR post_prop23='FB User Login Succeed' /* Counting Logins */)
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
   GROUP BY geo_country,geo_city
   ORDER BY users DESC ) 
group by City
order by Users desc
