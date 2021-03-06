#TOP COUNTRIES WITH % YEAR 

SELECT c.customernumber, p.paymentdate, YEAR(p.paymentdate) as Observed_Year, MONTHNAME(p.paymentDate) as Observed_month,

    oe.country, oe.territory, SUM(p.amount) as Total_Sales_Amount,

	RANK() OVER(PARTITION BY YEAR(p.paymentdate), MONTH(p.paymentDate) ORDER BY SUM(p.amount) DESC) as International_Country_Rank,

    SUM(SUM(p.amount)) OVER (PARTITION BY YEAR(p.paymentdate)) as cumulative_amount,

    SUM(p.amount) * 100 / (SUM(SUM(p.amount)) OVER (PARTITION BY YEAR(p.paymentdate))) as percentage_final


		FROM payments p

            JOIN customers c ON p.customerNumber = c.customerNumber
            JOIN employees e ON e.employeenumber = c.salesrepemployeenumber
            JOIN offices oe ON e.officecode = oe.officecode
        WHERE oe.country IS NOT NULL
		GROUP BY oe.country, YEAR(p.paymentdate), MONTH(p.paymentDate)
		ORDER BY YEAR(p.paymentdate) DESC, MONTH(p.paymentDate), International_Country_Rank
    
    
    
                                                    ------------------------------------------
    
    
    #TOP OFFICES % YEAR

SELECT c.customernumber, p.paymentdate, YEAR(p.paymentdate) as Observed_Year, MONTHNAME(p.paymentDate) as Observed_month,

    oe.officeCode, oe.postalcode, oe.addressline1, oe.addressline2, oe.state, oe.city, oe.country, oe.territory,

    SUM(p.amount) as Total_Sales_Amount,
    
	RANK() OVER(PARTITION BY YEAR(p.paymentdate), MONTH(p.paymentDate) ORDER BY SUM(p.amount) DESC) as International_Office_Rank,

    SUM(SUM(p.amount)) OVER (PARTITION BY YEAR(p.paymentdate)) as cumulative_amount,

    SUM(p.amount) * 100 / (SUM(SUM(p.amount)) OVER (PARTITION BY YEAR(p.paymentdate))) as percentage_final

		FROM payments p
            JOIN customers c ON p.customerNumber = c.customerNumber
            JOIN employees e ON e.employeenumber = c.salesrepemployeenumber
            JOIN offices oe ON e.officecode = oe.officecode
        WHERE oe.officecode IS NOT NULL
		GROUP BY oe.officecode, YEAR(p.paymentdate), MONTH(p.paymentDate)
		ORDER BY YEAR(p.paymentdate) DESC, MONTH(p.paymentDate), International_Office_Rank
    
    
    
                                                   ------------------------------------------
    
    
    
    #TOP SELLERS % YEAR

SELECT *, round(percentage_global * 100 / total_percentagemonth, 2) as percentage_sales_in_month
	FROM
    
		(SELECT *, SUM(percentage_global) OVER (PARTITION BY observed_year) as total_percentagemonth
		FROM
        
			(SELECT c.customernumber, p.paymentdate, YEAR(p.paymentdate) as Observed_Year, MONTHNAME(p.paymentDate) as Observed_month,
			e.firstName as First_Name, e.lastName as Last_Name, oe.city as City_Office, oe.country as City_Country, SUM(p.amount) as Total_Sales_Amount,
			RANK() OVER(PARTITION BY YEAR(p.paymentdate), MONTH(p.paymentDate) ORDER BY SUM(p.amount) DESC) as rank_Sales,
			SUM(p.amount) * 100 / (SELECT SUM(amount) FROM payments) as percentage_global
                FROM payments p
                    JOIN customers c ON p.customerNumber = c.customerNumber
                    JOIN employees e ON e.employeenumber = c.salesrepemployeenumber
                    JOIN offices oe ON e.officecode = oe.officecode
                WHERE c.salesrepemployeenumber IS NOT NULL
                GROUP BY salesRepEmployeeNumber, YEAR(p.paymentdate), MONTH(p.paymentDate)
                ORDER BY YEAR(p.paymentdate) DESC, MONTH(p.paymentDate), rank_sales)sub1
            
		ORDER BY observed_year DESC, observed_month, rank_sales) sub2
    
    
    
    
                                                    ------------------------------------------
                                                    
     #TOP SELLERS % MARGIN

SELECT *, margin * 100 / total_margin_month as final_percentage
FROM

	(SELECT *, sum(margin) over (partition by year_obs) as total_margin_month
	FROM
    
		(SELECT o.orderdate, o.ordernumber, year(o.requireddate) as year_obs, monthname(o.requireddate), month(o.requireddate) as month_obs, e.employeenumber, e.lastname, e.firstname, ofi.officecode, ofi.city, ofi.country, 
		SUM(od.QuantityOrdered * od.PriceEach) as total_sold,
		SUM(od.QuantityOrdered * od.PriceEach) - SUM(od.QuantityOrdered * p.buyPrice) as Margin
		
        FROM orderdetails od
			JOIN products p ON od.productcode = p.productcode
			JOIN orders o ON od.ordernumber = o.ordernumber 
			JOIN customers c ON c.customernumber = o.customernumber
			JOIN employees e ON e.employeenumber = c.salesrepemployeenumber
			JOIN offices ofi ON ofi.officecode = e.officecode
            WHERE c.salesrepemployeenumber IS NOT NULL
	GROUP BY year(o.requireddate), month(o.requireddate), e.employeenumber 
	ORDER BY year(o.requireddate) desc, month(o.requireddate))sub1
    
ORDER BY year_obs DESC, month_obs) sub2
ORDER BY year_obs DESC, month_obs, final_percentage DESC  