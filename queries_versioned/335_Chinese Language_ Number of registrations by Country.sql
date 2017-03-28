/*
Name: Chinese Language: Number of registrations by Country
Data source: 4
Created By: Admin
Last Update At: 2016-03-11T15:30:37.562907+00:00
*/
SELECT  GL.Country AS Country,count(*) as Registrations,
from
(SELECT upper(geo_country) as geo_country,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop23 = "User Registration Succeed" /* Counting user registrations */ and post_page_event = "100"
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
       and post_prop64= 'Chinese') v 
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.geo_country
GROUP BY Country
order by Registrations desc
