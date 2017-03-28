/*
Name: Amount of developments saved yesterday
Data source: 4
Created By: Admin
Last Update At: 2016-02-24T18:45:14.854385+00:00
*/
SELECT count(*) AS Save_Count
FROM
  (SELECT string(post_prop26) AS Devs,
          COUNT(DISTINCT string(post_prop26)) save,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"length(table_id) >= 4
                     AND year(MSEC_TO_TIMESTAMP(creation_time)) = year(CURRENT_DATE()) "))
   WHERE post_page_event = "100"
     AND (post_prop25 = "developmentSaved")
     AND DATE(date_time) = DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY"))
   GROUP BY Devs)
