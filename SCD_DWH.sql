--SCD 1 Update DIM_Customer

UPDATE d
SET
    d.BuyingGroupName       = s.BuyingGroupName,
    d.LoadNumber            = ?
FROM WWI_DWH.dbo.DimCustomer d
JOIN WWI_DWH.dbo.DimCustomerVW s
  ON d.CustomerID = s.CustomerID
WHERE d.ValidTo IS NULL
-- nincs SCD2 változás
AND NOT (
       ISNULL(d.CustomerName, '')           <> ISNULL(s.CustomerName, '')
    OR ISNULL(d.CategoryName, '')           <> ISNULL(s.CategoryName, '')
    OR ISNULL(d.DeliveryCityName, '')       <> ISNULL(s.DeliveryCityName, '')
    OR ISNULL(d.DeliveryStateProvince, '')  <> ISNULL(s.DeliveryStateProvince, '')
    OR ISNULL(d.DeliveryCountry, '')        <> ISNULL(s.DeliveryCountry, '')
)
-- van SCD1 változás
AND (
    ISNULL(d.BuyingGroupName, '') <> ISNULL(s.BuyingGroupName, '')
);
SELECT @@ROWCOUNT;

--SCD2 Update DIM_Customer

UPDATE d
SET
    d.ValidTo       = DATEADD(DAY, -1, CAST(GETDATE() AS DATE)),
    d.LoadNumber    = ?
FROM WWI_DWH.dbo.DimCustomer d
JOIN WWI_DWH.dbo.DimCustomerVW s
  ON d.CustomerID = s.CustomerID
WHERE d.ValidTo IS NULL
AND (
       ISNULL(d.CustomerName, '')           <> ISNULL(s.CustomerName, '')
    OR ISNULL(d.CategoryName, '')           <> ISNULL(s.CategoryName, '')
    OR ISNULL(d.DeliveryCityName, '')       <> ISNULL(s.DeliveryCityName, '')
    OR ISNULL(d.DeliveryStateProvince, '')  <> ISNULL(s.DeliveryStateProvince, '')
    OR ISNULL(d.DeliveryCountry, '')        <> ISNULL(s.DeliveryCountry, '')
);
SELECT @@ROWCOUNT;

--SCD2 Insert DIM_Customer

INSERT INTO WWI_DWH.dbo.DimCustomer (
    CustomerID,
    CustomerName,
    CategoryName,
    BuyingGroupName,
    DeliveryCityName,
    DeliveryStateProvince,
    DeliveryCountry,
    ValidFrom,
    ValidTo,
    LoadNumber
)
SELECT
    s.CustomerID,
    s.CustomerName,
    s.CategoryName,
    s.BuyingGroupName,
    s.DeliveryCityName,
    s.DeliveryStateProvince,
    s.DeliveryCountry,
    CAST(GETDATE() AS DATE) AS ValidFrom,
   CAST('9999-12-31' AS DATE)                    AS ValidTo,
    ?                       AS LoadNumber
FROM WWI_DWH.dbo.DimCustomerVW s
LEFT JOIN WWI_DWH.dbo.DimCustomer d
  ON d.CustomerID = s.CustomerID
 AND d.ValidTo =  CAST('9999-12-31' as Date)
whERE d.CustomerID IS NULL;
SELECT @@ROWCOUNT;


--SCD 1 DIM_Product

UPDATE d 
SET
    d.UnitPrice     = s.UnitPrice,
    d.TaxRate       = s.TaxRate,
    d.LoadNumber    = ?
FROM WWI_DWH.dbo.DimProduct d
JOIN WWI_DWH.dbo.DimProductVW s
  ON d.StockItemID = s.StockItemID
WHERE d.ValidTo = CAST('9999-12-31' as date)
-- nincs SCD2 változás
AND NOT (
       ISNULL(d.StockItemName, '')      <> ISNULL(s.StockItemName, '')
    OR ISNULL(d.Brand, '')              <> ISNULL(s.Brand, '')
    OR ISNULL(d.Size, '')               <> ISNULL(s.Size, '')
    OR ISNULL(d.ColorName, '')          <> ISNULL(s.ColorName, '')
    OR ISNULL(d.UnitPackageName, '')    <> ISNULL(s.UnitPackageName, '')
    OR ISNULL(d.OuterPackageName, '')   <> ISNULL(s.OuterPackageName, '')
    OR ISNULL(d.StockGroupName, '')     <> ISNULL(s.StockGroupName, '')
)
-- van SCD1 változás
AND (
       ISNULL(d.UnitPrice, 0)   <> ISNULL(s.UnitPrice, 0)
    OR ISNULL(d.TaxRate, 0)     <> ISNULL(s.TaxRate, 0)
);
SELECT @@ROWCOUNT;

--SCD2  update DIM product

UPDATE d
SET d.ValidTo = DATEADD(DAY, -1, CAST(GETDATE() AS DATE)),
    d.LoadNumber = ?
