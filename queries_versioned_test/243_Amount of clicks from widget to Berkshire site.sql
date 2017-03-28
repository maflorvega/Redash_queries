/*
Name: Amount of clicks from widget to Berkshire site
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T14:32:32.263043+00:00
*/
SELECT count(*) AS Clicks
from TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"length(table_id) >= 4")
WHERE post_prop75= 'article_page_berkshire_hathaway_widget'
  AND lower(post_prop1)='listing'
  
