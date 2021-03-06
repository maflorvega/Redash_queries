/*
Name: Total Social Clicks by Country
Data source: 4
Created By: Admin
Last Update At: 2015-12-22T18:55:35.695452+00:00
*/
SELECT Geo.Country as Country,
       SocialNetwork,
       COUNT(ListingId) as Clicks
FROM
  (SELECT geo_city,UPPER(geo_country) as geo_country,
   		post_prop20 AS ListingId,
   		post_prop22 AS SocialNetwork
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop21 = 'Social_Click' or post_prop21 = 'Email_Click')/*IT IS AN SOCIAL CLICK*/
     AND post_prop22 not like 'MG_%'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')) c
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.ListingId = MG_HL.Listing_id
JOIN [djomniture:devspark.Geo_Loc] as GEO on c.geo_country = GEO.Country_code
GROUP BY Country,SocialNetwork
order by Clicks desc
