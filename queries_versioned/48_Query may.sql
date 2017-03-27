/*
Name: Query may
Data source: 4
Created By: Admin
Last Update At: 2015-09-08T17:37:15.484626+00:00
*/
  SELECT FIRST(SPLIT(LAST(SPLIT(post_prop5, '/')), '-')) as post_prop20,    
                  post_prop5 as URL,        
                  post_prop7 as agent_id,
                  post_prop10 as MOD,
                  post_page_event,
                  post_visid_high,
                  post_visid_low,
                  date_time,
                  post_prop1, 
                  post_prop19,
                  post_prop69,
                  post_prop70,
                  post_prop71,
                  post_prop72,
                  page_url,
                  visit_num,                
                  FROM  djomniture:cipomniture_djmansionglobal.2015_05
                  WHERE post_prop19 = 'listing' /* Counting Listings */ 
                  AND post_page_event = "0" /*condition indicated by kevin chen*/    
 

