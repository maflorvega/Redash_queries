/*
Name: Brokerages
Data source: 4
Created By: Admin
Last Update At: 2015-11-25T18:25:41.802569+00:00
*/
SELECT brokerage_name as name, string(brokerage_id) as id
FROM [djomniture:devspark.MG_Hierarchy_Listing]
where {{startdate}} !=0 
and {{enddate}} != 0
and marketingGroup_id = '92'
group by name,id
ORDER BY name ASC
