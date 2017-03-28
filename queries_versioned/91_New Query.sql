/*
Name: New Query
Data source: 4
Created By: Admin
Last Update At: 2015-10-19T18:27:11.050179+00:00
*/
SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
       post_prop10
FROM djomniture:cipomniture_djmansionglobal.2015_10 
OUTER JOIN EACH 
  SELECT string(id) AS Listing 
  FROM [djomniture:devspark.MG_Listings] AS L 
  ON v.Listing = L.Listing
