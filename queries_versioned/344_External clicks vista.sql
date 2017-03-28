/*
Name: External clicks vista
Data source: 4
Created By: Admin
Last Update At: 2016-03-16T14:02:42.957758+00:00
*/
SELECT date(date_time) as date FROM [djomniture:devspark.External_Clicks] 
where date (date_time) <= date('2016-03-11')
and post_page_event='0'
order by date

