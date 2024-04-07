USE car_sales;

-- DROP FUNCTION IF EXISTS get_year_month;

-- DELIMITER $$
-- CREATE FUNCTION get_year_month(mode VARCHAR(5))
-- RETURNS INT
-- DETERMINISTIC
-- BEGIN
-- 	DECLARE result INT;
--     IF mode = "year" THEN
-- 		SELECT YEAR(MAX(date)) INTO result FROM sales_data;
-- 	ELSEIF mode = "month" THEN
-- 		SELECT MONTH(MAX(date)) INTO result FROM sales_data;
-- 	ELSE
-- 		SET result = 0;
-- 	END IF;
--     RETURN result;
-- END $$
-- DELIMITER ;




-- 1)	Total Year till Date (YTD) Sales
SELECT
	CONCAT(YTD.total_sales, "M") AS "Total YTD Sales",
    CONCAT(ROUND((YTD.total_sales - PYTD.total_sales), 1), "M") AS "Sales Difference From Previous Year",
    CONCAT(ROUND(((YTD.total_sales - PYTD.total_sales) / PYTD.total_sales) * 100, 1), "%") AS "Sales Growth From Previous Year"
FROM
	(SELECT ROUND((SUM(price) / 1e6), 1) as total_sales
	FROM sales_data
	WHERE YEAR(date) = get_year_month("year")) AS YTD,
    
	(SELECT ROUND((SUM(price) / 1e6), 1) as total_sales
	FROM sales_data
	WHERE 	YEAR(date) = get_year_month("year") - 1 
			AND MONTH(date) <= get_year_month("month")) AS PYTD;
            
            
            
            
-- 2)	Average Year till Date (YTD) Sales
SELECT
	CONCAT(YTD.average_sales, "K") AS "Average YTD Sales",
    CONCAT(YTD.average_sales - PYTD.average_sales, "K") AS "Average Sales Difference from Privous Year",
    CONCAT(ROUND(((YTD.average_sales - PYTD.average_sales) / PYTD.average_sales) * 100, 1), "%") AS "Average Sales Growth from Privous Year"
FROM
	(SELECT
		ROUND(AVG(price), 1) AS average_sales
	FROM sales_data
	WHERE YEAR(date) =  get_year_month("year")) AS YTD,

	(SELECT
		ROUND(AVG(price), 1) AS average_sales
	FROM sales_data
	WHERE 	YEAR(date) = get_year_month("year") - 1
			AND MONTH(date) <= get_year_month("month")) AS PYTD;
            
            
            

-- 3)	Total Year till Date (YTD) Car Sold
SELECT
	CONCAT(YTD.total_car_sold, "K") AS "Total YTD Car Sold",
    CONCAT(YTD.total_car_sold - PYTD.total_car_sold, "K") AS "Car Sold Difference From Previous Year",
    CONCAT(ROUND(((YTD.total_car_sold - PYTD.total_car_sold) / PYTD.total_car_sold) * 100, 1), "%") AS "Car Sold Growth From Previous Year"
FROM
	(SELECT
		COUNT(car_id) AS total_car_sold
	FROM sales_data
	WHERE YEAR(date) = get_year_month("year")) AS YTD,

	(SELECT
		COUNT(car_id) AS total_car_sold
	FROM sales_data
	WHERE 	YEAR(date) = get_year_month("year") - 1 
			AND MONTH(date) <= get_year_month("month")) AS PYTD;






-- 4)	Highest Sales by Week Number by Year till Date (YTD)
SELECT
	WEEK(date) AS weeks,
    SUM(price) AS sales
FROM sales_data
WHERE YEAR(date) = get_year_month("year")
GROUP BY weeks
ORDER BY sales DESC
LIMIT 1;




-- 5)	YTD Total Sales by Body Sales
SELECT
	body_tyle AS body_style,
    SUM(price) AS total_sales
FROM sales_data
WHERE YEAR(date) = get_year_month("year")
GROUP BY body_style
ORDER BY total_sales DESC;





-- 5)	YTD Total Sales by Color
SELECT
	color,
    SUM(price) AS total_sales
FROM sales_data
WHERE YEAR(date) = get_year_month("year")
GROUP BY color
ORDER BY total_sales DESC;




-- 5)	YTD Total Car Sold by Dealer Region
SELECT
	dealer_region,
    COUNT(car_id) AS total_sales
FROM sales_data
WHERE YEAR(date) = get_year_month("year")
GROUP BY dealer_region
ORDER BY total_sales DESC
LIMIT 5;




-- 6) Top 5 YTD Card Sold by Company 
SELECT
	company,
    COUNT(car_id) AS number_of_car_sold
FROM sales_data
WHERE YEAR(date) = get_year_month("year")
GROUP BY company
ORDER BY number_of_car_sold DESC
LIMIT 5;