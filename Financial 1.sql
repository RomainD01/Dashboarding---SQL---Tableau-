#PAYMENTS FROM ORDERS LAST TWO MONTHS

SELECT OrderNumber, Country, SUM(total_amt_ordered) as Total_Sales_from_Orders_Last_Two_Months 

FROM

    (SELECT od.ordernumber, o.OrderDate, o.ShippedDate, o.Status, p.ProductCode, p.ProductName, 
    p.ProductLine, od.OrderLineNumber, c.CustomerName, o.CustomerNumber, e.employeenumber, c.Country, od.QuantityOrdered,
    od.PriceEach, SUM(od.QuantityOrdered * od.PriceEach) as Total_Amt_Ordered

    FROM orderdetails od
        JOIN products p ON od.productcode = p.productcode
        JOIN orders o ON od.ordernumber = o.ordernumber 
        JOIN customers c ON c.customernumber = o.customernumber
        JOIN employees e ON e.employeenumber = c.salesrepemployeenumber

    GROUP BY o.ordernumber
    ORDER BY o.ordernumber, od.orderlinenumber) sub4

JOIN

    (SELECT Amount_order as Amount_NotPaidYet, Orders_ToPaidTogether
    FROM
        (SELECT CustomerNumber, OrderNumber, OrderDate, Amount_order,
        SUM(Amount_Order) OVER (PARTITION BY customernumber, status, year_order, part_year) as Orders_ToPaidTogether
            FROM 
                (SELECT o.orderdate, YEAR(orderdate) as year_order, o.status,
                CASE 
                    WHEN MONTH(requireddate) IN (1, 2, 3, 4) THEN 1 
                    WHEN MONTH(requireddate) IN (5, 6, 7, 8) THEN 2
                    WHEN MONTH(requireddate) IN (9, 10) THEN 3
                    ELSE 4 END as part_year,
                o.ordernumber, o.customernumber, SUM(od.quantityordered * od.priceeach) as Amount_order
                FROM orderdetails od
                JOIN orders o ON o.ordernumber = od.ordernumber
                GROUP BY o.ordernumber, o.customernumber
                ORDER by o.customernumber DESC, Amount_Order DESC, o.orderDate) sub1) sub2
    WHERE Orders_ToPaidTogether IN (SELECT amount FROM payments) OR amount_order IN (SELECT amount FROM payments)) sub3

ON sub4.total_amt_ordered = sub3.Amount_NotPaidYet
WHERE MONTH(orderDate) IN (MONTH(NOW()), MONTH(NOW()) - 1, MONTH(NOW()) -2) AND YEAR(orderDate) = YEAR(now())
GROUP BY country
ORDER BY country, sub4.customernumber, sub4.orderdate