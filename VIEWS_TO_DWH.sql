-- SQL NÉZETEK A LOAD FÁZISHOZ (STAGE --> DWH)
USE WWI_DWH;
GO

CREATE OR ALTER VIEW DimCustomerVW AS
SELECT
    c.CustomerID,
    c.CustomerName,
    cc.CustomerCategoryName     AS CategoryName,
    ISNULL(bg.BuyingGroupName, 'N/A') AS BuyingGroupName,
    ci.CityName                 AS DeliveryCityName,
    sp.StateProvinceName        AS DeliveryStateProvince,
    co.CountryName              AS DeliveryCountry
FROM WWI_STAGE.dbo.STA_Customers c
    LEFT JOIN WWI_STAGE.dbo.STA_CustomerCategories cc 
        ON c.CustomerCategoryID = cc.CustomerCategoryID
        AND cc.ValidTo = cast('9999-12-31' as date)
    LEFT JOIN WWI_STAGE.dbo.STA_BuyingGroups bg 
        ON c.BuyingGroupID = bg.BuyingGroupID
        AND bg.ValidTo = cast('9999-12-31' as date)
    LEFT JOIN WWI_STAGE.dbo.STA_Cities ci 
        ON c.DeliveryCityID = ci.CityID
        AND ci.ValidTo = cast('9999-12-31' as date)
    LEFT JOIN WWI_STAGE.dbo.STA_StateProvinces sp 
        ON ci.StateProvinceID = sp.StateProvinceID
        AND sp.ValidTo = cast('9999-12-31' as date)
    LEFT JOIN WWI_STAGE.dbo.STA_Countries co 
        ON sp.CountryID = co.CountryID
        AND co.ValidTo = cast('9999-12-31' as date)
WHERE c.ValidTo = cast('9999-12-31' as date);
GO

CREATE OR ALTER VIEW DimProductVW AS
SELECT
    si.StockItemID,
    si.StockItemName,
    si.Brand,
    si.Size,
    ISNULL(col.ColorName, 'N/A')        AS ColorName,
    up.PackageTypeName                   AS UnitPackageName,
    op.PackageTypeName                   AS OuterPackageName,
    ISNULL(sg.StockGroupName, 'N/A')     AS StockGroupName,
    si.UnitPrice,
    si.TaxRate
FROM WWI_STAGE.dbo.STA_StockItems si
    LEFT JOIN WWI_STAGE.dbo.STA_Colors col 
        ON si.ColorID = col.ColorID
        AND col.ValidTo = cast('9999-12-31' as date)
    LEFT JOIN WWI_STAGE.dbo.STA_PackageTypes up 
        ON si.UnitPackageID = up.PackageTypeID
        AND up.ValidTo = cast('9999-12-31' as date)
    LEFT JOIN WWI_STAGE.dbo.STA_PackageTypes op 
        ON si.OuterPackageID = op.PackageTypeID
        AND op.ValidTo = cast('9999-12-31' as date)
    LEFT JOIN WWI_STAGE.dbo.STA_StockItemStockGroups sisg 
        ON si.StockItemID = sisg.StockItemID
        AND sisg.ValidTo = cast('9999-12-31' as date)
    LEFT JOIN WWI_STAGE.dbo.STA_StockGroups sg 
        ON sisg.StockGroupID = sg.StockGroupID
        AND sg.ValidTo = cast('9999-12-31' as date)
WHERE si.ValidTo = cast('9999-12-31' as date);
GO

CREATE OR ALTER VIEW DimSalespersonVW AS
SELECT
    p.PersonID,
    p.FullName,
    p.IsSalesperson
FROM WWI_STAGE.dbo.STA_People p
WHERE p.IsSalesperson = 1
  AND p.ValidTo = cast('9999-12-31' as date);
GO

CREATE OR ALTER VIEW DimDeliveryMethodVW AS
SELECT
    dm.DeliveryMethodID,
    dm.DeliveryMethodName
FROM WWI_STAGE.dbo.STA_DeliveryMethods dm
WHERE dm.ValidTo = cast('9999-12-31' as date);
GO

CREATE OR ALTER VIEW DimCityVW AS
SELECT
    ci.CityID,
    ci.CityName,
    sp.StateProvinceName,
    co.CountryName,
    co.Continent,
    sp.SalesTerritory
FROM WWI_STAGE.dbo.STA_Cities ci
    INNER JOIN WWI_STAGE.dbo.STA_StateProvinces sp 
        ON ci.StateProvinceID = sp.StateProvinceID
        AND sp.ValidTo = cast('9999-12-31' as date)
    INNER JOIN WWI_STAGE.dbo.STA_Countries co 
        ON sp.CountryID = co.CountryID
        AND co.ValidTo = cast('9999-12-31' as date)
WHERE ci.ValidTo = cast('9999-12-31' as date);
GO


CREATE OR ALTER VIEW FactSalesVW AS
SELECT
    il.InvoiceLineID,
    il.InvoiceID,
    CAST(FORMAT(i.InvoiceDate, 'yyyyMMdd') AS INT) AS DateKey,
    i.CustomerID,
    il.StockItemID,
    i.SalespersonPersonID   AS PersonID,
    i.DeliveryMethodID,
    c.DeliveryCityID        AS CityID,
    il.Quantity,
    il.UnitPrice,
    il.TaxRate,
    il.TaxAmount,
    il.LineProfit,
    il.ExtendedPrice
FROM WWI_STAGE.dbo.STA_InvoiceLines il
    INNER JOIN WWI_STAGE.dbo.STA_Invoices i 
        ON il.InvoiceID = i.InvoiceID
        AND i.ValidTo = cast('9999-12-31' as date)
    INNER JOIN WWI_STAGE.dbo.STA_Customers c 
        ON i.CustomerID = c.CustomerID
        AND c.ValidTo = cast('9999-12-31' as date)
WHERE il.ValidTo = cast('9999-12-31' as date);
GO

