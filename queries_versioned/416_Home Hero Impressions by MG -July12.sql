/*
Name: Home Hero Impressions by MG -July12
Data source: 4
Created By: Admin
Last Update At: 2016-07-12T18:16:53.975721+00:00
*/
SELECT Marketing_Group,
       Agent,
       Listing_id,
       Listing_address + ','+STATE as Listing_address,
       Impressions,
      /* Clicks,
       (Clicks / Impressions) AS CTR*/
FROM
  (SELECT H_Lis.marketingGroup_name AS Marketing_Group,
          nvl(H_Lis.agent_name,"--") AS Agent,
          v.post_prop34 AS Listing_id,
          nvl(H_Lis.listing_address,H_Lis_address.street_address) AS Listing_address,
   			nvl(MG_LA_US.STATE,'') AS STATE,
          count(*) AS Impressions,
        /*  nvl(Integer(L.Clicks),0) AS Clicks,*/
   FROM
     (SELECT post_prop34,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND date(date_time) >= date('2016-05-04')
      and post_page_event='100'
        AND post_prop33 = 'MG_HomeHero_Impressions') v
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS H_Lis ON H_Lis.listing_id = v.post_prop34
 /*  LEFT JOIN
     (SELECT post_prop20 AS Listing_id,
             count(*) AS Clicks,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "	month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('{{startdate}}')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('{{enddate}}')) "))
      WHERE DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND date(date_time) >= date('2016-05-04')
        AND post_prop10='home_hero'
      and post_page_event='0'
      and post_prop65='MG_home_home_01'
      GROUP BY Listing_id) l ON v.post_prop34 = l.Listing_id*/
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
   WHERE H_Lis.marketingGroup_id = '{{mgid}}'
GROUP BY Marketing_Group,
         Agent,
         Listing_id,
         Listing_address,
        /* Clicks*/
  STATE)
ORDER BY Impressions DESC

