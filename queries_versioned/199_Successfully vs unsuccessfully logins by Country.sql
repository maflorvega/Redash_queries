/*
Name: Successfully vs unsuccessfully logins by Country
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T16:09:24.841869+00:00
*/
SELECT GL.Country AS Country,
       v.Login_Succeed AS Login_Succeed,
       v.Login_Failed AS Login_Failed
FROM
  (SELECT geo_country,
          sum(CASE WHEN post_prop23 = 'User Login Succeed' THEN Logins ELSE integer('0') END) AS Login_Succeed,
          sum(CASE WHEN post_prop23 = 'User Login Failed' THEN Logins ELSE integer('0') END) AS Login_Failed,
   FROM
     (SELECT post_prop23,
             upper(geo_country) AS geo_country,
             integer(count(*)) AS Logins
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE (post_prop23 = 'User Login Succeed'
             OR post_prop23='User Login Failed')
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND post_page_event = "100"
      GROUP BY post_prop23,
               geo_country)
   GROUP BY geo_country)v
LEFT OUTER JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = v.geo_country
