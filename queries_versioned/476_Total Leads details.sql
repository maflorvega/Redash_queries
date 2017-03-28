/*
Name: Total Leads details
Data source: 4
Created By: Admin
Last Update At: 2016-11-21T20:11:56.071361+00:00
*/
SELECT Property_id,
       Agent_Developer_name,
       Address,
       Brokerage_name,
       sum(Leads) AS Leads
FROM
  (SELECT Leads.Property_id Property_id,
          HL.agent_name Agent_Developer_name,
          Leads.Leads Leads,
          HL.listing_address AS Address,
          HL.brokerage_name AS Brokerage_name
   FROM
     (SELECT nvl(listing_id,'--') AS Property_id,
           
             count(*) AS Leads
      FROM [djomniture:devspark.MG_Leads]
      WHERE DATE(date) >= DATE('{{startdate}}')
        AND DATE(date) <= DATE('{{enddate}}')
        AND (development_id IS NULL
             OR listing_id IS NOT NULL)
      GROUP BY Property_id) AS Leads
   JOIN EACH
     (SELECT listing_id,
             listing_address,
             agent_name,
             brokerage_name
      FROM[djomniture:devspark.MG_Hierarchy_Listing]) AS HL ON HL.listing_id= Leads.Property_id) ,
  (SELECT D.Property_id Property_id,
          Dev.Developer_name AS Agent_Developer_name,
          DA.address AS address,
          '--' AS Brokerage_name,
          D.Leads Leads
   FROM
     ( SELECT development_id as Property_id,
              count(*) AS Leads
      FROM [djomniture:devspark.MG_Leads]
      WHERE DATE(date) >= DATE('{{startdate}}')
        AND DATE(date) <= DATE('{{enddate}}')
        AND (development_id IS NOT NULL
             OR listing_id IS NULL)
      GROUP BY Property_id) AS D
    JOIN EACH
     (SELECT string(developer_id) as developer_id,
             string(id) AS id
      FROM[djomniture:devspark.MG_Developments]) AS HD ON HD.id= D.Property_id
   LEFT JOIN EACH
     (SELECT address,
             string(id) AS id
      FROM[djomniture:devspark.MG_Development_Address]) AS DA ON DA.id= D.Property_id
   LEFT JOIN EACH
     (SELECT name AS Developer_name,
             string(id) AS id
      FROM[djomniture:devspark.MG_Developers]) AS Dev ON Dev.id= HD.Developer_id )
GROUP BY Property_id,
         Agent_Developer_name,
         Address,
         Brokerage_name,
ORDER BY Leads DESC

/*SELECT nvl(development_id,'--') AS Development_id,
       nvl(listing_id,'--') AS Listing_id,
       contact_name as Agent_name,
        count(*) as Leads
FROM [djomniture:devspark.MG_Leads]
WHERE DATE(date) >= DATE('{{startdate}}')
  AND DATE(date) <= DATE('{{enddate}}')
  AND (development_id IS NOT NULL
       OR listing_id IS NOT NULL)

group by Development_id, Listing_id, Agent_name
order by Leads desc*/
