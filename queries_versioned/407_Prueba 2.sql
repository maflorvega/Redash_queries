/*
Name: Prueba 2
Data source: 4
Created By: Admin
Last Update At: 2016-06-13T18:27:46.784366+00:00
*/
SELECT Development AS Id,
       Views,
       Visits,
       Visitors,
FROM
  (SELECT Development,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
   FROM
     (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Development,
             post_visid_high,
             post_visid_low,
             visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" /*Page View Calls*/
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND post_prop19 = 'development' /* Counting development */ ) v
   GROUP BY Development) D /*OUTER JOIN TO SELECT LEADS*/
LEFT OUTER JOIN
  (SELECT count(*) AS Leads,
          string(development_id) AS development_id
   FROM [djomniture:devspark.MG_Leads]
   WHERE DATE(date) >= DATE('{{startdate}}')
     AND DATE(date) <= DATE('{{enddate}}')
   GROUP BY development_id) AS L ON D.Development = L.development_id /*OUTER JOIN TO ADD DEVELOPMENT ADDRESS*/
LEFT OUTER JOIN
  (SELECT id,
          street_address, city, zip_code,country
   FROM [djomniture:devspark.MG_Development_Address]) AS LA ON D.Development = LA.id /*JOIN TO ADD VALID DEVELOPMENT ID*/
LEFT OUTER JOIN
  (SELECT string(id) AS did,
          string(developer_id) AS developer_id ,
   FROM [djomniture:devspark.MG_Developments]) AS LID ON D.Development = LID.did /*JOIN DEVELOPER INFORMATION*/
LEFT OUTER JOIN
  (SELECT string(id) AS DeveloperId,
          name AS DeveloperName,
          email AS DeveloperEmail
   FROM [djomniture:devspark.MG_Developers]) AS DID ON LID.developer_id = DID.DeveloperId /*OUTER JOIN TO SELECT CLICKS TO REDIRECT TO AN EXTERNAL WEBSITE GROUPED BY MGID*/
