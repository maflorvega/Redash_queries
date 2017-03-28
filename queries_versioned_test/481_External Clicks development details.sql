/*
Name: External Clicks development details
Data source: 4
Created By: Admin
Last Update At: 2016-12-05T17:46:55.176581+00:00
*/
SELECT v.ID as Development_ID,
       D.name as DevelopmentName, 
       D.developer_id as Developer_id,
       X.address AS Address,
v.ExternalClicks as ExternalClicks
FROM
(SELECT post_prop19 AS Property_Type,
       nvl(post_prop20,'--') AS ID,
       /*contact_name as Agent_name,*/
        count(*) as ExternalClicks
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE (post_prop72 IS NOT NULL
                AND post_prop68 = 'ExternalClick'
                AND DATE(date_time) >= DATE('{{startdate}}')
                AND DATE(date_time) >= '2016-11-18'
                AND post_prop1 = 'development'
                AND DATE(date_time) <= DATE('{{enddate}}'))
group by Property_Type,ID
order by ExternalClicks desc) v
 JOIN
    (SELECT string(id) AS did,
            name,
            string(developer_id) AS developer_id ,
            created_at
     FROM[djomniture:devspark.MG_Developments]
     ) AS D ON D.did=v.ID
left JOIN (SELECT address, id
     FROM[djomniture:devspark.MG_Development_Address]) AS X ON X.id=v.ID

