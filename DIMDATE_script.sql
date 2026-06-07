-- DimDate GENERÁLÓ TÁROLT ELJÁRÁS
USE WWI_DM;
GO

CREATE OR ALTER PROCEDURE usp_PopulateDimDate
    @StartDate DATE,
    @EndDate   DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentDate DATE = @StartDate;

    WHILE @CurrentDate <= @EndDate
    BEGIN
        INSERT INTO DimDate (
            DateKey, [Date], [Day], [Month], [MonthName],
            [Quarter], [Year], [DayOfWeek], [DayOfWeekName], [IsWeekend]
        )
        VALUES (
            CAST(FORMAT(@CurrentDate, 'yyyyMMdd') AS INT),      
            @CurrentDate,                                        
            DAY(@CurrentDate),                                   
            MONTH(@CurrentDate),                                 
            DATENAME(MONTH, @CurrentDate),                       
            DATEPART(QUARTER, @CurrentDate),                     
            YEAR(@CurrentDate),                                  
            DATEPART(WEEKDAY, @CurrentDate),                     
            DATENAME(WEEKDAY, @CurrentDate),                     
            CASE WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1, 7)  
                 THEN 1 ELSE 0 END
        );

        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END;

    PRINT '>>> DimDate feltöltve: ' 
          + CAST(@StartDate AS NVARCHAR) + ' - ' + CAST(@EndDate AS NVARCHAR);
END;
GO

IF NOT EXISTS (SELECT 1 FROM DimDate)
BEGIN
    EXEC usp_PopulateDimDate '2012-01-01', '2017-12-31';
END;
GO