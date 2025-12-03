-- calculate workers' engagement level (12mths)
-- period : from @_start_period to @_end_period

DECLARE @_end_period INT = 202412;
DECLARE @_start_period INT = @_end_period - 100 + 1;

-- select @_start_period, @_end_period

WITH att as (
    select cwr_no,
           man_hours,
           man_days,
           heavily_engaged_threshold,
           casually_engaged_threshold,
           _period
    FROM gld_f_monthly_attendance_rpt
    WHERE _period >= @_start_period
      AND _period <= @_end_period
),
demographic AS (
    SELECT 
        reg.cwr_no, 
        reg.gender, 
        reg.age, 
        reg.cert_trade_code, 
        t.trade_div_name
    FROM gld_f_worker_demographic_rpt reg
    JOIN gld_d_cert_trade t 
      ON reg.cert_trade_code = t.cert_trade_code
    WHERE reg._period = @_end_period
),
agg as (
    SELECT d.cwr_no, d.gender, d.age, d.cert_trade_code, d.trade_div_name,
    sum(att.man_days) as total_md,
    sum(att.man_hours) as total_mh,
    SUM(att.heavily_engaged_threshold) as _he_ratio,
    SUM(att.casually_engaged_threshold) as _le_ratio
    from att
    join demographic d
    on att.cwr_no = d.cwr_no
    group by d.cwr_no, d.gender, d.age, d.cert_trade_code, d.trade_div_name
)

select *,
       case when total_md >= _he_ratio then 'Heavily_Engaged'
            when total_md < _le_ratio then 'Casually_Engaged'
            ELSE 'Moderately_Engaged' END AS 'engagement_level'
from agg