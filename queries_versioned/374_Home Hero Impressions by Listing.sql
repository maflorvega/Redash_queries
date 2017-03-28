/*
Name: Home Hero Impressions by Listing
Data source: 4
Created By: Admin
Last Update At: 2016-04-04T15:24:37.322158+00:00
*/
SELECT Marketing_Group,
       Brokerage,
       Branch,
       Agent,
       Listing_id,
       Listing_address + ','+STATE as Listing_address,
                             (CASE
                                  WHEN (I.Country='***') THEN '(Unknown)'
                                  WHEN (I.Country !='' AND GL.Country='') THEN I.Country ELSE GL.Country
                              END) AS ImpressionCountry,
                             Impressions, /*Clicks, (Clicks / Impressions) *100 AS CTR */
                            
FROM
  (SELECT H_Lis.marketingGroup_name AS Marketing_Group,
          H_Lis.brokerage_name AS Brokerage,
          H_Lis.branch_name AS Branch,
          H_Lis.agent_name AS Agent,
          H_Lis.listing_id AS Listing_Id,
          nvl(H_Lis.listing_address,H_Lis_address.street_address) AS Listing_address,
          MG_LA_US.Zip_code,
          MG_LA_US.City,
          H_Lis_address.zip_code,
          H_Lis_address.City,
          nvl(MG_LA_US.STATE,'') AS STATE,
          v.Country AS Country,
          Impressions,
        /*  nvl(Integer(l.Clicks),0) as Clicks,*/
          

   FROM
     (SELECT post_prop34,
             upper(geo_country) AS Country,
              count(*) AS Impressions,
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND date(date_time) >= date('2016-05-04')
        AND post_page_event='100'
        AND post_prop33 = 'MG_HomeHero_Impressions'
        AND post_prop34 = '{{listing_id}}'
     group by post_prop34,Country) v
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34
/*   LEFT JOIN
     (SELECT post_prop20 AS Listing_id,upper(geo_country) AS Country, count(*) AS Clicks,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND date(date_time) >= date('2016-05-04')
        AND post_prop10='home_hero'
     and post_page_event='0'
      and post_prop65='MG_home_home_01'
      GROUP BY Listing_id,Country) l ON (v.post_prop34 = l.Listing_id and l.Country= v.Country) */
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
   WHERE H_Lis.branch_id = '{{branch_id}}'
     AND H_Lis.brokerage_id = '{{brokerage_id}}'
     AND H_Lis.marketingGroup_id = '{{mgid}}'
     AND H_Lis.agent_id = '{{agent_id}}') I
LEFT JOIN [djomniture:devspark.Geo_Loc] AS GL ON GL.Country_code = I.Country
ORDER BY Impressions DESC
