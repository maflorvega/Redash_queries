/*
Name: New Query
Data source: 4
Created By: Admin
Last Update At: 2015-10-20T15:27:57.873388+00:00
*/
SELECT MOD
FROM djomniture:devspark.MODS_SOCIAL AS ms
JOIN (
SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) AS Listing,
       post_prop10,
FROM djomniture:cipomniture_djmansionglobal.2015_10 ) as mg
ON mg.post_prop10 LIKE concat('%',  ms.MOD, '%')


