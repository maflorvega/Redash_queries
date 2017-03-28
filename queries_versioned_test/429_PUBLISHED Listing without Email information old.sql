/*
Name: PUBLISHED Listing without Email information old
Data source: 4
Created By: Admin
Last Update At: 2016-08-26T19:37:07.076712+00:00
*/
SELECT Feed_Client as Marketing_Group,
       Hierarchy_MG.Listing_ID AS Listing_ID,
       Agent,
       nvl(Agents.phone,'--') AS Phone,
FROM
  (SELECT mg_name AS Feed_Client,
          string(mg_id) AS MG_ID,
   FROM [djomniture:devspark.MG_Ingestion_Stats]
   WHERE Date(last_processed) = DATE('{{startdate}}')) AS Ingestion
JOIN EACH /*listing published for that MG*/
  (SELECT string(marketingGroup_id) AS marketingGroup_id,
          String(listing_id) AS Listing_ID,
          agent_name AS Agent
   FROM [djomniture:devspark.MG_Hierarchy_Listing]) AS Hierarchy_MG ON Hierarchy_MG.marketingGroup_id = Ingestion.MG_ID
JOIN EACH
  (SELECT string(id) AS id,
          published,
          agent_id
   FROM [djomniture:devspark.MG_Listings]
   WHERE Date(created_at)=DATE('{{startdate}}')
   and '{{status}}'!= 'Failed'
  and published is true) AS Listings_MG ON Hierarchy_MG.Listing_ID=Listings_MG.id
JOIN EACH
  (SELECT id,
          phone,
          email
   FROM [djomniture:devspark.MG_Agents]
   WHERE email IS NULL) AS Agents ON Agents.id=Listings_MG.agent_id
