/*
Name: Properties by States
Data source: 4
Created By: Admin
Last Update At: 2016-04-12T13:42:57.249527+00:00
*/
SELECT nvl(MG_LA_US.State_Abbreviation,'None') AS STATE,
       count(*) AS Clicks,
FROM
  (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_prop10= 'berkshire_hathaway_widget'
     AND post_prop72 = ''
     AND post_page_event='0'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) >= DATE('2016-02-01')
     AND DATE(date_time) <= DATE('{{enddate}}'))v
LEFT JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON v.Listing = MG_HL.listing_id
LEFT JOIN
  (SELECT id,
          upper(city) AS city,
          zip_code,
   FROM [djomniture:devspark.MG_Listing_Address]) AS MG_LA ON v.Listing = MG_LA.id
LEFT JOIN
  (SELECT Zip_code,
          upper(City) AS City,
          State_Abbreviation,
   FROM[djomniture:devspark.MG_USA_States])AS MG_LA_US ON (MG_LA.zip_code = MG_LA_US.Zip_code
                                                           AND MG_LA.city = MG_LA_US.City)
GROUP BY STATE
ORDER BY Clicks DESC
