/*
Name: Pages Views by MG details - Last 7 Days
Data source: 4
Created By: Admin
Last Update At: 2015-08-18T17:27:39.675541+00:00
*/
SELECT MG,Brokerage,Branch,Agent,Listing,Views,Visits,Visitors,nvl(Leads,'0') as Leads FROM (
SELECT MG.MG_DESC AS MG,Brokerage,Branch,Agent,Listing,Views,Visits,Visitors FROM (
SELECT MGID,Brokerage,Branch,Agent,
       Listing,
       COUNT(*) AS views,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) visits,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low) visitors
FROM
  (SELECT NTH(7, SPLIT(p7, '_')) AS MGID,
          NTH(4, SPLIT(p7, '_')) AS Brokerage,
          NTH(6, SPLIT(p7, '_')) AS Branch,
          NTH(2, SPLIT(p7, '_')) AS Agent,
             prop10,
             Listing,
             post_visid_high,
             post_visid_low,
             visit_num
   FROM
     (SELECT prop7,
             prop10,
             SUBSTR(prop20, 1, INSTR(prop20, '-')-1) as Listing,
             post_visid_high,
             post_visid_low,
             visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,
             "table_id CONTAINS '2015_' AND length(table_id) >= 4 AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) in (month(CURRENT_DATE()), (month(CURRENT_DATE())-1)) "))
      WHERE post_page_event = "0"
       AND (DATE(date_time) >= date(DATE_ADD(CURRENT_DATE(), -7, "DAY")))) b
   JOIN
     (SELECT prop7 AS p7,
             SUBSTR(prop20, 1, INSTR(prop20, '-')-1) L
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,
             "table_id CONTAINS '2015_' AND length(table_id) >= 4 AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) in (month(CURRENT_DATE()), (month(CURRENT_DATE())-1)) "))
      WHERE post_page_event = "0"
        AND prop7 IS NOT NULL
        AND prop7 != ''
        AND prop7 != '_______'
        AND prop20 LIKE '%-%'
      GROUP BY p7,
               L) AS nullprop ON b.Listing = L
)a
   JOIN [djomniture:devspark.MODS] M ON prop10 = MOD
WHERE Listing IS NOT NULL
GROUP BY MGID,Brokerage,Branch,Agent,
         Listing
)c
   JOIN [djomniture:devspark.MG] AS MG ON MGID = MG.MG_ID
)D
left outer JOIN (
      select string(count(*)) Leads, string(Listing_id) as Listing_ID
      from [djomniture:devspark.Leads] 
      WHERE DATE(date) >= DATE(DATE_ADD(CURRENT_TIMESTAMP(), -7, 'DAY'))
      group by Listing_ID
) AS LEADS ON Listing = LEADS.Listing_ID
ORDER BY MG,
         BROKERAGE,
         BRANCH,
         AGENT,
         LISTING
