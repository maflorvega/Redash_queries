/*
Name: Users successfully registered by country
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T17:39:03.932459+00:00
*/
SELECT GL.Country AS Country,
       Registrations from
  (SELECT geo_country, COUNT(*) AS Registrations,
   FROM
     (SELECT upper(geo_country) AS geo_country, post_prop23
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop23 = "User Registration Succeed" /* Counting user registrations */ and post_page_event = "100"
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}'))L
   GROUP BY geo_country) v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.geo_country
order by Registrations desc
