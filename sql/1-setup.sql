-- Project: Marketing Campaign ROI Analysis
-- Dataset: Marketing Campaign
-- Source: https://www.kaggle.com/datasets/rodsaldanha/arketing-campaign

CREATE DATABASE marketing_analysis;

CREATE TABLE customers (
    ID INTEGER,
    Year_Birth INTEGER,
    Education VARCHAR(20),
    Marital_Status VARCHAR(20),
    Income NUMERIC(10,2),
    Kidhome INTEGER,
    Teenhome INTEGER,
    Dt_Customer VARCHAR(20),
    Recency INTEGER,
    MntWines INTEGER,
    MntFruits INTEGER,
    MntMeatProducts INTEGER,
    MntFishProducts INTEGER,
    MntSweetProducts INTEGER,
    MntGoldProds INTEGER,
    NumDealsPurchases INTEGER,
    NumWebPurchases INTEGER,
    NumCatalogPurchases INTEGER,
    NumStorePurchases INTEGER,
    NumWebVisitsMonth INTEGER,
    AcceptedCmp3 INTEGER,
    AcceptedCmp4 INTEGER,
    AcceptedCmp5 INTEGER,
    AcceptedCmp1 INTEGER,
    AcceptedCmp2 INTEGER,
    Complain INTEGER,
    Z_CostContact INTEGER,
    Z_Revenue INTEGER,
    Response INTEGER,
    Age INTEGER,
    TotalSpend NUMERIC(10,2),
    TotalPurchase INTEGER,
    TotalCampaignsAccepted INTEGER,
    HasChildren INTEGER,
    IncomeSegment VARCHAR(25)
);

COPY customers
FROM 'E:\GitHub\Marketing-Campaign-ROI-Analysis\data\marketing_clean.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

SELECT COUNT(*) FROM customers;