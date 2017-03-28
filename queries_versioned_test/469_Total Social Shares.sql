/*
Name: Total Social Shares
Data source: 4
Created By: Admin
Last Update At: 2016-11-08T14:54:33.326363+00:00
*/
SELECT count (*) shares
FROM
(SELECT post_prop20 AS ListingId
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE (post_prop21 = 'Social_Click'
       OR post_prop21 = 'Email_Click')/*IT IS AN SOCIAL CLICK*/
  AND post_prop22 NOT LIKE 'MG_%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}'))c
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.ListingId = MG_HL.Listing_id

