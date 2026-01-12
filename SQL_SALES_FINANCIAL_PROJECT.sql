----------------------------------------------------DATA CHECK and VALIDATION--------------------------------------------------------------------------
SELECT COUNT(*)
FROM sales_data_sample;

SELECT TOP 10*
FROM sales_data_sample;

------------------------------------------------------------------------DATA STRUCTURE CHECK----------------------------------------------------------------------------------------------------------
SELECT
	count(*) AS total_rows,
	count (ORDERNUMBER) AS non_null_orders

FROM sales_data_sample;

-------------------------------------------------------------------------Data Cleaninng----------------------------------------------------------------------------------------------------------------
-----validate revenue calculation--------
---- SALES = PRICEEACH × QUANTITYORDERED---

SELECT *
FROM sales_data_sample
WHERE SALES <> PRICEEACH * QUANTITYORDERED;

----Fix Date Column---------------
ALTER TABLE sales_data_sample
ALTER COLUMN ORDERDATE DATE;

------------------------------------------------------------------FINANCIAL ANALYSIS--------------------------------------------------------------------------------------------------------------------
---TOTAL REVENUE----------
SELECT SUM(SALES) AS TOTAL_REVENUE
FROM sales_data_sample;

---REVENUE BY YEAR------
SELECT YEAR_ID, SUM(SALES) AS REVENUE
FROM sales_data_sample
GROUP BY YEAR_ID
ORDER BY YEAR_ID;

----MONTHLY REVENUE TREND--------
SELECT 
	YEAR_ID,
	MONTH_ID,
	SUM(SALES) AS MONTHLY_REVENUE
FROM sales_data_sample
GROUP BY YEAR_ID, MONTH_ID
ORDER BY YEAR_ID, MONTH_ID;

----------------------------------------------------------PRODUCT PERFORMANCE-----------------------------------------------------------
----REVENUE BY PRODUCT LINE------
SELECT PRODUCTLINE, SUM(SALES) AS revenue
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY revenue DESC;

---BEST SELLING PRODUCTS-----
SELECT PRODUCTCODE,
	SUM(QUANTITYORDERED)AS total_units 
FROM sales_data_sample
GROUP BY PRODUCTCODE
ORDER BY total_units DESC;

----------------------------------------------------------CUSTOMER AND MARKET ANALYSIS--------------------------------------------------------------------
----TOP CUSTOMER----
SELECT CUSTOMERNAME,
	SUM(SALES) AS revenue
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY revenue desC;

----REVENUE BY COUNTRY----
SELECT COUNTRY,
	SUM(SALES) AS revenue
FROM sales_data_sample
Group BY COUNTRY
ORDER BY revenue DESC;

------------------------------------------------------------BUSINESS KPIs------------------------------------------------------------------------------
----AVERAGE ORDER VALUE(AOV)------
SELECT SUM(SALES)/ COUNT(DISTINCT ORDERNUMBER) AS average_order_value
FROM sales_data_sample;

-------DEAL SIZE IMPACT------
SELECT DEALSIZE,
	SUM(SALES) AS revenue
FROM sales_data_sample
GROUP BY DEALSIZE;

--------Top Customers------------
SELECT
    CUSTOMERNAME,
    SUM(SALES) AS revenue,
    RANK() OVER (ORDER BY SUM(SALES) DESC) AS rank
FROM sales_data_sample
GROUP BY CUSTOMERNAME;

----Year-Over_Year Growth------
WITH yearly AS(
	SELECT YEAR_ID, SUM(SALES) AS revenue
	FROM sales_data_sample
	GROUP BY YEAR_ID
)
SELECT YEAR_ID,
	   revenue,
	   LAG(revenue) OVER (ORDER BY YEAR_ID) AS prev_year,
	   (revenue - LAG(revenue) OVER (ORDER BY YEAR_ID)) /
	   LAG(revenue) OVER (ORDER BY YEAR_ID) * 100 AS yoy_growth
FROM yearly;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
