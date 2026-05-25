-- View 1: Campaign funnel summary
CREATE VIEW vw_campaign_funnel AS
SELECT 'Campaign 1 (Email)'              AS campaign, 1 AS stage_order, ROUND(AVG(acceptedcmp1)*100, 2) AS conversion_rate_pct FROM customers
UNION ALL
SELECT 'Campaign 2 (Social)',            2,                              ROUND(AVG(acceptedcmp2)*100, 2) FROM customers
UNION ALL
SELECT 'Campaign 3 (Catalog)',           3,                              ROUND(AVG(acceptedcmp3)*100, 2) FROM customers
UNION ALL
SELECT 'Campaign 4 (Email Re-target)',   4,                              ROUND(AVG(acceptedcmp4)*100, 2) FROM customers
UNION ALL
SELECT 'Campaign 5 (Social Re-target)',  5,                              ROUND(AVG(acceptedcmp5)*100, 2) FROM customers
UNION ALL
SELECT 'Final Campaign (Multi-Channel)', 6,                              ROUND(AVG(response)*100, 2)     FROM customers;
 
 
-- View 2: Segment performance summary
CREATE VIEW vw_segment_performance AS
SELECT
    incomesegment,
    COUNT(*)                                AS customers,
    ROUND(AVG(income), 0)                   AS avg_income,
    ROUND(AVG(totalspend), 0)               AS avg_spend,
    ROUND(AVG(response)*100, 1)             AS final_conv_pct,
    ROUND(AVG(numwebpurchases), 1)          AS avg_web_purchases,
    ROUND(AVG(numcatalogpurchases), 1)      AS avg_catalog_purchases,
    ROUND(AVG(numstorepurchases), 1)        AS avg_store_purchases
FROM customers
WHERE incomesegment IS NOT NULL
GROUP BY incomesegment
ORDER BY avg_spend DESC;
 
 
-- View 3: Channel purchase summary
CREATE VIEW vw_channel_breakdown AS
SELECT
    'Web'  AS channel,
    SUM(numwebpurchases) AS total_purchases,
    ROUND(SUM(numwebpurchases)*100.0 / (SELECT SUM(numwebpurchases+numcatalogpurchases+numstorepurchases) FROM customers), 1) AS market_share_pct
FROM customers
UNION ALL
SELECT
    'Catalog',
    SUM(numcatalogpurchases),
    ROUND(SUM(numcatalogpurchases)*100.0 / (SELECT SUM(numwebpurchases+numcatalogpurchases+numstorepurchases) FROM customers), 1)
FROM customers
UNION ALL
SELECT
    'Store',
    SUM(numstorepurchases),
    ROUND(SUM(numstorepurchases)*100.0 / (SELECT SUM(numwebpurchases+numcatalogpurchases+numstorepurchases) FROM customers), 1)
FROM customers
ORDER BY total_purchases DESC;
 
 
-- Query the views
SELECT * FROM vw_campaign_funnel     ORDER BY stage_order;
SELECT * FROM vw_segment_performance;
SELECT * FROM vw_channel_breakdown;