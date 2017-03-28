/*
Name: Ingestion Status
Data source: 4
Created By: Admin
Last Update At: 2016-10-18T18:22:24.027763+00:00
*/
SELECT nvl(string(STRFTIME_UTC_USEC(Listings_date_creation, "%Y%m%d")),"") AS Listings_date_creation,
       Status,
       Details,
FROM
  (SELECT (CASE WHEN (DAYOFWEEK(TIMESTAMP(Date('{{startdate}}')))) = 1
           OR (DAYOFWEEK(TIMESTAMP(Date('{{startdate}}'))))=7
           OR (Date('{{startdate}}') = DATE(CURRENT_DATE())) THEN Date('{{startdate}}') END) AS Listings_date_creation,
          (CASE WHEN (DAYOFWEEK(TIMESTAMP(Date('{{startdate}}')))) = 1
           OR (DAYOFWEEK(TIMESTAMP(Date('{{startdate}}'))))=7 /*weekend*/
           OR (Date('{{startdate}}') = DATE(CURRENT_DATE())) THEN 'None' END) AS Status,
          (CASE WHEN (Date('{{startdate}}') < date('2016-10-12')) THEN 'There not exits information available before October 12th' WHEN (DAYOFWEEK(TIMESTAMP(Date('{{startdate}}')))) = 1
           OR (DAYOFWEEK(TIMESTAMP(Date('{{startdate}}'))))=7 /*weekend*/ THEN 'There not exists ingestion at weekend' WHEN (Date('{{startdate}}') = DATE(CURRENT_DATE())) THEN 'The information for today ingestion are going to be available from tomorrow' END) AS Details),
  (SELECT Listings_date_creation,
          (CASE WHEN (Status == 'Success') /*ingestion ok*/ THEN 'The ingestion for '+ STRING(DATE('{{startdate}}')) +' ran succesfully and the listing table on BigQuery database was updated with information taken from ' + STRING(DATE('{{startdate}}')) ELSE 'The ingestion on Bigquery for ' + '{{startdate}}' +' failed. For this reason the information for the previous ingestion will not be available.' END)AS Details,
   FROM [djomniture:devspark.Datablade_Ingestion_Status]
   WHERE DATE(Listings_date_creation) = Date('{{startdate}}')
   GROUP BY Listings_date_creation,
            Status,
            Details)
