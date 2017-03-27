/*
Name: Login authentication errors by Country
Data source: 4
Created By: Admin
Last Update At: 2016-02-18T14:25:09.768165+00:00
*/
SELECT GL.Country AS Country,
       Logins,
FROM
     (SELECT post_prop23,
             upper(geo_country) AS geo_country,
             count(*) AS Logins
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE (post_prop23 = 'User Login Failed')
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND post_page_event = "100"
      GROUP BY post_prop23,
               geo_country)v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.geo_country
order by Logins
