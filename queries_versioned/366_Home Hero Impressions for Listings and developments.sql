/*
Name: Home Hero Impressions for Listings and developments
Data source: 4
Created By: Admin
Last Update At: 2016-03-31T13:03:47.230494+00:00
*/
SELECT Property_type,   
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
        Impressions,
       Clicks,  
       STRING((Clicks / Impressions)*100) as CTR


FROM(
SELECT 'Listing' AS Property_type,
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
       nvl(MG_LA_US.STATE,'') AS STATE,
       count(*) AS Impressions,
       nvl(Integer(L.Clicks),0) as Clicks,
FROM
  (SELECT post_prop34
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) >= date('2016-05-04')
     AND post_prop35 ='' /*is a listing*/
   and post_page_event='100'
     AND post_prop33 = 'MG_HomeHero_Impressions') v
 JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34
 left JOIN
  (SELECT post_prop20 AS Listing_id,
          count(*) AS Clicks,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) >= date('2016-05-04')
     AND post_prop10='home_hero'
   and post_page_event='0'
         and post_prop65='MG_home_home_01'
   GROUP BY Listing_id) l ON v.post_prop34 = l.Listing_id
  
 LEFT  JOIN
     (SELECT address,
             ID,
             upper(city) AS City,
             street_address,
             zip_code
      FROM [djomniture:devspark.MG_Listing_Address]) AS H_Lis_address ON v.post_prop34 = H_Lis_address.id
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
         Address,Clicks,STATE
ORDER BY Clicks DESC),
(SELECT 'Development' AS Property_type,
          Property_id AS Development_Id,
          DID.DeveloperName AS DeveloperName,
          LID.Name AS DevelopmentName,
          la.address AS Address,nvl(MG_LA_US.STATE,'') AS STATE,
          count(*) AS Impressions,
          nvl(Integer(l.Clicks),0) as Clicks
   FROM
     (SELECT post_prop35 AS Property_id,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND date(date_time) >= date('2016-05-04')
        AND post_prop35 !=''
      and post_page_event='100'
        AND post_prop33 = 'MG_HomeHero_Impressions') D
 
 LEFT JOIN
  (SELECT post_prop20 as development_id,
          count(*) AS Clicks,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND date(date_time) >= date('2016-05-04')
     AND post_prop10='home_hero'
         and post_prop65='MG_home_home_01'
   and post_page_event='0'
   GROUP BY development_id) l ON l.development_id = D.Property_id
 JOIN
     (SELECT string(id) AS did,
             name,
             string(developer_id) AS developer_id ,
      FROM [djomniture:devspark.MG_Developments]) AS LID ON D.Property_id = LID.did /*JOIN DEVELOPER INFORMATION*/
 
   LEFT  JOIN
     (SELECT id,upper(city) AS City,
             address,zip_code,
      FROM [djomniture:devspark.MG_Development_Address]) AS LA ON D.Property_id = LA.id /*JOIN TO ADD VALID DEVELOPMENT ID*/
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
            DevelopmentName,Clicks,
            STATE)

order by Impressions desc
