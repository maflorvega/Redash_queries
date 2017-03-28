/*
Name: Amount of views for Listings located in US
Data source: 4
Created By: Admin
Last Update At: 2017-01-02T18:04:30.769462+00:00
*/
SELECT sum(views) as  Views,
FROM
(SELECT post_prop20 AS Listing, count(*) views
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event = "0" /*Page View Calls*/
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND post_prop19 = 'listing' /* Counting development */ 
 group by Listing
) c
 JOIN each(select * from [djomniture:devspark.MG_Listing_Address]
      where (UPPER(country)='US' or UPPER(country)='USA' or UPPER(country)='UNITED STATES'))AS MG_LA ON c.Listing = MG_LA.id
