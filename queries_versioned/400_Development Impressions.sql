/*
Name: Development Impressions
Data source: 4
Created By: Admin
Last Update At: 2016-05-11T15:34:30.883351+00:00
*/

  (SELECT 'Development' AS Property_type,
          Property_id,
          DID.DeveloperName AS DeveloperName,
          la.street_address AS Address,
          count(*) AS Impressions
   FROM
     (SELECT post_prop35 AS Property_id,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND date(date_time) >= date('2016-05-04')
        AND post_prop35 !=''
        AND post_prop33 = 'MG_HomeHero_Impressions'
) D
   LEFT OUTER JOIN
     (SELECT id,
             street_address,
      FROM [djomniture:devspark.MG_Development_Address]) AS LA ON D.Property_id = LA.id /*JOIN TO ADD VALID DEVELOPMENT ID*/
   JOIN
     (SELECT string(id) AS did,
             string(developer_id) AS developer_id ,
      FROM [djomniture:devspark.MG_Developments]) AS LID ON D.Property_id = LID.did /*JOIN DEVELOPER INFORMATION*/
   JOIN
     (SELECT string(id) AS DeveloperId,
             name AS DeveloperName,
      FROM [djomniture:devspark.MG_Developers]) AS DID ON LID.developer_id = DID.DeveloperId
   GROUP BY Property_type,Property_id, DeveloperName, Address, )
