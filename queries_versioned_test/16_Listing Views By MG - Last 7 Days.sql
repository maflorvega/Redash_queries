/*
Name: Listing Views By MG - Last 7 Days
Data source: 4
Created By: Admin
Last Update At: 2015-08-19T13:54:05.023226+00:00
*/
SELECT marketingGroup,
       COUNT(*) AS Views 
	,COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits
	,COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
FROM
  (SELECT MG_H.marketingGroup_name AS marketingGroup,
          post_visid_high,
          post_visid_low,
          visit_num
   FROM
     (SELECT NTH(1, SPLIT(post_prop7, '_')) AS agentId,
             post_visid_high,
             post_visid_low,
             visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,
             "table_id CONTAINS '2015_' AND length(table_id) >= 4 AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) in (month(CURRENT_DATE()),(month(CURRENT_DATE())-1))"))
      WHERE post_page_event = "0" /*condition indicated by kevin chen*/
     	AND date(date_time) >= date(DATE_ADD(CURRENT_TIMESTAMP(), -7, "DAY")) /*Just Last 7 days*/
        AND post_prop19 = 'listing' /* Counting Listings */ ) a
  JOIN (SELECT string(id) as id from [djomniture:devspark.MG_All_Listings]) AS L ON a.Listing = L.id /*Join to select just VALID ListingID*/  
  JOIN [djomniture:devspark.MG_Hierarchy] AS MG_H ON a.agentId = MG_H.agent_id
)
GROUP BY marketingGroup
ORDER BY 1
