/*
Name: External Clicks listing details
Data source: 4
Created By: Admin
Last Update At: 2016-12-05T17:44:44.368632+00:00
*/
SELECT v.ID AS Listing_ID,
		X.street_address +','+ X.city+','+X.zip_code  + X.country Listing_address,   
       D.Agent_name AS Agent_name,
brokerage_name as Brokerage,
       sum(v.ExternalClicks) AS ExternalClicks
FROM
  (SELECT post_prop19 AS Property_Type,
          nvl(post_prop20,'--') AS ID,
          count(*) AS ExternalClicks
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop72 IS NOT NULL
          AND post_prop68 = 'ExternalClick'
          AND DATE(date_time) >= DATE('{{startdate}}')
          AND DATE(date_time) >= '2016-11-18'
          AND post_prop1 = 'listing'
          AND DATE(date_time) <= DATE('{{enddate}}'))
   GROUP BY Property_Type,
            ID) v
left JOIN EACH
  (SELECT listing_id AS did,agent_name as agent_name,          
          listing_address,brokerage_name
   FROM[djomniture:devspark.MG_Hierarchy_Listing] ) AS D ON D.did=v.ID
left JOIN
  (SELECT address,
          id,country, city,zip_code,
          street_address
   FROM[djomniture:devspark.MG_Listing_Address]) AS X ON X.id=v.ID
group by Listing_ID, Listing_address, Agent_name, Brokerage
ORDER BY ExternalClicks DESC
