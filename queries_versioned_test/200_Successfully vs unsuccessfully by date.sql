/*
Name: Successfully vs unsuccessfully by date
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T16:45:54.512203+00:00
*/
SELECT Date, v.Login_Succeed AS Login_Succeed,
             v.Authentication_errors AS Authentication_errors,
             v.FB_Login_Succeed AS FB_Login_Succeed,
             v.FB_Login_Failed AS FB_Login_Errors
FROM
  (SELECT string(STRFTIME_UTC_USEC(DATE(Date), "%m/%d/%Y")) AS Date,
          sum(CASE WHEN post_prop23 = 'User Login Succeed' THEN Logins ELSE integer('0') END) AS Login_Succeed,
          sum(CASE WHEN post_prop23 = 'User Login Failed' THEN Logins ELSE integer('0') END) AS Authentication_errors,
          sum(CASE WHEN post_prop23 = 'FB User Login Succeed' THEN Logins ELSE integer('0') END) AS FB_Login_Succeed,
          sum(CASE WHEN post_prop23 = 'FB User Login Failed' THEN Logins ELSE integer('0') END) AS FB_Login_Failed,
   FROM
     (SELECT post_prop23,
             Date(date_time) AS Date,
             integer(count(*)) AS Logins
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE (post_prop23 = 'User Login Succeed'
             OR post_prop23='User Login Failed'
             OR post_prop23='FB User Login Succeed'
             OR post_prop23= 'FB User Login Failed')
        AND post_page_event = "100"
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
      GROUP BY post_prop23, Date)v
   GROUP BY Date)
