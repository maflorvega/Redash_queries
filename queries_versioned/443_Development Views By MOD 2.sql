/*
Name: Development Views By MOD 2
Data source: 4
Created By: Admin
Last Update At: 2016-09-16T19:38:30.168099+00:00
*/
SELECT 
	   DID.DeveloperName as DeveloperName,
       DID.DeveloperEmail as DeveloperEmail,
       la.address AS development,
       LA.id AS Id,
       ModDisplayName,
       Views,
       Visits,
       Visitors
FROM
  ( SELECT Development,
           ModDisplayName,
           COUNT(visit_num) AS Views,
           COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
           COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT nvl(replace(M.DisplayName,'Others','developments_landing_module'),post_prop10) AS ModDisplayName,
             Development,
             post_visid_high,
             post_visid_low,
             visit_num
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
  left    JOIN [djomniture:devspark.MODS] M ON post_prop10 = MOD)
   WHERE string(Development) = '{{devid}}'   
   GROUP BY ModDisplayName,
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
   FROM [djomniture:devspark.MG_Developments]) AS LID ON LA.id = LID.did 



/*JOIN DEVELOPER INFORMATION*/
 JOIN  
  (SELECT string(id) AS DeveloperId,
          name AS DeveloperName,
          email as DeveloperEmail
   FROM [djomniture:devspark.MG_Developers]) AS DID ON LID.developer_id = DID.DeveloperId 
