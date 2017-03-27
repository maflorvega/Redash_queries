/*
Name: New Query
Data source: 4
Created By: Admin
Last Update At: 2015-09-15T14:11:38.251015+00:00
*/
SELECT  DATE(DATE_ADD(CURRENT_DATE(),-7,"Day")) currentmenos7,nvl(DATE,P.PreviousWeekDATE) as DATE,views,visits,visitors,ViewsPreviousWeek,VisitsPreviousWeek,VisitorsPreviousWeek
from(
  SELECT date(date_time) as DATE,
       COUNT(visit_num) AS Views,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) Visits,
       COUNT(DISTINCT post_visid_high + "-" + post_visid_low) Visitors
  FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,
                        "month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= (month(DATE(CURRENT_DATE()))-15) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE(CURRENT_DATE())) "
                        ))    
  WHERE post_page_event = "0" /*Page View Calls*/
    AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-7,"Day"))
    AND DATE(date_time) < DATE(CURRENT_DATE())
  group by DATE
  ORDER BY DATE
) C
FULL OUTER join each(
  SELECT DATE(DATE_ADD(date_time,+7,"Day")) as PreviousWeekDATE,
         COUNT(visit_num) AS ViewsPreviousWeek,
         COUNT(DISTINCT post_visid_high + "-" + post_visid_low + "-" + visit_num) VisitsPreviousWeek,
         COUNT(DISTINCT post_visid_high + "-" + post_visid_low) VisitorsPreviousWeek
  FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,
                        "month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) >= (month(DATE(CURRENT_DATE()))-15) and month(TIMESTAMP(CONCAT(REPLACE(table_id,"_","-"),"-01"))) <= month(DATE(CURRENT_DATE())) "
                        ))    
  WHERE post_page_event = "0" /*Page View Calls*/
    AND DATE(date_time) >= DATE(DATE_ADD(CURRENT_DATE(),-15,"Day"))
    AND DATE(date_time) <= DATE(DATE_ADD(CURRENT_DATE(),-7,"Day"))
  group by PreviousWeekDATE
  ORDER BY PreviousWeekDATE
) P on c.DATE = P.PreviousWeekDATE
order by 1
