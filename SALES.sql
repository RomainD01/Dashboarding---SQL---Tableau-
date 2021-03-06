SELECT 	orderdate as Date, 
		date_format(orderdate, '%Y') as 'Year', 
		date_format(orderdate, '%M') as 'Month', 
		p.productLine as 'Category', 
        od.orderNumber as 'N° Order',
        p.productCode as 'Ref',
        SUM(od.quantityOrdered) as 'Total Sales',
        SUM(p.buyPrice*od.quantityOrdered) as 'Total Buy',
		SUM(od.quantityOrdered*od.priceEach) as 'Total Turnover',
    
        SUM(od.quantityOrdered*od.priceEach) - SUM(p.buyPrice*od.quantityOrdered) as 'Total Margin',
        ROUND(
				(SUM(od.quantityOrdered*od.priceEach) - SUM(p.buyPrice*od.quantityOrdered)) / SUM(od.quantityOrdered)  , 2
		) as 'Average Margin per Unit',
    
        ROUND(
				(SUM(od.quantityOrdered*od.priceEach) - SUM(p.buyPrice*od.quantityOrdered)) / SUM(p.buyPrice*od.quantityOrdered) *100
		,2) as 'Percentage Margin',
    
		SUM(CASE 
			WHEN YEAR(o.orderDate) = YEAR(NOW()) 
			THEN od.quantityOrdered 
			ELSE NULL 
		END) AS 'Units sold current year',
    
		SUM(CASE 
			WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 
            THEN od.quantityOrdered 
            ELSE NULL 
		END) AS 'Units sold last year',
    
		SUM(CASE 
			WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2 
            THEN od.quantityOrdered 
            ELSE NULL 
		END) AS 'Units sold two years ago',
    
        SUM(CASE 
			WHEN YEAR(o.orderDate) = YEAR(NOW())
			THEN od.quantityOrdered*od.priceEach - p.buyPrice*od.quantityOrdered
			ELSE 0 
        END) AS 'Margin current year',
        
        SUM(CASE 
			WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1
			THEN od.quantityOrdered*od.priceEach - p.buyPrice*od.quantityOrdered
			ELSE 0 
        END) AS 'Margin last year',
        
        SUM(CASE 
			WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2
			THEN od.quantityOrdered*od.priceEach - p.buyPrice*od.quantityOrdered
			ELSE 0 
        END) AS 'Margin two years ago',
        
        (
			ROUND(
				(SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) THEN od.quantityOrdered*od.priceEach ELSE 0 END) -
				SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 THEN od.quantityOrdered*od.priceEach ELSE 0 END))
			, 2)
		) AS 'Turnover between current year & last year',
    
        (
			ROUND(
				(SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 THEN od.quantityOrdered*od.priceEach ELSE 0 END) -
				SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2 THEN od.quantityOrdered*od.priceEach ELSE 0 END))
			, 2)
		) AS 'Turnover between last year & two years ago',
    
        (
			ROUND(
				(SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW())  THEN od.quantityOrdered*od.priceEach - p.buyPrice*od.quantityOrdered ELSE 0 END) -
				SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1  THEN od.quantityOrdered*od.priceEach - p.buyPrice*od.quantityOrdered ELSE 0 END)) /
				SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 THEN od.quantityOrdered*od.priceEach - p.buyPrice*od.quantityOrdered ELSE 0 END) * 100
			, 2)
		) AS 'Margin evolution between current year and last year',
    
		(
			ROUND(
				(SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 THEN od.quantityOrdered*od.priceEach - p.buyPrice*od.quantityOrdered ELSE 0 END) -
				SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2 THEN od.quantityOrdered*od.priceEach - p.buyPrice*od.quantityOrdered ELSE 0 END)) /
				SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2 THEN od.quantityOrdered*od.priceEach - p.buyPrice*od.quantityOrdered ELSE 0 END) * 100
			, 2)
		) AS 'Margin evolution between last year & two years ago',
    
		(
			ROUND(
				(SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) THEN od.quantityOrdered ELSE 0 END) -
				SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 THEN od.quantityOrdered ELSE 0 END))
			, 2)
		) AS 'Delta between current year & last year',
    
		(
			ROUND(
				(SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) -1 THEN od.quantityOrdered ELSE 0 END) -
				SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2 THEN od.quantityOrdered ELSE 0 END))
			, 2)
		) AS 'Delta betweeen last year & two years ago',
    
		(
			ROUND(
			(SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) THEN od.quantityOrdered ELSE 0 END) -
			SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 THEN od.quantityOrdered ELSE 0 END)) /
			SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 THEN od.quantityOrdered ELSE 0 END) * 100
			, 2)
		) AS 'Percentage units sold evolution between current year & last year',
    
		(
			ROUND(
			(SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 THEN od.quantityOrdered ELSE 0 END) -
			SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2 THEN od.quantityOrdered ELSE 0 END)) /
			SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2 THEN od.quantityOrdered ELSE 0 END) * 100
			, 2)
		) AS 'Percentage units sold evolution between last year & two years ago',
    
        (
			ROUND(
			(
				CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 1 THEN od.quantityOrdered ELSE 0 END -
				CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2 THEN od.quantityOrdered ELSE 0 END
			) / 
            (
				SUM(CASE WHEN YEAR(o.orderDate) = YEAR(NOW()) - 2 THEN od.quantityOrdered ELSE 0 END) 
            ) * 100
			, 2)
		) AS 'TEST Percentage units sold evolution between last year & two years ago',
    
        (
			SELECT sum(od2.quantityOrdered) 
            FROM orderdetails od2
            LEFT JOIN products p2 ON od2.productCode = p2.productCode
			WHERE od2.orderNumber <= od.orderNumber AND p2.productLine = p.productLine
		) as 'Cumul',
    
        (
			SELECT sum(od2.quantityOrdered*p2.buyPrice) 
            FROM orderdetails od2
            LEFT JOIN products p2 ON od2.productCode = p2.productCode
			WHERE od2.orderNumber <= od.orderNumber AND p2.productLine = p.productLine
		) as 'Cumul purchase',
    
        (
			SELECT sum(od2.quantityOrdered*od2.priceEach) 
            FROM orderdetails od2
            LEFT JOIN products p2 ON od2.productCode = p2.productCode
			WHERE od2.orderNumber <= od.orderNumber AND p2.productLine = p.productLine
		) as 'Cumul sales',
    
        (
			SELECT sum(od2.quantityOrdered*od2.priceEach) - sum(od2.quantityOrdered*p2.buyPrice)
            FROM orderdetails od2
            LEFT JOIN products p2 ON od2.productCode = p2.productCode
			WHERE od2.orderNumber <= od.orderNumber AND p2.productLine = p.productLine
		) as 'Cumul Margin'
FROM orderdetails od

LEFT JOIN products p
    ON p.productCode = od.productCode
LEFT JOIN  orders o
    ON od.orderNumber = o.orderNumber
    
WHERE od.orderNumber IS NOT NULL AND p.productCode IS NOT NULL AND o.orderNumber IS NOT NULL 
GROUP BY Category, YEAR(o.orderdate), DATE_FORMAT(o.orderDate, "%M")
ORDER BY MONTH(orderdate), productline ASC