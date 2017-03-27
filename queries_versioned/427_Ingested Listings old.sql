/*
Name: Ingested Listings old
Data source: 4
Created By: Admin
Last Update At: 2016-08-26T19:33:39.238825+00:00
*/
SELECT Feed_Client,
       MG_ID,
       Total_listings_count,
       Total_transformed_Candidates,
       (CASE
            WHEN ('{{status}}' = 'Failed') THEN 'N/A'
            ELSE STRING(Amount_of_Listings_Live)
        END) AS Listings_Live ,
       (CASE
            WHEN ('{{status}}' = 'Failed') THEN 'N/A'
            ELSE STRING(Amount_of_listings_Not_Published)
        END) AS Listings_Not_Published,
		(CASE
            WHEN ('{{status}}' = 'Failed') THEN 'N/A'
            ELSE STRING(Not_Ingested_forX_Reason)
        END) AS Not_Ingested_forX_Reason,
     
    string(STRFTIME_UTC_USEC(DATE('{{listing_table_date}}'), "%Y%m%d")) as listing_table_date,
    string(STRFTIME_UTC_USEC(DATE('{{startdate}}'), "%Y%m%d")) as startdate_date,
    '{{status}}' as Status,
    
FROM(
    SELECT Feed_Client,MG_ID,Total_listings_count,Total_transformed_Candidates,
    Amount_of_Listings_Live,Amount_of_listings_Not_Published,
    (Total_transformed_Candidates - Amount_of_Listings_Live - Amount_of_listings_Not_Published) as Not_Ingested_forX_Reason

  FROM
    (SELECT Feed_Client,
            MG_ID,
            Total_listings_count,
            Total_transformed_Candidates,
            SUM(CASE WHEN (Listings.published IS TRUE) THEN amount ELSE INTEGER(0) END) AS Amount_of_Listings_Live,
            SUM (CASE WHEN (Listings.last_published IS NULL
                            AND Listings.published IS FALSE
                            AND STRING(DATE(created_at))=DATE('{{listing_table_date}}'))THEN amount ELSE integer(0) END) AS Amount_of_listings_Not_Published,
     FROM
       (SELECT mg_name AS Feed_Client,
               string(mg_id) AS MG_ID,
               total_listings_count AS Total_listings_count,
               transformed_candidate_listings_count AS Total_transformed_Candidates,
        FROM [djomniture:devspark.MG_Ingestion_Stats]
        WHERE Date(last_processed) = DATE('{{startdate}}')) AS Ingestion
     JOIN EACH /*listing published for that MG*/
       (SELECT string(marketingGroup_id) AS marketingGroup_id,
               String(listing_id) AS Listing_ID,
               Listings.last_published,
               Listings.published,
               Listings.created_at,
               integer(count(*)) AS amount
        FROM [djomniture:devspark.MG_Hierarchy_Listing] AS Listings_MG
        JOIN EACH
          (SELECT string(id) AS id,
                  published,
                  last_published,
                  date(created_at) AS created_at
           FROM [djomniture:devspark.MG_Listings]
           WHERE master_listing_id IS NULL /*is a listing*/ ) AS Listings ON Listings_MG.Listing_ID=Listings.id
        GROUP BY marketingGroup_id,
                 Listing_ID,
                 Listings.last_published,
                 Listings.created_at,
                 Listings.published) AS Listings_MG ON Listings_MG.marketingGroup_id=Ingestion.MG_ID
     GROUP BY Feed_Client,
              MG_ID,
              Total_listings_count,
              Total_transformed_Candidates,
     ORDER BY Feed_Client))
