/*
Name: Development Views By MOD as Cols
Data source: 4
Created By: Admin
Last Update At: 2015-09-11T17:03:04.581567+00:00
*/
SELECT DID.DeveloperName AS DeveloperName,
       DID.DeveloperEmail AS DeveloperEmail,
       la.address AS development,
       LA.id AS development_ID,
       Developments_Landing_Page,
       Home_Featured_Development,
       Home_Hero,
       SEARCH,
       Others,
       Social,
       TotalFromMods
FROM
  (SELECT Development,
          sum(CASE WHEN MOD = 'developments_landing_page' THEN Views ELSE integer('0') END) AS Developments_Landing_Page,
          sum(CASE WHEN MOD = 'home_featured_development' THEN Views ELSE integer('0') END) AS Home_Featured_Development,
          sum(CASE WHEN MOD = 'home_hero' THEN Views ELSE integer('0') END) AS Home_Hero,
          sum(CASE WHEN MOD = 'search' THEN Views ELSE integer('0') END) AS SEARCH,
          sum(CASE WHEN MOD = 'Others' THEN Views ELSE integer('0') END) AS Others,
          sum(CASE WHEN MOD = 'Social' THEN Views ELSE integer('0') END) AS Social,
          sum(Views) AS TotalFromMods
   FROM
     (SELECT nvl(M.DisplayName,post_prop10) AS MOD,
             v.Development,
             integer(COUNT(visit_num)) AS Views
      FROM
        (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Development,
                post_visid_high,
                post_visid_low,
                visit_num,
                post_prop10
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}')
           AND post_prop19 = 'development' /* Counting Developments */ ) v
      JOIN [djomniture:devspark.MODS] M ON post_prop10 = MOD
      GROUP BY MOD,
               v.Development)
   WHERE string(Development) = '{{devid}}'   
   GROUP BY Development
   ORDER BY 1) D /*OUTER JOIN TO ADD DEVELOPMENT ADDRESS*/

LEFT OUTER JOIN
  (SELECT id,
          address
   FROM [djomniture:devspark.MG_Development_Address]) AS LA ON D.Development = LA.id /*JOIN TO ADD VALID DEVELOPMENT ID*/
JOIN
  (SELECT string(id) AS did,
          string(developer_id) AS developer_id ,
   FROM [djomniture:devspark.MG_Developments]
   where DATE(created_at) <= DATE('{{enddate}}')) AS LID ON LA.id = LID.did
/*JOIN DEVELOPER INFORMATION*/
  JOIN
    (SELECT string(id) AS DeveloperId,
            name AS DeveloperName,
            email AS DeveloperEmail
     FROM [djomniture:devspark.MG_Developers]) AS DID ON LID.developer_id = DID.DeveloperId
