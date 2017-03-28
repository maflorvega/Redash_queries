/*
Name: Listing Views By MG - Current Month
Data source: 4
Created By: Admin
Last Update At: 2015-08-18T20:35:24.214704+00:00
*/
SELECT marketingGroup,
       COUNT(*) AS Views 
	/*,COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits*/ 
	/*,COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors*/
FROM
  (SELECT MG_H.marketingGroup_name AS marketingGroup,
          post_visid_high,
          post_visid_low,
          visit_num
   FROM
     (SELECT NTH(1, SPLIT(post_prop7, '_')) AS agentId,
             /*NTH(1, SPLIT(post_prop20, '-')) AS Listing,*/
             post_visid_high,
             post_visid_low,
             visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "length(table_id) >= 4
                        AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
                        AND month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = month(CURRENT_DATE())"))
      WHERE post_page_event = "0" /*condition indicated by kevin chen*/
        /*AND post_prop20 != '' /* listing id is not null*/
        AND post_prop19 = 'listing' /* Counting Listings */ ) a
   JOIN [djomniture:devspark.MG_Hierarchy] AS MG_H ON a.agentId = MG_H.agent_id)
GROUP BY marketingGroup
ORDER BY 1
