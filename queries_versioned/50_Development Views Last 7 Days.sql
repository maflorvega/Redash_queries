/*
Name: Development Views Last 7 Days
Data source: 4
Created By: Admin
Last Update At: 2015-09-11T14:14:23.724971+00:00
*/
SELECT nvl(DATE,P.PreviousWeekDATE) AS DATE,
       views,
       visits,
       visitors,
       ViewsPreviousWeek,
       VisitsPreviousWeek,
       VisitorsPreviousWeek,
       DAY(nvl(DATE,P.PreviousWeekDATE)) AS DAY,
       MONTH(nvl(DATE,P.PreviousWeekDATE)) AS MONTH,
       YEAR(nvl(DATE,P.PreviousWeekDATE)) AS YEAR
FROM
  (SELECT string(STRFTIME_UTC_USEC(DATE(date_time), "%m/%d/%Y")) AS DATE,
          COUNT(visit_num) AS Views,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, "((year(MSEC_TO_TIMESTAMP(creation_time)) = year(DATE(CURRENT_DATE()))
                                                                 AND month(MSEC_TO_TIMESTAMP(creation_time)) <= month(DATE(CURRENT_DATE())))
                                                                OR (month(MSEC_TO_TIMESTAMP(creation_time)) > (month(CURRENT_DATE()))
                                                                    AND year(MSEC_TO_TIMESTAMP(creation_time)) < year(DATE(CURRENT_DATE()))))"))
   WHERE post_page_event = "0" /*Page View Calls*/
     AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-8,"Day"))
     AND DATE(date_time) < DATE(CURRENT_DATE())
     AND post_prop19 = 'development' /* Counting development */
   GROUP BY DATE
   ORDER BY DATE) C FULL
OUTER JOIN EACH
  (SELECT string(STRFTIME_UTC_USEC(date(DATE_ADD(date_time,+7,"Day")), "%m/%d/%Y")) AS PreviousWeekDATE,
          COUNT(visit_num) AS ViewsPreviousWeek,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) VisitsPreviousWeek,
          COUNT(DISTINCT post_visid_high + "-" + post_visid_low) VisitorsPreviousWeek
   FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal, " ((year(MSEC_TO_TIMESTAMP(creation_time)) = year(DATE(CURRENT_DATE()))
                                                                 AND month(MSEC_TO_TIMESTAMP(creation_time)) <= month(DATE(CURRENT_DATE())))
                                                                OR (month(MSEC_TO_TIMESTAMP(creation_time)) > (month(CURRENT_DATE()))
                                                                    AND year(MSEC_TO_TIMESTAMP(creation_time)) < year(DATE(CURRENT_DATE()))))"))
   WHERE post_page_event = "0" /*Page View Calls*/
     AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-15,"Day"))
     AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-8,"Day"))
     AND post_prop19 = 'development' /* Counting development */
   GROUP BY PreviousWeekDATE
   ORDER BY PreviousWeekDATE) P ON c.DATE = P.PreviousWeekDATE
ORDER BY YEAR ASC, MONTH ASC, DAY ASC

