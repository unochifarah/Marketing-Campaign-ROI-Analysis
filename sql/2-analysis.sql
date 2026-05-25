-- Q1: What is the conversion rate at each stage of the campaign funnel?
SELECT 'Campaign 1 (Email)'             AS campaign, ROUND(AVG(acceptedcmp1)*100, 2) AS conversion_rate_pct FROM customers
UNION ALL
SELECT 'Campaign 2 (Social)',                         ROUND(AVG(acceptedcmp2)*100, 2) FROM customers
UNION ALL
SELECT 'Campaign 3 (Catalog)',                        ROUND(AVG(acceptedcmp3)*100, 2) FROM customers
UNION ALL
SELECT 'Campaign 4 (Email Re-target)',                ROUND(AVG(acceptedcmp4)*100, 2) FROM customers
UNION ALL
SELECT 'Campaign 5 (Social Re-target)',               ROUND(AVG(acceptedcmp5)*100, 2) FROM customers
UNION ALL
SELECT 'Final Campaign (Multi-Channel)',               ROUND(AVG(response)*100, 2)     FROM customers;
 
 
-- Q2: Which purchase channel drives the most transactions?
SELECT 'Web'     AS channel, SUM(numwebpurchases)     AS total_purchases FROM customers
UNION ALL
SELECT 'Catalog',             SUM(numcatalogpurchases)              FROM customers
UNION ALL
SELECT 'Store',               SUM(numstorepurchases)                FROM customers
ORDER BY total_purchases DESC;
 
 
-- Q3: Which income segment has the highest spend and conversion rate?
SELECT
    incomesegment,
    COUNT(*)                                    AS customers,
    ROUND(AVG(totalspend), 0)                   AS avg_spend,
    ROUND(AVG(response)*100, 1)                 AS final_conv_pct,
    ROUND(AVG(totalcampaignsaccepted), 2)       AS avg_campaigns_accepted
FROM customers
WHERE incomesegment IS NOT NULL
GROUP BY incomesegment
ORDER BY avg_spend DESC;
 
 
-- Q4: Which campaign delivered the best ROI?
SELECT
    cc.campaign,
    cc.channel,
    cc.cost_usd,
    COUNT(CASE WHEN
        (cc.campaign = 'Campaign 1'     AND c.acceptedcmp1 = 1) OR
        (cc.campaign = 'Campaign 2'     AND c.acceptedcmp2 = 1) OR
        (cc.campaign = 'Campaign 3'     AND c.acceptedcmp3 = 1) OR
        (cc.campaign = 'Campaign 4'     AND c.acceptedcmp4 = 1) OR
        (cc.campaign = 'Campaign 5'     AND c.acceptedcmp5 = 1) OR
        (cc.campaign = 'Final Campaign' AND c.response    = 1)
    THEN 1 END)                                         AS acceptors,
    ROUND(AVG(CASE WHEN
        (cc.campaign = 'Campaign 1'     AND c.acceptedcmp1 = 1) OR
        (cc.campaign = 'Campaign 2'     AND c.acceptedcmp2 = 1) OR
        (cc.campaign = 'Campaign 3'     AND c.acceptedcmp3 = 1) OR
        (cc.campaign = 'Campaign 4'     AND c.acceptedcmp4 = 1) OR
        (cc.campaign = 'Campaign 5'     AND c.acceptedcmp5 = 1) OR
        (cc.campaign = 'Final Campaign' AND c.response    = 1)
    THEN c.totalspend END), 0)                          AS avg_acceptor_spend,
    ROUND(
        (COUNT(CASE WHEN
            (cc.campaign = 'Campaign 1'     AND c.acceptedcmp1 = 1) OR
            (cc.campaign = 'Campaign 2'     AND c.acceptedcmp2 = 1) OR
            (cc.campaign = 'Campaign 3'     AND c.acceptedcmp3 = 1) OR
            (cc.campaign = 'Campaign 4'     AND c.acceptedcmp4 = 1) OR
            (cc.campaign = 'Campaign 5'     AND c.acceptedcmp5 = 1) OR
            (cc.campaign = 'Final Campaign' AND c.response    = 1)
        THEN 1 END) * AVG(CASE WHEN
            (cc.campaign = 'Campaign 1'     AND c.acceptedcmp1 = 1) OR
            (cc.campaign = 'Campaign 2'     AND c.acceptedcmp2 = 1) OR
            (cc.campaign = 'Campaign 3'     AND c.acceptedcmp3 = 1) OR
            (cc.campaign = 'Campaign 4'     AND c.acceptedcmp4 = 1) OR
            (cc.campaign = 'Campaign 5'     AND c.acceptedcmp5 = 1) OR
            (cc.campaign = 'Final Campaign' AND c.response    = 1)
        THEN c.totalspend END) - cc.cost_usd
        ) * 100.0 / cc.cost_usd, 1)                    AS roi_pct
FROM campaign_costs cc
CROSS JOIN customers c
GROUP BY cc.campaign, cc.channel, cc.cost_usd
ORDER BY roi_pct DESC;