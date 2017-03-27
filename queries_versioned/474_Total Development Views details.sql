/*
Name: Total Development Views details
Data source: 4
Created By: Admin
Last Update At: 2016-11-21T20:07:45.774952+00:00
*/
SELECT v.Development AS Development,
       D.name AS DevelopmentName, v.Views as Views,

FROM
(SELECT post_prop20 AS Development,count(*) as Views,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event = "0" /*Page View Calls*/
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_prop19 = 'development' /* Counting development */ 
group by Development
order by Views desc) v
  JOIN
    (SELECT string(id) AS did,
            name,
            string(developer_id) AS developer_id ,
            created_at
     FROM[djomniture:devspark.MG_Developments]
     ) AS D ON D.did=v.Development

