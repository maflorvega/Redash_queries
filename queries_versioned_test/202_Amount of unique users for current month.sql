/*
Name: Amount of unique users for current month
Data source: 4
Created By: Admin
Last Update At: 2016-02-12T17:45:31.685075+00:00
*/
SELECT count(*) FROM(
                       (SELECT post_prop24
                        FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"length(table_id) >= 4
                                          AND year(MSEC_TO_TIMESTAMP(creation_time)) = year(CURRENT_DATE())
                                          AND month(MSEC_TO_TIMESTAMP(creation_time)) = month(CURRENT_DATE())"))
                        WHERE (post_prop23 = "User Registration Succeed" /* Counting registrations */
                               OR post_prop23 = 'User Login Succeed'
                               OR post_prop23='FB User Login Succeed' /* Counting Logins */)
                        GROUP BY post_prop24))
