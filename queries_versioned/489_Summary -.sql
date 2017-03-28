/*
Name: Summary -
Data source: 4
Created By: Admin
Last Update At: 2016-12-15T17:03:56.901278+00:00
*/
select * 
FROM
(SELECT 'Total Listing Views' as Reports ,COUNT(*) AS Total,
FROM
  (SELECT post_prop20 AS Listing
   /*Listing properties per listing*/
    FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PageView Calls*/
     AND post_prop19 = 'listing' /* Counting Listings */
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}') )c
/*List of valid listings (active/no active)*/
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id)
,
(SELECT 'Total Development Views' as Reports, count(*) AS Total
FROM
  (SELECT post_prop20 AS Development,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*Page View Calls*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop19 = 'development' /* Counting development */ ) v
JOIN
  (SELECT string(id) AS did
   FROM[djomniture:devspark.MG_Developments]) AS D ON D.did=v.Development)
,
(SELECT 'Total Listing Views through article body' as Reports, COUNT(*) AS Total,
FROM
  (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing
   /*Listing properties per listing*/
    FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PageView Calls*/
     AND post_prop19 = 'listing' /* Counting Listings */
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}') 
     and post_prop10 = 'article_body' 
  )c
/*List of valid listings (active/no active)*/
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id)
,
(SELECT 'Total Leads' as Reports,count(*) AS Total
FROM [djomniture:devspark.MG_Leads]
WHERE DATE(date) >= DATE('{{startdate}}')
  AND DATE(date) <= DATE('{{enddate}}')
  AND (development_id IS NOT NULL
       OR listing_id IS NOT NULL))
,
(SELECT 'Total Social Shares' as Reports, count (*) Total
FROM
(SELECT post_prop20 AS ListingId
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE (post_prop21 = 'Social_Click'
       OR post_prop21 = 'Email_Click')/*IT IS AN SOCIAL CLICK*/
  AND post_prop22 NOT LIKE 'MG_%'
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}'))c
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.ListingId = MG_HL.Listing_id)
,
(SELECT 'Amount of total external Clicks' as Reports, count(*) AS Total
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='listing' or post_prop1='development' or post_prop1='article')
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
)
,
(SELECT 'Amount of external clicks for listings' as Reports, count(*) AS Total
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='listing')
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}'))
,
(SELECT 'Amount of external clicks for developments' as Reports, count(*) AS Total
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='development')
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}'))
,
(SELECT 'Amount of external clicks for Berkshire Widget' as Reports, count(*) AS Total
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_prop68='ExternalClick'
  AND date_time >= date('2016-11-18')
  AND (post_prop1='article')
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}'))
,
(SELECT 'Total Searches' as Reports, count(*) AS Total
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
WHERE post_page_event = "0" /* Pageview Calls*/
  AND DATE(date_time) >= DATE('{{startdate}}')
  AND DATE(date_time) <= DATE('{{enddate}}')
  AND page_url LIKE '%/search%'
  AND page_url LIKE '%5Bformatted_address%')
,
(
SELECT 'Total listings that were live' as Reports,count(*) AS Total
FROM
  (SELECT string(id) as id
   FROM [djomniture:devspark.MG_All_Listings]
   WHERE (DATE(created_at) <= DATE('{{enddate}}')
          AND DATE(deleted_at) IS NULL) /*active listings*/
     OR (DATE(deleted_at) >= Date('{{startdate}}')
         AND DATE(deleted_at) <= Date('{{enddate}}'))
   GROUP BY id))
,


 
 (SELECT 'Amount of views for Listings located in US' as Reports,sum(views) as  Total,
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
      where (UPPER(country)='US' or UPPER(country)='USA' or UPPER(country)='UNITED STATES'))AS MG_LA ON c.Listing = MG_LA.id)



