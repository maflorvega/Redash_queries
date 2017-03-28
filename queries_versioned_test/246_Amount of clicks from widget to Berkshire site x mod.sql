/*
Name: Amount of clicks from widget to Berkshire site x mod
Data source: 4
Created By: Admin
Last Update At: 2016-02-19T15:46:33.561064+00:00
*/
SELECT count(*) AS Clicks
from TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"length(table_id) >= 4")
WHERE post_prop10= 'berkshire_hathaway_widget'
  AND lower(post_prop1)='listing'
  
