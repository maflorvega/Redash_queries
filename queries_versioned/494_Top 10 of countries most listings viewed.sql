/*
Name: Top 10 of countries most listings viewed
Data source: 4
Created By: Admin
Last Update At: 2017-01-06T15:50:22.674442+00:00
*/
select  Country,Views, SUBSTRING(STRING((Views / Total)*100),1,6) as Percentage
from ( 
  select '1' as col, Country,Views,sum(Views) OVER (order by col) as Total from (

SELECT countryname AS Country,
       sum(Views) AS Views,
       
FROM
  (SELECT COUNTRIES1.countryname AS countryname,
          count(*) AS Views
   FROM
     (SELECT post_prop20 AS Listing,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" /*Page View Calls*/
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND post_prop19 = 'listing') c
   JOIN
     (SELECT upper(country) AS country,
             id
      FROM [djomniture:devspark.MG_Listing_Address] )AS MG_LA ON c.Listing = MG_LA.id
   JOIN
     (SELECT upper(cou) AS countryname
      FROM [djomniture:devspark.country]) AS COUNTRIES1 ON (COUNTRIES1.countryname = MG_LA.country)
   GROUP BY countryname),
  (SELECT COUNTRIES2.countryname AS countryname,
          count(*) AS Views
   FROM
     (SELECT post_prop20 AS Listing,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" /*Page View Calls*/
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND post_prop19 = 'listing') c
   JOIN
     (SELECT upper(country) AS country,
             id
      FROM [djomniture:devspark.MG_Listing_Address] )AS MG_LA ON c.Listing = MG_LA.id
   JOIN
     (SELECT upper(codigodos)AS codigodos,
             upper(cou) AS countryname
      FROM[djomniture:devspark.country]) AS COUNTRIES2 ON (MG_LA.country=COUNTRIES2.codigodos)
   GROUP BY countryname) ,
  (SELECT COUNTRIES3.countryname AS countryname,
          count(*) AS Views
   FROM
     (SELECT post_prop20 AS Listing,
             
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
      WHERE post_page_event = "0" /*Page View Calls*/
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')
        AND post_prop19 = 'listing') c
   JOIN
     (SELECT upper(country) AS country,
             id
      FROM [djomniture:devspark.MG_Listing_Address] )AS MG_LA ON c.Listing = MG_LA.id
   JOIN
     (SELECT upper(codigotres) AS codigotres,
             upper(cou) AS countryname
      FROM[djomniture:devspark.country]) AS COUNTRIES3 ON (MG_LA.country=COUNTRIES3.codigotres)
   GROUP BY countryname)
GROUP BY Country
) order by Views desc
  )
limit 10
