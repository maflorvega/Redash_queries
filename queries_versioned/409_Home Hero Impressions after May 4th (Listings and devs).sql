/*
Name: Home Hero Impressions after May 4th (Listings and devs)
Data source: 4
Created By: Admin
Last Update At: 2016-06-16T16:25:16.825345+00:00
*/
SELECT     Property_type,   
       nvl(Marketing_Group,'--')Marketing_Group,
       nvl(Marketing_Group_id,'--')Marketing_Group_id,
       nvl(Brokerage,'--')Brokerage,
       nvl(Brokerage_id,'--')Brokerage_id,
       nvl(Branch,'--')Branch,
       nvl(Branch_id,'--')Branch_id,
       nvl(Agent,'--')Agent,
       nvl(Agent_id,'--')Agent_id,
       nvl(Listing_id,'--')Listing_id,
       nvl(Development_id,'--') Development_id,
       nvl(DevelopmentName,'--')DevelopmentName,
       nvl(DeveloperName,'--')DeveloperName,
       Address,Impressions,

FROM
  (SELECT 'Listing' AS Property_type,
          nvl(v.post_prop34,"--") AS Listing_id,
          nvl(H_Lis.marketingGroup_name,'--') AS Marketing_Group,
          nvl(H_Lis.marketingGroup_id,"--") AS Marketing_Group_id,
          nvl(H_Lis.brokerage_name,"--") AS Brokerage,
          nvl(H_Lis.brokerage_id,"--") AS Brokerage_id,
          nvl(H_Lis.branch_name,"--") AS Branch,
          nvl(H_Lis.branch_id,"--") AS Branch_id,
          nvl(H_Lis.agent_name,"--") AS Agent,
          nvl(H_Lis.agent_id,"--") AS Agent_id,
          nvl(H_Lis.listing_address,H_Lis_address.street_address) AS Address,
          count(*) AS Impressions
   FROM
     (SELECT post_prop34
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND date(date_time) >= date('2016-05-04')
        AND post_prop35 ='' /*is a listing*/
        AND post_prop33 = 'MG_HomeHero_Impressions') v
    JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34
   LEFT JOIN [djomniture:devspark.MG_Listing_Address] AS H_Lis_address ON v.post_prop34 = H_Lis_address.id
   GROUP BY Property_type,
            Listing_id,
            Marketing_Group,
            Marketing_Group_id,
            Brokerage,
            Brokerage_id,
            Branch,
            Branch_id,
            Agent,
            Agent_id,
            Address
   ORDER BY Impressions DESC),
  (SELECT 'Development' AS Property_type,
          Property_id AS Development_Id,
          DID.DeveloperName AS DeveloperName,
          LID.Name AS DevelopmentName,
          la.street_address AS Address,
          count(*) AS Impressions
   FROM
     (SELECT post_prop35 AS Property_id,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND date(date_time) >= date('2016-05-04')
        AND post_prop35 !=''
        AND post_prop33 = 'MG_HomeHero_Impressions') D
   LEFT OUTER JOIN
     (SELECT id,
             street_address,
      FROM [djomniture:devspark.MG_Development_Address]) AS LA ON D.Property_id = LA.id /*JOIN TO ADD VALID DEVELOPMENT ID*/
   JOIN
     (SELECT string(id) AS did,
             name,
             string(developer_id) AS developer_id ,
      FROM [djomniture:devspark.MG_Developments]) AS LID ON D.Property_id = LID.did /*JOIN DEVELOPER INFORMATION*/
   JOIN
     (SELECT string(id) AS DeveloperId,
             name AS DeveloperName,
      FROM [djomniture:devspark.MG_Developers]) AS DID ON LID.developer_id = DID.DeveloperId
   GROUP BY Property_type,
            Development_Id,
            DeveloperName,
            Address,
            DevelopmentName)


order by Impressions desc
