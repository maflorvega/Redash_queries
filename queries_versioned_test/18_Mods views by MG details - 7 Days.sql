/*
Name: Mods views by MG details - 7 Days
Data source: 4
Created By: Admin
Last Update At: 2015-08-24T15:16:07.891763+00:00
*/
SELECT marketingGroup,Brokerage,Branch,Agent,Listing,MOD,Views
FROM
  (SELECT marketingGroup,Brokerage,Branch,Agent,Listing,
          nvl(DisplayName,prop10) AS MOD,
          COUNT(*) AS Views
   FROM
     (SELECT MG_H.marketingGroup_name AS marketingGroup,
             MG_H.brokerage_name AS Brokerage,
             MG_H.branch_name AS Branch,
             MG_H.agent_name AS Agent,
             Listing,
             prop10,
      		 M.DisplayName as DisplayName
      FROM
        (SELECT NTH(1, SPLIT(post_prop7, '_')) AS agentId,
                NTH(1, SPLIT(post_prop20, '-')) AS Listing,
                prop10
          FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "table_id CONTAINS '2015_'
                           AND length(table_id) >= 4
                           AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
                           AND month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) IN (month(CURRENT_DATE()),(month(CURRENT_DATE())-1))"))
         WHERE post_page_event = "0" /*condition indicated by kevin chen*/
           AND date(date_time) >= date(DATE_ADD(CURRENT_TIMESTAMP(), -7, "DAY"))
           /*AND post_prop20 != '' /* listing id is not null*/
           AND post_prop19 = 'listing' /* Counting Listings */ ) a
      JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_H ON a.agentId = MG_H.agent_id
      JOIN [djomniture:devspark.MODS] M ON prop10 = MOD )
   GROUP BY marketingGroup,Brokerage,Branch,Agent,Listing,MOD
  ) a
WHERE Listing IS NOT NULL
ORDER BY marketingGroup,
         Brokerage,
         Branch,
         Agent,
         Listing