FROM WWI_DWH.dbo.DimProduct d 
JOIN WWI_DWH.dbo.DimProductVW s ON d.StockItemID = s.StockItemID
WHERE d.ValidTo = CAST('9999-12-31' as DATE)
  AND (ISNULL(d.StockItemName, '') <> ISNULL(s.StockItemName, '') OR
       ISNULL(d.Brand, '') <> ISNULL(s.Brand, '') OR
       ISNULL(d.Size, '') <> ISNULL(s.Size, '') OR
       ISNULL(d.ColorName, '') <> ISNULL(s.ColorName, '') OR
       ISNULL(d.UnitPackageName, '') <> ISNULL(s.UnitPackageName, '') OR
       ISNULL(d.OuterPackageName, '') <> ISNULL(s.OuterPackageName, '') OR
       ISNULL(d.StockGroupName, '') <> ISNULL(s.StockGroupName, ''));

SELECT @@ROWCOUNT;

--SCD 2 Insert dim product


INSERT INTO WWI_DWH.dbo.DimProduct (
    StockItemID,
    StockItemName,
    Brand,
    Size,
    ColorName,
    UnitPackageName,
    OuterPackageName,
    StockGroupName,
    UnitPrice,
    TaxRate,
    ValidFrom,
    ValidTo,
    LoadNumber
)
SELECT
     DISTINCT s.StockItemID,
    s.StockItemName,
    s.Brand,
    s.Size,
    s.ColorName,
    s.UnitPackageName,
    s.OuterPackageName,
    s.StockGroupName,
    s.UnitPrice,
    s.TaxRate,
    CAST(GETDATE() AS DATE) AS ValidFrom,
    CAST('9999-12-31' AS DATE)                   AS ValidTo,
    ?                       AS LoadNumber
FROM WWI_DWH.dbo.DimProductVW s
LEFT JOIN WWI_DWH.dbo.DimProduct d
  ON d.StockItemID = s.StockItemID
 AND d.ValidTo  =  CAST('9999-12-31' as Date)
WHERE d.StockItemID IS NULL;
SELECT @@ROWCOUNT;

WITH CTE AS (
    SELECT StockItemID, 
           ROW_NUMBER() OVER (PARTITION BY StockItemID ORDER BY ValidFrom DESC) as rn
    FROM WWI_DWH.dbo.DimProduct
    WHERE ValidTo = CAST('9999-12-31' AS DATE)
)
DELETE FROM CTE WHERE rn > 1;


--SCD1 Update SalesPerson

UPDATE d
SET
    d.IsSalesperson = s.IsSalesperson,
    d.LoadNumber    = ?
FROM WWI_DWH.dbo.DimSalesperson d
JOIN WWI_DWH.dbo.DimSalespersonVW s
  ON d.PersonID = s.PersonID
WHERE d.ValidTo IS NULL
-- nincs SCD2 változás
AND NOT (
    ISNULL(d.FullName, '') <> ISNULL(s.FullName, '')
)
-- van SCD1 változás
AND (
    ISNULL(d.IsSalesperson, 0) <> ISNULL(s.IsSalesperson, 0)
);
SELECT @@ROWCOUNT;


--SCD2 Update SAlesperson

UPDATE d
SET
    d.ValidTo       = DATEADD(DAY, -1, CAST(GETDATE() AS DATE)),
    d.LoadNumber    = ?
FROM WWI_DWH.dbo.DimSalesperson d
JOIN WWI_DWH.dbo.DimSalespersonVW s
  ON d.PersonID = s.PersonID
WHERE d.ValidTo IS NULL
AND (
    ISNULL(d.FullName, '') <> ISNULL(s.FullName, '')
);
SELECT @@ROWCOUNT;

--SCD2 Insert SalesPerson
INSERT INTO WWI_DWH.dbo.DimSalesperson (
    PersonID,
    FullName,
    IsSalesperson,
    ValidFrom,
    ValidTo,
    LoadNumber
)
SELECT
    s.PersonID,
    s.FullName,
    s.IsSalesperson,
    CAST(GETDATE() AS DATE) AS ValidFrom,
    CAST('9999-12-31' AS DATE) AS ValidTo, -- Itt volt a hiba, most már tiszta
    ? AS LoadNumber
FROM WWI_DWH.dbo.DimSalespersonVW s
LEFT JOIN WWI_DWH.dbo.DimSalesperson d
  ON d.PersonID = s.PersonID
 AND d.ValidTo =  CAST('9999-12-31' as Date)
WHERE d.PersonID IS NULL;

SELECT @@ROWCOUNT;


--scd1 update Deliverymethod

UPDATE d
 SET
    d.DeliveryMethodName    = s.DeliveryMethodName,
    d.LoadNumber            = ?
FROM WWI_DWH.dbo.DimDeliveryMethod d
JOIN WWI_DWH.dbo.DimDeliveryMethodVW s
  ON d.DeliveryMethodID = s.DeliveryMethodID
WHERE
    ISNULL(d.DeliveryMethodName, '') <> ISNULL(s.DeliveryMethodName, '');
