-- Calculate the start and end data period value

-- 1) define the end period
DECLARE @_end_period INT = 202402;

-- 2) 12 month start period
DECLARE @_start_period_12mth INT = @_end_period - 100 + 1;

-- 3) 6 month start period
DECLARE @_start_period_6mth INT =
    CAST(CONVERT(char(6),
                 DATEADD(MONTH, -5,
                         CAST(CONCAT(@_end_period, '01') AS date)),
                 112) AS INT);

-- 4) 3 month start period
DECLARE @_start_period_3mth INT =
    CAST(CONVERT(char(6),
                 DATEADD(MONTH, -2,
                         CAST(CONCAT(@_end_period, '01') AS date)),
                 112) AS INT);

-- 5) 1 month start period
DECLARE @_start_period_1mth INT =
    CAST(CONVERT(char(6),
                 DATEADD(MONTH, -0,
                         CAST(CONCAT(@_end_period, '01') AS date)),
                 112) AS INT);

select @_start_period_12mth as _period_start_12mth, 
       @_start_period_6mth as _period_start_6mth,
       @_start_period_3mth as _period_start_3mth, 
       @_start_period_1mth as _period_start_1mth, 
       @_end_period as _period_end