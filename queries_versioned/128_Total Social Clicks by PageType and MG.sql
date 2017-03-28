/*
Name: Total Social Clicks by PageType and MG
Data source: 4
Created By: Admin
Last Update At: 2015-12-21T14:47:30.029037+00:00
*/
SELECT /*MG_HL.marketingGroup_id AS MarketingGroup,*/
/*geo_city,geo_country,,post_prop21,post_prop22*/
       MG_HL.marketingGroup_name AS MarketingGroup,
	   PageType,
       SocialNetwork,
       COUNT(ListingId) as Clicks
FROM
  (SELECT 
   		post_prop1  AS PageType, 
   		post_prop20 AS ListingId,
   		post_prop22 AS SocialNetwork
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop21 = 'Social_Click'/*IT IS AN SOCIAL CLICK*/
     AND post_prop22 not like 'MG_%'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')) c
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.ListingId = MG_HL.Listing_id
GROUP BY MarketingGroup,PageType,SocialNetwork
order by Clicks desc
