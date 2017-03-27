/*
Name: sdddd
Data source: 4
Created By: Admin
Last Update At: 2017-01-30T18:23:50.645351+00:00
*/
SELECT STRFTIME_UTC_USEC(LV.Date,"%Y%m%d") as Date,
       LV.ListingViews ListingViews,
       DV.DevelopmentViews DevelopmentViews,
       LVA.ListingViewsThroughArticleBody ListingViewsThroughArticleBody,
       TL.TotalLeads TotalLeads,
       TSS.TotalSocialShares TotalSocialShares,
       TEC.TotalExternalClicks TotalExternalClicks,
       ECL.ExternalClicksListings ExternalClicksListings,
       ECD.ExternalClicksDevelopments ExternalClicksDevelopments,
       ECB.ExternalClicksBerkshireWidget ExternalClicksBerkshireWidget,
       TS.TotalSearches TotalSearches,
       LVUS.ViewsListingsLocatedUS AS ViewsListingsLocatedUS
FROM
  (SELECT Date,sum(Total) AS ListingViews,
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) AS Total,
             Date(date_time) AS Date,
             /*Listing properties per listing*/

     FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
      WHERE post_page_event = "0" /*PageView Calls*/
        AND post_prop19 = 'listing' /* Counting Listings */
        AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
  		AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
      GROUP BY Listing,Date)c /*List of valid listings (active/no active)*/
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
   GROUP BY Date) AS LV
left JOIN
  (SELECT sum(Total) AS DevelopmentViews, Date
   FROM
     (SELECT post_prop20 AS Development,
             count(*) AS Total,
             Date(date_time) AS Date,
     FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
      WHERE post_page_event = "0" /*Page View Calls*/
        AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
  		AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
        AND post_prop19 = 'development' /* Counting development */
      GROUP BY Development,Date) v
   JOIN
     (SELECT string(id) AS did
      FROM[djomniture:devspark.MG_Developments]) AS D ON D.did=v.Development
   GROUP BY Date) AS DV ON LV.Date= DV.Date
LEFT JOIN
  (SELECT sum(Total) AS ListingViewsThroughArticleBody, Date
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) AS Total,
             Date(date_time) AS Date,
             /*Listing properties per listing*/

      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
      WHERE post_page_event = "0" /*PageView Calls*/
        AND post_prop19 = 'listing' /* Counting Listings */
      AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
      AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
        AND post_prop10 = 'article_body'
      GROUP BY Listing,Date )c /*List of valid listings (active/no active)*/
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing = MG_HL.Listing_id
   GROUP BY Date) AS LVA ON LVA.Date = LV.Date
LEFT JOIN
  (SELECT count(*) AS TotalLeads,
          Date(date) AS Date
   FROM [djomniture:devspark.MG_Leads]
   WHERE  DATE(date) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
  AND DATE(date) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
     AND (development_id IS NOT NULL
          OR listing_id IS NOT NULL)
   GROUP BY Date) AS TL ON TL.Date = LV.Date
LEFT JOIN
  (SELECT sum(Total) AS TotalSocialShares, Date
   FROM
     (SELECT post_prop20 AS ListingId,
             count(*) AS Total,
             Date(date_time) AS Date,
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
      WHERE (post_prop21 = 'Social_Click'
             OR post_prop21 = 'Email_Click')/*IT IS AN SOCIAL CLICK*/
        AND post_prop22 NOT LIKE 'MG_%'
       AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
  AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
      GROUP BY ListingId,Date)c
   JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.ListingId = MG_HL.Listing_id
   GROUP BY Date) AS TSS ON TSS.Date= LV.Date
LEFT JOIN
  (SELECT count(*) AS TotalExternalClicks,
          Date(date_time) AS Date,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
   WHERE post_prop68='ExternalClick'
     AND Date(date_time) >= date('2016-11-18')
     AND (post_prop1='listing'
          OR post_prop1='development'
          OR post_prop1='article')
     AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
  AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
   GROUP BY Date) AS TEC ON TEC.Date = LV.Date
LEFT JOIN
  (SELECT count(*) AS ExternalClicksListings,
          Date(date_time) AS Date,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
   WHERE post_prop68='ExternalClick'
     AND Date(date_time) >= date('2016-11-18')
     AND (post_prop1='listing')
    AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
  AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
   GROUP BY Date) AS ECL ON ECL.Date = LV.Date
LEFT JOIN
  (SELECT count(*) AS ExternalClicksDevelopments,
          Date(date_time) AS Date,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
   WHERE post_prop68='ExternalClick'
     AND Date(date_time) >= date('2016-11-18')
     AND (post_prop1='development')
  AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
  AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
   GROUP BY Date) AS ECD ON ECD.Date = LV.Date
LEFT JOIN
  (SELECT count(*) AS ExternalClicksBerkshireWidget,
          Date(date_time) AS Date,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
   WHERE post_prop68='ExternalClick'
     AND Date(date_time) >= date('2016-11-18')
     AND (post_prop1='article')
   AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
  AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
   GROUP BY Date) AS ECB ON ECB.Date = LV.Date
LEFT JOIN
  (SELECT count(*) AS TotalSearches,
          Date(date_time) AS Date,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
   WHERE post_page_event = "0" /* Pageview Calls*/
   AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
  AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
     AND page_url LIKE '%/search%'
     AND page_url LIKE '%5Bformatted_address%'
   GROUP BY Date) AS TS ON TS.Date = LV.Date

LEFT  JOIN
  (SELECT sum(views) AS ViewsListingsLocatedUS,Date,
   FROM
     (SELECT post_prop20 AS Listing,
             count(*) views,
                      Date(date_time) AS Date
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -3, "DAY")), "%Y-%m-01") and STRFTIME_UTC_USEC(DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY")), "%Y-%m-01")'))
      WHERE post_page_event = "0" /*Page View Calls*/
      AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-3,"Day"))
      AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-1,"Day"))
        AND post_prop19 = 'listing' /* Counting development */
      GROUP BY Listing,Date) c
   JOIN each
     (SELECT *
      FROM [djomniture:devspark.MG_Listing_Address]
      WHERE (UPPER(country)='US'
             OR UPPER(country)='USA'
             OR UPPER(country)='UNITED STATES'))AS MG_LA ON c.Listing = MG_LA.id
   GROUP BY Date) AS LVUS ON LVUS.Date = LV.Date

