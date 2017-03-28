/*
Name: Login by Type of Errors
Data source: 4
Created By: Admin
Last Update At: 2016-08-11T14:41:17.230387+00:00
*/
SELECT nvl(Message_Error, Error_code) AS Type_of_Error,
       nvl(Category_error, Error_code) AS Category_error,

       count(*) AS Logins
FROM(
  select  v.post_prop28 as post_prop28,v.Message_Error as Message_Error, nvl(LEO.Category,v.Message_Error) AS Category_error,v.date_time as date_time, v.Error_code as Error_code
  from
  (SELECT post_prop28,
          date_time,
          nvl(REGEXP_EXTRACT(post_prop28,r'^.*\|(.*)$'),'Error Not Defined') AS Message_Error,
   			nvl(upper(REGEXP_EXTRACT(post_prop28,r'(.*)\|')),'Error Not Define') AS Error_code,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop23 = 'User Login Failed')
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND DATE(date_time) >= DATE('2016-07-26')
     AND post_page_event = "100") AS v
  left JOIN each (select Message, nvl(Category,Message) as Category from [djomniture:devspark.MG_ACS_Errors]
        ) AS LEO ON LEO.Message = v.Message_Error
      WHERE DATE(v.date_time) < DATE('2016-09-01') 
		and (REGEXP_REPLACE(Category, r'\s+', '_') ='{{category}}' )),

(SELECT  F.post_prop28 as post_prop28,F.Error_code as Error_code, 
 	     F.Message_Error as Message_Error, 
         nvl(LEN.Category,F.Message_Error) AS Category_error,
         F.date_time as date_time
  FROM(
  SELECT post_prop28,
            date_time,
            nvl(upper(REGEXP_EXTRACT(post_prop28,r'(.*)\|')),'Error Not Define') AS Error_code,
     nvl(REGEXP_EXTRACT(post_prop28,r'^.*\|(.*)$'),'Error Not Defined') AS Message_Error,
     FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
     WHERE (post_prop23 = 'User Login Failed')
       AND DATE(date_time) >= DATE('{{startdate}}')
       AND DATE(date_time) <= DATE('{{enddate}}')
       AND DATE(date_time) >= DATE('2016-07-26')
       and REGEXP_EXTRACT(post_prop28,r'(.*)\|') !='FE'
       AND post_page_event = "100") AS F
    left JOIN each (select upper(Error_code) as Error_code, Message, nvl(Category,Message) as Category FROM [djomniture:devspark.MG_ACS_Errors]) 
   AS LEN ON LEN.Error_code = F.Error_code 
  WHERE DATE(F.date_time) >= DATE('2016-09-01')
   and (REGEXP_REPLACE(Category, r'\s+', '_') ='{{category}}' ))

group by Category_error,Type_of_Error,
order by Logins desc

