/*
Name: Leads
Data source: 4
Created By: Admin
Last Update At: 2015-08-12T15:35:39.999730+00:00
test
*/
SELECT count(*) FROM
  (SELECT DATE(date) AS Date, Email AS Email_Address, Subject AS Subject, string(Development_id) AS Development_ID, string(Listing_id) AS Listing_ID, '' AS Name, '' AS Email, '' AS Phone, Text AS Inquiry, STATE AS Status, Tags AS Tags, Opens AS Opens, Clicks AS Clicks, '' AS Bounce_Detail
   FROM [djomniture:devspark.MG_Leads])
