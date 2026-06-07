-- DIMENZIONÁLIS MODELL
CREATE DATABASE WWI_DM;
GO
USE WWI_DM;
GO

CREATE TABLE DimDate (
    DateKey             INT NOT NULL PRIMARY KEY,       
    [Date]              DATE NOT NULL,
    [Day]               TINYINT NOT NULL,
    [Month]             TINYINT NOT NULL,
    [MonthName]         NVARCHAR(15) NOT NULL,
    [Quarter]           TINYINT NOT NULL,
    [Year]              SMALLINT NOT NULL,
    [DayOfWeek]         TINYINT NOT NULL,
    [DayOfWeekName]     NVARCHAR(15) NOT NULL,
    [IsWeekend]         BIT NOT NULL
);

CREATE TABLE DimCustomer (
    DimCustomerID       INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CustomerID          INT NOT NULL,                   
    CustomerName        NVARCHAR(100),
    CategoryName        NVARCHAR(256),
    BuyingGroupName     NVARCHAR(256),
    DeliveryCityName    NVARCHAR(256),
    DeliveryStateProvince NVARCHAR(256),
    DeliveryCountry     NVARCHAR(60),
    
    
);

CREATE TABLE DimProduct (
    DimProductID        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
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
    
    
);

CREATE TABLE DimSalesperson (
    DimSalespersonID    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PersonID            INT NOT NULL,                  
    FullName            NVARCHAR(256),
    IsSalesperson       BIT,
    

);

CREATE TABLE DimDeliveryMethod (
    DimDeliveryMethodID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DeliveryMethodID    INT NOT NULL,                 
    DeliveryMethodName  NVARCHAR(256),
    
    
);

CREATE TABLE DimCity (
    DimCityID           INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CityID              INT NOT NULL,                   
    CityName            NVARCHAR(256),
    StateProvinceName   NVARCHAR(256),
    CountryName         NVARCHAR(60),
    Continent           NVARCHAR(30),
    SalesTerritory      NVARCHAR(50),
    
   
);

CREATE TABLE FactSales (
    FactSalesID         BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    InvoiceLineID       INT NOT NULL,                 
    InvoiceID           INT NOT NULL,
    DimDateKey          INT NOT NULL,
    DimCustomerID       INT NOT NULL,
    DimProductID        INT NOT NULL,
    DimSalespersonID    INT NOT NULL,
    DimDeliveryMethodID INT NOT NULL,
    DimCityID           INT NOT NULL,
    Quantity            INT,
    UnitPrice           DECIMAL(18,2),
    TaxRate             DECIMAL(18,3),
    TaxAmount           DECIMAL(18,2),
    LineProfit          DECIMAL(18,2),
    ExtendedPrice       DECIMAL(18,2),
    

    
    CONSTRAINT FK_FactSales_DimCustomer FOREIGN KEY (DimCustomerID) REFERENCES DimCustomer(DimCustomerID),
    CONSTRAINT FK_FactSales_DimProduct FOREIGN KEY (DimProductID) REFERENCES DimProduct(DimProductID),
    CONSTRAINT FK_FactSales_DimSalesperson FOREIGN KEY (DimSalespersonID) REFERENCES DimSalesperson(DimSalespersonID),
    CONSTRAINT FK_FactSales_DimDeliveryMethod FOREIGN KEY (DimDeliveryMethodID) REFERENCES DimDeliveryMethod(DimDeliveryMethodID),
    CONSTRAINT FK_FactSales_DimCity FOREIGN KEY (DimCityID) REFERENCES DimCity(DimCityID),
    CONSTRAINT FK_FactSales_DimDate FOREIGN KEY (DimDateKey) REFERENCES DimDate(DateKey)
);




