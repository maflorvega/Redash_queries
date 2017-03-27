/*
Name: Total listings that were live 2
Data source: 4
Created By: Admin
Last Update At: 2016-12-13T14:42:04.807744+00:00
*/

  select id
FROM [djomniture:devspark.MG_All_Listings]
WHERE (DATE(created_at) <= DATE('{{enddate}}') and DATE(deleted_at) IS NULL) /*active listings*/
       OR (DATE(deleted_at) >= Date('{{startdate}}') and DATE(deleted_at) <= Date('{{enddate}}') )
order by id

