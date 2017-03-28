/*
Name: query session
Data source: 4
Created By: Admin
Last Update At: 2016-04-07T14:05:30.997731+00:00
*/
SELECT SESSION,
       count(*) AS CantLan
FROM
  (SELECT MG_languaje,
          SESSION
   FROM
     (SELECT 'es' AS MG_languaje,
             accept_language,
             page_url,
             geo_city,
             geo_country,
             geo_region,
             visit_page_num,
             post_visid_high+'-'+post_visid_low+'-'+visit_num AS SESSION,
      FROM [djomniture:cipomniture_djmansionglobal.2016_04]
      WHERE lower(page_url) LIKE '%/es/%'
        OR lower(page_url) = 'http://www.mansionglobal.com/es') es,
     (SELECT 'cn' AS MG_languaje,
             accept_language,
             page_url,
             geo_city,
             geo_country,
             geo_region,
             visit_page_num,
             post_visid_high+'-'+post_visid_low+'-'+visit_num AS SESSION,
      FROM [djomniture:cipomniture_djmansionglobal.2016_04]
      WHERE lower(page_url) LIKE '%/cn/%'
        OR lower(page_url) = 'http://www.mansionglobal.com/cn') cn,
     (SELECT 'en' AS MG_languaje,
             accept_language,
             page_url,
             geo_city,
             geo_country,
             geo_region,
             visit_page_num,
             post_visid_high+'-'+post_visid_low+'-'+visit_num AS SESSION,
      FROM [djomniture:cipomniture_djmansionglobal.2016_04]
      WHERE(lower(page_url) NOT LIKE '%/cn/%'
            AND lower(page_url) NOT LIKE '%/es/%'
            AND lower(page_url) != 'http://www.mansionglobal.com/cn'
            AND lower(page_url) != 'http://www.mansionglobal.com/es')
        OR (lower(page_url) LIKE '%/en/%'
            OR lower(page_url) = 'http://www.mansionglobal.com/en')) en
   GROUP BY MG_languaje,
            SESSION
   ORDER BY SESSION)
GROUP BY SESSION HAVING CantLan > 1
ORDER BY SESSION
