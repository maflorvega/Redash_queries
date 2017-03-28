/*
Name: Article saved by day
Data source: 4
Created By: Admin
Last Update At: 2016-04-06T16:00:33.236911+00:00
*/

SELECT date, count(*) AS Saved_count from(
                                            (SELECT string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS date, string(post_prop26) AS Lis, COUNT(DISTINCT string(post_prop26)) save,
                                             FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,'CONCAT(REPLACE(table_id,"_","-"),"-01") BETWEEN STRFTIME_UTC_USEC("{{startdate}}", "%Y-%m-01") and STRFTIME_UTC_USEC("{{enddate}}", "%Y-%m-31")'))
                                             WHERE post_page_event = "100"
                                               AND (post_prop25 = "articleSaved")
                                               AND DATE(date_time) >= DATE('{{startdate}}')
                                               AND DATE(date_time) <= DATE('{{enddate}}')
                                             GROUP BY date,Lis
                                             ORDER BY save DESC))
GROUP BY date
ORDER BY date
