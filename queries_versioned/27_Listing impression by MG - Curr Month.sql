/*
Name: Listing impression by MG - Curr Month
Data source: 4
Created By: Admin
Last Update At: 2015-08-25T13:55:32.628648+00:00
*/
SELECT 
  MG_HL.marketingGroup_name AS marketingGroup,
  MG_HL.brokerage_name AS Brokerage,
  MG_HL.branch_name AS Branch,
  MG_HL.agent_name AS Agent,
  I.listing_id as listing_id,
  desc,
  Impressions
FROM (
  SELECT desc,listing_id,Impressions
  FROM (
    SELECT desc,HHC.listing_id as listing_id, count(*) Impressions
    FROM (
      SELECT SPLIT(post_prop69, ',') as listing_id,'home_hero_carousel' as desc
        FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))  
        WHERE post_page_event = "0" /*Page View Calls*/
        and post_prop1 = 'home' /*Impressions Made in Home*/
        and post_prop69 != '' /*impressions_home_hero_carousel*/
        and post_prop70 != '' /*impressions_home_featured_developments*/
        and post_prop71 != '' /*impressions_home_featured_listings*/
      ) HHC
    group by desc,listing_id
  ),(
    SELECT desc,HFL.listing_id as listing_id, count(*) Impressions
    FROM (
      SELECT SPLIT(post_prop71, ',') as listing_id,'home_featured_listings' as desc
        FROM (TABLE_QUERY(djomniture:cipomniture_djmansionglobal,"table_id CONTAINS '2015_' AND length(table_id) >= 4"))  
        WHERE post_page_event = "0" /*Page View Calls*/
        and post_prop1 = 'home' /*Impressions Made in Home*/
        and post_prop69 != '' /*impressions_home_hero_carousel*/
        and post_prop70 != '' /*impressions_home_featured_developments*/
        and post_prop71 != '' /*impressions_home_featured_listings*/
      ) HFL
    group by desc,listing_id
  )
)I
JOIN [djomniture:devspark.MG_Hierarchy_Listing] AS MG_HL ON I.listing_id = MG_HL.listing_id
order by Impressions desc  
