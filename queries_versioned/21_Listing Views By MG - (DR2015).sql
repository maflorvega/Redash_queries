/*
Name: Listing Views By MG - (DR2015)
Data source: 4
Created By: Admin
Last Update At: 2015-08-24T16:24:29.050283+00:00
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
             /*NTH(1, SPLIT(post_prop20, '-')) AS Listing,*/
             post_visid_high,
             post_visid_low,
             visit_num
      FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,
             "table_id CONTAINS '2015_' AND length(table_id) >= 4"))
      WHERE post_page_event = "0" /*condition indicated by kevin chen*/
     	AND date(date_time) >= date(DATE_ADD(CURRENT_TIMESTAMP(), -7, "DAY")) /*Just Last 7 days*/
        /*AND post_prop20 != '' /* listing id is not null*/
        AND post_prop19 = 'listing' /* Counting Listings */
        AND DATE(date_time) >= DATE('{{startdate}}')
        AND DATE(date_time) <= DATE('{{enddate}}')  ) a
   JOIN [djomniture:devspark.MG_Hierarchy] AS MG_H ON a.agentId = MG_H.agent_id)
GROUP BY marketingGroup
ORDER BY 1
