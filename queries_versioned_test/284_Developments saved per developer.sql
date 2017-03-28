/*
Name: Developments saved per developer
Data source: 4
Created By: Admin
Last Update At: 2016-02-29T15:05:20.903974+00:00
*/

SELECT DID.DeveloperName as Developer,
       D.name as Development,count(*) Save_count
FROM
  (SELECT string(post_prop26) AS development_id
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "developmentSaved")
   GROUP BY development_id) s
LEFT OUTER JOIN
  (SELECT string(id) AS Development,
          name,
          string(developer_id) AS developer_id
   FROM [djomniture:devspark.MG_Developments]) AS D ON s.development_id = D.Development
LEFT OUTER JOIN
  (SELECT string(id) AS DeveloperId,
          name AS DeveloperName,
          email AS DeveloperEmail
   FROM [djomniture:devspark.MG_Developers]) AS DID ON DID.DeveloperId = D.developer_id

group by Development, Developer
order by Save_count desc
