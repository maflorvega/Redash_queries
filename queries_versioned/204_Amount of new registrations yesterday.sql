/*
Name: Amount of new registrations yesterday
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T19:59:14.586584+00:00
*/
SELECT count(*)
FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"length(table_id) >= 4
                  AND year(MSEC_TO_TIMESTAMP(creation_time)) = year(CURRENT_DATE()) "))
WHERE post_page_event = "100" and(post_prop23 = "User Registration Succeed" /* Counting registrations */
                                  
                                 )
  AND DATE(date_time) = DATE(DATE_ADD(TIMESTAMP(current_Date()), -1, "DAY"))




