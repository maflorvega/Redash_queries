/*
Name: Previous page where the listing view was originated
Data source: 4
Created By: Admin
Last Update At: 2017-01-12T14:32:42.754397+00:00
*/
SELECT nvl(M.DisplayName,v.post_prop10) AS Previous_page,
       count(*) as Views,
FROM
  (SELECT post_prop20 as Listing,
          post_prop10
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND post_prop19 = 'listing' /* Counting Listings */ ) v
JOIN [djomniture:devspark.MODS] M ON v.post_prop10 = MOD
group by Previous_page
