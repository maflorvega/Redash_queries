/*
Name: Login errors by Category
Data source: 4
Created By: Admin
Last Update At: 2016-09-01T13:35:05.090204+00:00
*/
SELECT nvl(LE.Category, v.Error) AS Category_error,
       REGEXP_REPLACE(nvl(LE.Category, v.Error), r'\s+', '_') as Category_parameter,
       count(*) AS Logins
FROM
  (SELECT post_prop28,
          nvl(REGEXP_EXTRACT(post_prop28,r'^.*\|(.*)$'),'Error Not Defined') as Error,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop23 = 'User Login Failed')
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
    AND DATE(date_time) >= DATE('2016-07-26')
     AND post_page_event = "100") AS v
LEFT  JOIN [djomniture:devspark.MG_ACS_Errors] AS LE ON LE.Message = v.Error
GROUP BY Category_error,Category_parameter
ORDER BY Logins DESC

