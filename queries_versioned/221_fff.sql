/*
Name: fff
Data source: 4
Created By: Admin
Last Update At: 2016-02-16T20:50:18.872076+00:00
*/
   SELECT date, page_url,post_prop72,
            MG_HL.marketingGroup_name ,post_prop75
   FROM
     ( SELECT Date(date_time) as date,Click, page_url,post_prop72,
              MG_HL.Listing_id AS Listing_id,MG_HL.marketingGroup_name ,MG_HL.marketingGroup_id ,post_prop75
      FROM
        ( SELECT date_time,1 AS Click,
                 FIRST(SPLIT(post_prop20, '-')) AS Listing_id,post_prop75, page_url,post_prop72,
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
         WHERE prop72 IS NOT NULL /*IT IS AN EXTERNAL REDIRECTION*/
           AND prop72 != ''
           AND prop72 != '__'
           AND DATE(date_time) >= DATE('{{startdate}}')
           AND DATE(date_time) <= DATE('{{enddate}}')) c
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON c.Listing_id = MG_HL.Listing_id)
order by post_prop75
