/*
Name: Cohort testing
Data source: 4
Created By: Admin
Last Update At: 2015-10-01T03:20:49.066866+00:00
*/
SELECT la.address AS development,
       LA.id AS Id,
       ModDisplayName,
       Views,
       Visits,
       Visitors
FROM
  ( SELECT Development,
           ModDisplayName,
           COUNT(visit_num) AS Views,
           COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
           COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors,
   FROM
     (SELECT nvl(M.DisplayName,post_prop10) AS ModDisplayName,
             Development,
             post_visid_high,
             post_visid_low,
             visit_num
      FROM
        (SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Development,
                post_visid_high,
                post_visid_low,
                visit_num,
                post_prop10
         FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= month(DATE('2015-06-01')) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE('2015-09-31')) "))
         WHERE post_page_event = "0" /*PAGE VIEW CALLS*/
           AND post_prop19 = 'development' /* Counting Developments */ ) v
      JOIN [djomniture:devspark.MODS] M ON post_prop10 = MOD)
   GROUP BY ModDisplayName,
            Development
   ORDER BY 1,
            2) D /*OUTER JOIN TO ADD DEVELOPMENT ADDRESS*/
LEFT OUTER JOIN
  (SELECT id,
          address
   FROM [djomniture:devspark.MG_Development_Address]) AS LA ON D.Development = LA.id
