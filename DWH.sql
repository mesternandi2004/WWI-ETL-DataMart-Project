-- DIMENZIONÁLIS MODELL (DWH) ADATBÁZIS - CSILLAGSÉMA
CREATE DATABASE WWI_DWH;
GO
USE WWI_DWH;
GO



CREATE TABLE DimCustomer (
    CustomerID          INT NOT NULL,                   
    CustomerName        NVARCHAR(100),
    CategoryName        NVARCHAR(256),
    BuyingGroupName     NVARCHAR(256),
    DeliveryCityName    NVARCHAR(256),
    DeliveryStateProvince NVARCHAR(256),
    DeliveryCountry     NVARCHAR(60),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT
);

CREATE TABLE DimProduct (
    StockItemID         INT NOT NULL,                  
    StockItemName       NVARCHAR(256),
    Brand               NVARCHAR(50),
    Size                NVARCHAR(20),
    ColorName           NVARCHAR(256),
    UnitPackageName     NVARCHAR(256),
    OuterPackageName    NVARCHAR(256),
    StockGroupName      NVARCHAR(256),
    UnitPrice           DECIMAL(18,2),
    TaxRate             DECIMAL(18,3),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT
);

CREATE TABLE DimSalesperson (
    PersonID            INT NOT NULL,                  
    FullName            NVARCHAR(256),
    IsSalesperson       BIT,
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT
);

CREATE TABLE DimDeliveryMethod (
    DeliveryMethodID    INT NOT NULL,                 
    DeliveryMethodName  NVARCHAR(256),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT
);

CREATE TABLE DimCity (
    CityID              INT NOT NULL,                   
    CityName            NVARCHAR(256),
    StateProvinceName   NVARCHAR(256),
    CountryName         NVARCHAR(60),
    Continent           NVARCHAR(30),
    SalesTerritory      NVARCHAR(50),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT
);

CREATE TABLE FactSales (
    InvoiceLineID       INT NOT NULL,                 
    InvoiceID           INT NOT NULL,
    DimDateKey          INT NOT NULL,
    DimCustomerID       INT NOT NULL,
    DimProductID        INT NOT NULL,
    DimSalespersonID    INT NOT NULL,
    DimDeliveryMethodID INT NOT NULL,
    DimCityID           INT NOT NULL,
    Quantity            INT NOT NULL,
    UnitPrice           DECIMAL(18,2),
    TaxRate             DECIMAL(18,3),
    TaxAmount           DECIMAL(18,2),
    LineProfit          DECIMAL(18,2),
    ExtendedPrice       DECIMAL(18,2),
    LoadNumber          BIGINT

    
  
);




