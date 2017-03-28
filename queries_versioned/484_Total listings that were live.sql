/*
Name: Total listings that were live
Data source: 4
Created By: Admin
Last Update At: 2016-12-07T15:10:14.731559+00:00
*/

SELECT count(*) AS Lstings
FROM
  (SELECT string(id) as id
   FROM [djomniture:devspark.MG_All_Listings]
   WHERE (DATE(created_at) <= DATE('{{enddate}}')
          AND DATE(deleted_at) IS NULL) /*active listings*/
     OR (DATE(deleted_at) >= Date('{{startdate}}')
         AND DATE(deleted_at) <= Date('{{enddate}}'))
   GROUP BY id)
