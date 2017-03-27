/*
Name: Top Markets for Listings and developments
Data source: 4
Created By: Admin
Last Update At: 2016-09-08T14:19:18.713952+00:00
*/
SELECT Property_type,   
       Top_Market, 
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
        Address + ','+STATE as Property_Address,
		Views


FROM(
SELECT 'Listing' AS Property_type,
       nvl(v.post_prop20,"--") AS Listing_id, 
       VM.DisplayName as Top_Market,
       nvl(H_Lis.marketingGroup_name,'--') AS Marketing_Group,
       nvl(H_Lis.marketingGroup_id,"--") AS Marketing_Group_id,
       nvl(H_Lis.brokerage_name,"--") AS Brokerage,
       nvl(H_Lis.brokerage_id,"--") AS Brokerage_id,
       nvl(H_Lis.branch_name,"--") AS Branch,
       nvl(H_Lis.branch_id,"--") AS Branch_id,
       nvl(H_Lis.agent_name,"--") AS Agent,
       nvl(H_Lis.agent_id,"--") AS Agent_id,
       nvl(H_Lis.listing_address,H_Lis_address.street_address) AS Address,
       nvl(MG_LA_US.STATE,'') AS STATE,
       count(*) AS Views,
     
FROM
  (SELECT post_prop20, post_prop10 as Top_Market,
   /*FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))*/
     FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     and post_prop1 ='listing'  
     ) v
  JOIN
  (SELECT MOD,
          DisplayName
   FROM [djomniture:devspark.MODS]
   WHERE DisplayName='{{top_market}}') AS VM ON v.Top_Market= VM.MOD
  JOIN (select string(id) as id from [djomniture:devspark.MG_All_Listings]
       where DATE(created_at) <= DATE('{{enddate}}')) AS Lis ON Lis.id = v.post_prop20
  JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop20

  
 
 LEFT  JOIN
     (SELECT address,
             ID,
             upper(city) AS City,
             street_address,
             zip_code
      FROM [djomniture:devspark.MG_Listing_Address]) AS H_Lis_address ON v.post_prop20 = H_Lis_address.id
   LEFT JOIN
     (SELECT Zip_code,
             upper(City) AS City,
             STATE,
             State_Abbreviation
      FROM[djomniture:devspark.MG_USA_States])AS MG_LA_US ON (H_Lis_address.zip_code = MG_LA_US.Zip_code
                                                              AND H_Lis_address.City = MG_LA_US.City)
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
         Address, Top_Market,
  STATE
ORDER BY Views DESC),
(SELECT 'Development' AS Property_type,
          Property_id AS Development_Id,
          DID.DeveloperName AS DeveloperName,
          LID.Name AS DevelopmentName, VM.DisplayName as Top_Market,
          la.address AS Address,nvl(MG_LA_US.STATE,'') AS STATE,
          count(*) AS Views,       
   FROM
     (SELECT post_prop20 AS Property_id,post_prop10 as Top_Market,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        and post_prop1='development'
     
      ) Dev
  JOIN (SELECT MOD,
          DisplayName
   FROM [djomniture:devspark.MODS]
   WHERE DisplayName='{{top_market}}') AS VM ON Dev.Top_Market= VM.MOD
 JOIN
     (SELECT string(id) AS did,
             name,
             string(developer_id) AS developer_id ,
      FROM [djomniture:devspark.MG_Developments]
      where DATE(created_at) <= DATE('{{enddate}}')
     ) AS LID ON Dev.Property_id = LID.did /*JOIN DEVELOPER INFORMATION*/
 
   LEFT  JOIN
     (SELECT id,upper(city) AS City,
             address,zip_code,
      FROM [djomniture:devspark.MG_Development_Address]) AS LA ON Dev.Property_id = LA.id /*JOIN TO ADD VALID DEVELOPMENT ID*/
   LEFT JOIN
     (SELECT Zip_code,
             upper(City) AS City,
             STATE,
             State_Abbreviation
      FROM[djomniture:devspark.MG_USA_States])AS MG_LA_US ON (LA.zip_code = MG_LA_US.Zip_code
                                                              AND LA.City = MG_LA_US.City)
   left JOIN
     (SELECT string(id) AS DeveloperId,
             name AS DeveloperName,
      FROM [djomniture:devspark.MG_Developers]) AS DID ON LID.developer_id = DID.DeveloperId
   GROUP BY Property_type,
            Development_Id,
            DeveloperName,
            Address,
            DevelopmentName,Top_Market,
            STATE)
order by Views desc
 


