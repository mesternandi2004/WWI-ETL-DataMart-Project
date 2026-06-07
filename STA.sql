---Stage adatbázis
CREATE DATABASE WWI_Stage;
GO
USE WWI_Stage;
GO

CREATE TABLE STA_Invoices (
    InvoiceID           INT NOT NULL,
    CustomerID          INT,
    BillToCustomerID    INT,
    OrderID             INT,
    DeliveryMethodID    INT,
    ContactPersonID     INT,
    AccountsPersonID    INT,
    SalespersonPersonID INT,
    PackedByPersonID    INT,
    InvoiceDate         DATE,
    CustomerPurchaseOrderNumber NVARCHAR(256),
    IsCreditNote        BIT,
    CreditNoteReason    NVARCHAR(256),
    Comments            NVARCHAR(256),
    DeliveryInstructions NVARCHAR(256),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_Invoices PRIMARY KEY (InvoiceID, ValidFrom)
);

CREATE TABLE STA_InvoiceLines (
    InvoiceLineID       INT NOT NULL,
    InvoiceID           INT NOT NULL,
    StockItemID         INT,
    Description         NVARCHAR(256),
    PackageTypeID       INT,
    Quantity            INT,
    UnitPrice           DECIMAL(18,2),
    TaxRate             DECIMAL(18,3),
    TaxAmount           DECIMAL(18,2),
    LineProfit          DECIMAL(18,2),
    ExtendedPrice       DECIMAL(18,2),
    LastEditedBy        INT,
    LastEditedWhen      DATETIME2,
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_InvoiceLines PRIMARY KEY (InvoiceLineID, ValidFrom)
);

CREATE TABLE STA_Customers (
    CustomerID          INT NOT NULL,
    CustomerName        NVARCHAR(100),
    BillToCustomerID    INT,
    CustomerCategoryID  INT,
    BuyingGroupID       INT,
    PrimaryContactPersonID INT,
    AlternateContactPersonID INT,
    DeliveryMethodID    INT,
    DeliveryCityID      INT,
    PostalCityID        INT,
    CreditLimit         DECIMAL(18,2),
    AccountOpenedDate   DATE,
    StandardDiscountPercentage DECIMAL(18,3),
    IsStatementSent     BIT,
    IsOnCreditHold      BIT,
    PaymentDays         INT,
    PhoneNumber         NVARCHAR(20),
    FaxNumber           NVARCHAR(20),
    WebsiteURL          NVARCHAR(256),
    DeliveryAddressLine1 NVARCHAR(256),
    DeliveryAddressLine2 NVARCHAR(256),
    DeliveryPostalCode  NVARCHAR(10),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_Customers PRIMARY KEY (CustomerID, ValidFrom)
);

CREATE TABLE STA_CustomerCategories (
    CustomerCategoryID  INT NOT NULL,
    CustomerCategoryName NVARCHAR(256),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_CustomerCategories PRIMARY KEY (CustomerCategoryID, ValidFrom)
);

CREATE TABLE STA_BuyingGroups (
    BuyingGroupID       INT NOT NULL,
    BuyingGroupName     NVARCHAR(256),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_BuyingGroups PRIMARY KEY (BuyingGroupID, ValidFrom)
);

CREATE TABLE STA_People (
    PersonID            INT NOT NULL,
    FullName            NVARCHAR(256),
    PreferredName       NVARCHAR(256),
    IsPermittedToLogon  BIT,
    IsSystemUser        BIT,
    IsEmployee          BIT,
    IsSalesperson       BIT,
    PhoneNumber         NVARCHAR(20),
    FaxNumber           NVARCHAR(20),
    EmailAddress        NVARCHAR(256),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_People PRIMARY KEY (PersonID, ValidFrom)
);

CREATE TABLE STA_StockItems (
    StockItemID         INT NOT NULL,
    StockItemName       NVARCHAR(256),
    SupplierID          INT,
    ColorID             INT,
    UnitPackageID       INT,
    OuterPackageID      INT,
    Brand               NVARCHAR(50),
    Size                NVARCHAR(20),
    LeadTimeDays        INT,
    QuantityPerOuter    INT,
    IsChillerStock      BIT,
    TaxRate             DECIMAL(18,3),
    UnitPrice           DECIMAL(18,2),
    RecommendedRetailPrice DECIMAL(18,2),
    TypicalWeightPerUnit DECIMAL(18,3),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_StockItems PRIMARY KEY (StockItemID, ValidFrom)
);

CREATE TABLE STA_StockGroups (
    StockGroupID        INT NOT NULL,
    StockGroupName      NVARCHAR(256),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_StockGroups PRIMARY KEY (StockGroupID, ValidFrom)
);

CREATE TABLE STA_StockItemStockGroups (
    StockItemStockGroupID INT NOT NULL,
    StockItemID         INT NOT NULL,
    StockGroupID        INT NOT NULL,
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_StockItemStockGroups PRIMARY KEY (StockItemStockGroupID, ValidFrom)
);

CREATE TABLE STA_Colors (
    ColorID             INT NOT NULL,
    ColorName           NVARCHAR(256),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_Colors PRIMARY KEY (ColorID, ValidFrom)
);

CREATE TABLE STA_PackageTypes (
    PackageTypeID       INT NOT NULL,
    PackageTypeName     NVARCHAR(256),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_PackageTypes PRIMARY KEY (PackageTypeID, ValidFrom)
);

CREATE TABLE STA_Cities (
    CityID              INT NOT NULL,
    CityName            NVARCHAR(256),
    StateProvinceID     INT,
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_Cities PRIMARY KEY (CityID, ValidFrom)
);

CREATE TABLE STA_StateProvinces (
    StateProvinceID     INT NOT NULL,
    StateProvinceName   NVARCHAR(256),
    CountryID           INT,
    SalesTerritory      NVARCHAR(256),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
        IsValid                 BIT,

    CONSTRAINT PK_DW_StateProvinces PRIMARY KEY (StateProvinceID, ValidFrom)
);

CREATE TABLE STA_Countries (
    CountryID           INT NOT NULL,
    CountryName         NVARCHAR(60),
    FormalName          NVARCHAR(120),
    Continent           NVARCHAR(30),
    Region              NVARCHAR(30),
    Subregion           NVARCHAR(30),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
    IsValid                 BIT,
    CONSTRAINT PK_DW_Countries PRIMARY KEY (CountryID, ValidFrom)
);

CREATE TABLE STA_DeliveryMethods (
    DeliveryMethodID    INT NOT NULL,
    DeliveryMethodName  NVARCHAR(50),
    ValidFrom           DATE NOT NULL DEFAULT GETDATE(),
    ValidTo             DATE NULL,
    LoadNumber          BIGINT,
    LoadDts             datetime,
    IsValid                 BIT,

    CONSTRAINT PK_DW_DeliveryMethods PRIMARY KEY (DeliveryMethodID, ValidFrom)
);

