/*
Name: Development Views By MOD
Data source: 4
Created By: Admin
Last Update At: 2015-09-11T16:28:13.735244+00:00
*/
SELECT 
	   DID.DeveloperName as DeveloperName,
       DID.DeveloperEmail as DeveloperEmail,
       la.address AS development,
       LA.id AS Id,
       ModDisplayName,
       Views,
       Visits,
       Visitors,
        nvl(integer(CLICKS.ExternalClicks),integer(0)) AS ExternalClicks
FROM
  ( SELECT Development,
           ModDisplayName,
           COUNT(visit_num) AS Views,
           COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
           COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,post_prop10,
   FROM
     (SELECT nvl(replace(M.DisplayName,'Others','developments_landing_module'),post_prop10) AS ModDisplayName,
             Development,
             post_visid_high,
             post_visid_low,
             visit_num,post_prop10
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
      JOIN [djomniture:devspark.MODS] M ON post_prop10 = MOD)
   WHERE string(Development) = '{{devid}}'   
   GROUP BY ModDisplayName,post_prop10,
            Development
   ORDER BY 1,
            2) D /*OUTER JOIN TO ADD DEVELOPMENT ADDRESS*/
 JOIN 
  (SELECT id,
          address
   FROM [djomniture:devspark.MG_Development_Address]) AS LA ON D.Development = LA.id


/*JOIN TO ADD VALID DEVELOPMENT ID*/
 JOIN  
  (SELECT string(id) AS did,
   string(developer_id) as developer_id ,
   FROM [djomniture:devspark.MG_Developments]
  where DATE(created_at) <= DATE('{{enddate}}')) AS LID ON LA.id = LID.did 



/*JOIN DEVELOPER INFORMATION*/
 JOIN  
  (SELECT string(id) AS DeveloperId,
          name AS DeveloperName,
          email as DeveloperEmail
   FROM [djomniture:devspark.MG_Developers]) AS DID ON LID.developer_id = DID.DeveloperId 

left JOIN
  (SELECT COUNT(CLICK) AS ExternalClicks,
          development_id,post_prop10
   FROM
     (SELECT 1 AS Click,
             FIRST(SPLIT(LAST(SPLIT(post_prop20, '/')), '-')) AS development_id,post_prop10
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_prop68='ExternalClick'
        and date_time >= date('2016-11-18')
        and post_prop1='development'
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')) c
   GROUP BY development_id,post_prop10) AS CLICKS ON (D.Development = CLICKS.development_id and D.post_prop10=CLICKS.post_prop10)