SELECT @@ROWCOUNT;

--SCD1 Insert DeliveryMethods

INSERT INTO WWI_DWH.dbo.DimDeliveryMethod (
    DeliveryMethodID,
    DeliveryMethodName,
    ValidFrom,
    ValidTo,
    LoadNumber
)
SELECT
    s.DeliveryMethodID,
    s.DeliveryMethodName,
    CAST(GETDATE() AS DATE) AS ValidFrom,
    CAST('9999-12-31' AS DATE) AS ValidTo, -- Itt javítva: elég egy CAST és nincs felesleges zárójel
    ? AS LoadNumber
FROM WWI_DWH.dbo.DimDeliveryMethodVW s
LEFT JOIN WWI_DWH.dbo.DimDeliveryMethod d
  ON d.DeliveryMethodID = s.DeliveryMethodID
WHERE d.DeliveryMethodID IS NULL;

SELECT @@ROWCOUNT;


--SCD1 Update dim City 

UPDATE d
SET
    d.CityName          = s.CityName,
    d.StateProvinceName = s.StateProvinceName,
    d.CountryName       = s.CountryName,
    d.Continent         = s.Continent,
    d.SalesTerritory    = s.SalesTerritory,
    d.LoadNumber        = ?
FROM WWI_DWH.dbo.DimCity d
JOIN WWI_DWH.dbo.DimCityVW s
  ON d.CityID = s.CityID
WHERE
       ISNULL(d.CityName, '')           <> ISNULL(s.CityName, '')
    OR ISNULL(d.StateProvinceName, '')  <> ISNULL(s.StateProvinceName, '')
    OR ISNULL(d.CountryName, '')        <> ISNULL(s.CountryName, '')
    OR ISNULL(d.Continent, '')          <> ISNULL(s.Continent, '')
    OR ISNULL(d.SalesTerritory, '')     <> ISNULL(s.SalesTerritory, '');
SELECT @@ROWCOUNT;

--SCD1 insert dim city 
INSERT INTO WWI_DWH.dbo.DimCity (
    CityID,
    CityName,
    StateProvinceName,
    CountryName,
    Continent,
    SalesTerritory,
    ValidFrom,
    ValidTo,
    LoadNumber
)
SELECT
    s.CityID,
    s.CityName,
    s.StateProvinceName,
    s.CountryName,
    s.Continent,
    s.SalesTerritory,
    CAST(GETDATE() AS DATE) AS ValidFrom,
    CAST('9999-12-31' AS DATE) AS ValidTo, -- Javítva: felesleges dupla CAST törölve
    ? AS LoadNumber
FROM WWI_DWH.dbo.DimCityVW s
LEFT JOIN WWI_DWH.dbo.DimCity d
  ON d.CityID = s.CityID
WHERE d.CityID IS NULL;

SELECT @@ROWCOUNT;

--insert FactSales


INSERT INTO WWI_DWH.dbo.FactSales (
    InvoiceLineID,
    InvoiceID,
    DimDateKey,
    DimCustomerID,
    DimProductID,
    DimSalespersonID,
    DimDeliveryMethodID,
    DimCityID,
    Quantity,
    UnitPrice,
    TaxRate,
    TaxAmount,
    LineProfit,
    ExtendedPrice,
    LoadNumber
)
SELECT
    src.InvoiceLineID,
    src.InvoiceID,
    src.DateKey                 AS DimDateKey,
    dc.CustomerID,
    dp.StockItemID,
    ds.PersonID,
    ddm.DeliveryMethodID,
    dci.CityID,
    src.Quantity,
    src.UnitPrice,
    src.TaxRate,
    src.TaxAmount,
    src.LineProfit,
    src.ExtendedPrice,
    ?                           AS LoadNumber
FROM WWI_DWH.dbo.FactSalesVW src
    JOIN WWI_DWH.dbo.DimCustomer dc
        ON dc.CustomerID = src.CustomerID
       AND dc.ValidTo = CAST('9999-12-31' AS DATE)
    JOIN WWI_DWH.dbo.DimProduct dp
        ON dp.StockItemID = src.StockItemID
       AND dp.ValidTo = CAST('9999-12-31' AS DATE)
    JOIN WWI_DWH.dbo.DimSalesperson ds
        ON ds.PersonID = src.PersonID
       AND ds.ValidTo = CAST('9999-12-31' AS DATE)
    JOIN WWI_DWH.dbo.DimDeliveryMethod ddm
        ON ddm.DeliveryMethodID = src.DeliveryMethodID
       AND ddm.ValidTo = CAST('9999-12-31' AS DATE)
    JOIN WWI_DWH.dbo.DimCity dci
        ON dci.CityID = src.CityID
       AND dci.ValidTo = CAST('9999-12-31' AS DATE)
LEFT JOIN WWI_DWH.dbo.FactSales f
    ON f.InvoiceLineID = src.InvoiceLineID
WHERE f.InvoiceLineID IS NULL;
SELECT @@ROWCOUNT;