/*
Name: Listing Ingestion Status - Old
Data source: 4
Created By: Admin
Last Update At: 2016-08-26T19:31:19.870960+00:00
*/

SELECT Listings_Ingested_For,
   Last_Modification_Listing_table,
	Status,
	
    (CASE
            WHEN (DATE(Creation_Date_Table_Listings) = current_Date() AND Current_day !=2 ) /*ingestion ok*/
      THEN 'The ingestion for '+ STRING(DATE(Listings_Ingested_For)) +' ran succesfully and the listing table on BigQuery database was updated with information taken from ' + STRING(DATE(Listings_Ingested_For))
            WHEN (DATE(Creation_Date_Table_Listings) = current_Date() AND Current_day =2 ) /*ingestion ok lunes*/
       THEN  'The ingestion for '+STRING(DATE(Listings_Ingested_For))+' ran succesfully and the listing table on BigQuery database was updated with information taken from ' + STRING(DATE(Listings_Ingested_For))
     
     		WHEN (Current_day = 1 OR Current_day=7) /*weekend*/ THEN  'There not exists information at weekend'
     		WHEN (DATE(Creation_Date_Table_Listings) != current_Date()) THEN 'The ingestion on Bigquery for ' + current_date() +' failed. For this reason the information for the previous ingestion will not be available.'
            ELSE 'Failed'
        END)AS Details,
FROM(
	SELECT 
       (CASE
            WHEN (DATE(Creation_Date_Table_Listings) = current_Date() /*Tuesday to FRIDAY*/
                  AND Current_day !=2) 
                  THEN 
                     string(STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(Date(Creation_Date_Table_Listings)),-1, "DAY")),"%Y%m%d"))
                  
            WHEN (DATE(Creation_Date_Table_Listings) = current_Date()  /*MONDAY*/
                  AND Current_day =2) 
                  THEN string(STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()),-3, "DAY")),"%Y%m%d")) /*FRIDAY*/
        	
        	WHEN (Current_day = 1 OR Current_day=7 ) /*SATURDAY OR SUNDAY*/                 
                  THEN 'No data available at weekends' 
        
             ELSE ''
        END)AS Last_Modification_Listing_table,
      (CASE
            WHEN (DATE(Creation_Date_Table_Listings) = current_Date() /*Tuesday to FRIDAY*/
                  AND Current_day !=2 ) THEN 'Success'
            WHEN (DATE(Creation_Date_Table_Listings) = current_Date() /*MONDAY*/
                  AND Current_day =2 ) THEN  'Success'
            WHEN (Current_day = 1 OR Current_day=7 ) /*SATURDAY OR SUNDAY*/                      
                  THEN 'Failed'
            ELSE 'Failed'
        END)AS Status,
		
	(CASE
            WHEN (DATE(Creation_Date_Table_Listings) = current_Date() AND Current_day !=2) /*ingestion ok tuesday to friday*/
                  THEN 
                     string(STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()),-1, "DAY")),"%Y%m%d"))
                  
            WHEN (DATE(Creation_Date_Table_Listings) = current_Date() /*ingestion ok on monday*/
                  AND Current_day =2)
                  THEN string(STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()),-3, "DAY")),"%Y%m%d"))
                  ELSE 'Error'
        END)AS Listings_Ingested_For,       
      Creation_Date_Table_Listings, Current_day
      FROM(
      SELECT DAYOFWEEK(TIMESTAMP(CURRENT_TIMESTAMP())) AS Current_day /*1 (Sunday) and 7 (Saturday), */,
             string(STRFTIME_UTC_USEC(DATE(MSEC_TO_TIMESTAMP(creation_time)), "%Y%m%d")) as Creation_Date_Table_Listings
      FROM djomniture:devspark.__TABLES__
      WHERE table_id='MG_Listings' )
)
