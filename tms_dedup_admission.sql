with
    partitioned
    AS
    (
        SELECT [class_code]
             , [application_id]
             , [admission_status_code]
             , [last_upd_date]
             , ROW_NUMBER() OVER(PARTITION BY [application_id]
                            ORDER BY [last_upd_date] desc) AS seq
        FROM [dbo].[gld_f_tms_admission]
    ),
    admission_dedup
    as
    (
        SELECT *
        FROM partitioned
        WHERE seq = 1
    ),
    agg
    as
    (
        SELECT ap.cic_no, ap.application_id, ap.[apply_date]
        FROM admission_dedup
            left join [dbo].[gld_f_tms_application] ap
            on admission_dedup.[application_id] = ap.[application_id]
    )
select cic_no, max(apply_date) as tms_last_apply_date
from agg
where apply_date is not null
group by cic_no