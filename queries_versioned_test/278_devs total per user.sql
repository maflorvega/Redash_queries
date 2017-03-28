/*
Name: devs total per user
Data source: 4
Created By: Admin
Last Update At: 2016-02-24T20:08:35.326349+00:00
*/

SELECT post_prop24,
       D.name AS Development,
       DID.DeveloperName as Developer,
FROM
  (SELECT 
           string(post_prop26) AS development_id,post_prop24,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "developmentSaved") 
  group by development_id,post_prop24) s
LEFT OUTER JOIN
  (SELECT string(id) AS Development,
          name,
          string(developer_id) AS developer_id
   FROM [djomniture:devspark.MG_Developments]) AS D ON s.development_id = D.Development
left outer JOIN
  (SELECT string(id) AS DeveloperId,
          name AS DeveloperName,
          email AS DeveloperEmail
   FROM [djomniture:devspark.MG_Developers]) AS DID ON DID.DeveloperId = D.developer_id

