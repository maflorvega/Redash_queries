/*
Name: Successfully vs unsuccessfully user logins
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T15:53:34.787770+00:00
*/
SELECT sum(CASE WHEN post_prop23 = 'User Login Succeed' THEN Logins ELSE integer('0') END) AS Login_Succeed,
       sum(CASE WHEN post_prop23 = 'User Login Failed' THEN Logins ELSE integer('0') END) AS Authentication_errors,
       sum(CASE WHEN post_prop23 = 'FB User Login Succeed' THEN Logins ELSE integer('0') END) AS FBUser_Login_Succeed,
       sum(CASE WHEN post_prop23 = 'FB User Login Failed' THEN Logins ELSE integer('0') END) AS FBUser_Login_Errors,
FROM
  (SELECT post_prop23,
          integer(count(*)) AS Logins
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop23 = 'User Login Succeed'
          OR post_prop23='User Login Failed'
          OR post_prop23='FB User Login Succeed'
          OR post_prop23= 'FB User Login Failed')
     AND post_page_event = "100"
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND DATE('{{startdate}}') >= DATE('2015-11-02')
   GROUP BY post_prop23)
