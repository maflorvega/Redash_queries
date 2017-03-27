/*
Name: Clicks on Agents WebSite
Data source: 4
Created By: Admin
Last Update At: 2015-08-24T16:18:04.437510+00:00
*/
SELECT marketingGroup,Brokerage,Branch,Agent,Listing,TargetUrl,Clicks
FROM
  (SELECT MG_H.marketingGroup_name AS marketingGroup,
          MG_H.brokerage_name AS Brokerage,
          MG_H.branch_name AS Branch,
          MG_H.agent_name AS Agent,
          TargetUrl,Listing,
          count(*) AS Clicks
   FROM
     ( SELECT agentId,Listing,
              TargetUrl
      FROM
        ( SELECT NTH(1, SPLIT(post_prop7, '_')) AS agentId,
         		 NTH(1, SPLIT(post_prop20, '-')) AS Listing,
                 NTH(1, SPLIT(post_prop72, '_')) AS TargetUrl
         FROM [djomniture:cipomniture_djmansionglobal.2015_08]
         WHERE (prop72 IS NOT NULL
                AND prop72 != ''
                AND prop72 != '__') ) ) a
   JOIN [djomniture:devspark.MG_Hierarchy] AS MG_H ON a.agentId = MG_H.agent_id
   GROUP BY marketingGroup,Brokerage,Branch,Agent,Listing, TargetUrl
  ) b
ORDER BY 1
