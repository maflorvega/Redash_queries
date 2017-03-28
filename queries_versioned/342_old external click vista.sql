/*
Name: old external click vista
Data source: 4
Created By: Admin
Last Update At: 2016-03-15T19:15:20.137670+00:00
*/
SELECT date(date_time) as date FROM [djomniture:devspark.External_Clicks] 
where date (date_time) <= date('2016-03-10')
and post_page_event='100'
order by date

