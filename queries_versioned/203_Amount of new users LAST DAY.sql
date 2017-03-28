/*
Name: Amount of new users LAST DAY
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T18:13:14.032209+00:00
*/

  (SELECT post_page_event,post_prop23,
          COUNT(*) AS Registrations,
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"length(table_id) >= 4
                     AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
                     AND month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = month(CURRENT_DATE()) "))
   WHERE (post_prop23 = "User Registration Succeed" /* Counting registrations */
          OR post_prop23='FB User Login Succed' /* Counting Logins */)
     AND DAY(date_time) = date_add(current_date(), -1, "DAY"))
ORDER BY post_page_event,post_prop23 DESC
