/*
Name: Total Social Clicks by SocialNetwork 2
Data source: 4
Created By: Admin
Last Update At: 2016-11-02T18:48:21.848013+00:00
*/
SELECT SocialNetwork,
       COUNT(ListingId) as Clicks
FROM
  (SELECT post_prop20 AS ListingId,
          post_prop22 AS SocialNetwork
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE (post_prop21 = 'Social_Click' or post_prop21 = 'Email_Click')/*IT IS AN SOCIAL CLICK*/
     AND post_prop22 not like 'MG_%'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')) c
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.ListingId = MG_HL.Listing_id
GROUP BY SocialNetwork
order by Clicks desc
