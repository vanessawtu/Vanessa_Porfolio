WITH currentdate AS (
  SELECT date_trunc('day', current_timestamp()) AS start_ts,
         date_add(date_trunc('day', current_timestamp()), 1) AS end_ts
),
checks AS (


  SELECT 'Point_of_sale_transactions' AS table_name,
         COUNT(*) AS rows_today
  FROM Point_of_sale_transactions post
  WHERE post.transaction_date>= (SELECT start_ts FROM currentdate)
  AND post.transaction_date <  (SELECT end_ts   FROM currentdate)
  
  UNION ALL

  SELECT 'member_sales' AS table_name,
         COUNT(*) AS rows_today
  FROM member_sales ms
  WHERE ms.invoice_date>= (SELECT start_ts FROM currentdate)
  AND ms.invoice_date <  (SELECT end_ts   FROM currentdate)
  

  
)
SELECT 'NO_EXPECTED_CURRENT_DATA' AS status, table_name, rows_today
FROM checks
WHERE rows_today = 0;