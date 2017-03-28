/*
Name: Amount of users for current month
Data source: 4
Created By: Admin
Last Update At: 2016-02-15T13:17:22.531332+00:00
*/
select count(*)
from(
  (SELECT post_prop24
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"length(table_id) >= 4
                  AND year(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = year(CURRENT_DATE())
                  AND month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) = month(CURRENT_DATE())"))
     where (post_prop23 = "User Registration Succeed" /* Counting registrations */
          OR post_prop23 = 'User Login Succeed'
          OR post_prop23='FB User Login Succeed' /* Counting Logins */)
     AND DATE(date_time) >= DATE('{{startdate}}')
     AND DATE(date_time) <= DATE('{{enddate}}')
  group by post_prop24)
)

