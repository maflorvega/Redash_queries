/*
Name: Number of logins by browser language by Country
Data source: 4
Created By: Admin
Last Update At: 2016-03-11T15:20:22.798861+00:00
*/
SELECT  GL.Country AS Country, count(*) as Logins
     
FROM
  (SELECT upper(geo_country) AS geo_country
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop23 = 'User Login Succeed')
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_page_event = "100" )v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.geo_country
group by Country
order by Logins desc
