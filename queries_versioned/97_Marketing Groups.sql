/*
Name: Marketing Groups
Data source: 4
Created By: Admin
Last Update At: 2015-10-28T15:38:33.387202+00:00
*/
SELECT 
      id,name
FROM
  (SELECT name, string(id) as id
   FROM [djomniture:devspark.MG_Marketing_Groups]
   where {{startdate}} !=0 and {{enddate}} != 0
   ORDER BY name ASC)
