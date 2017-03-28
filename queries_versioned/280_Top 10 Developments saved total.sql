/*
Name: Top 10 Developments saved total
Data source: 4
Created By: Admin
Last Update At: 2016-02-25T14:06:54.405919+00:00
*/

SELECT date_time, (nvl(M.DisplayName,post_prop10)) AS Top10MOD,developments_id
       
FROM
  (SELECT date_time,string(post_prop26) AS developments_id,
          post_prop10,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
   WHERE post_page_event='100'
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
     AND (post_prop25 = "developmentSaved")
  ) s

JOIN [djomniture:devspark.MODS] M ON s.post_prop10 = MOD
order by Developments_id
