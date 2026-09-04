-- =============================================================================
-- КОГОРТНЫЙ АНАЛИЗ (УДЕРЖАНИЕ КЛИЕНТОВ)
-- Определяем первую покупку клиента и отслеживаем его возвращаемость по месяцам
-- =============================================================================

-- Объяснение: 
-- 1. Определяем месяц первой покупки каждого клиента (когорта).
-- 2. Считаем активность клиентов в последующие месяцы.
-- 3. Сравниваем активность текущего месяца с базовым месяцем когорты, чтобы получить процент удержания.

CREATE OR REPLACE VIEW v_cohort_retention AS
WITH cohort AS (
    SELECT customer_id, TO_CHAR(MIN(order_time), 'YYYY-MM') AS cohort_month
    FROM orders
    GROUP BY customer_id
),
activity AS (
    SELECT DISTINCT o.customer_id, TO_CHAR(o.order_time, 'YYYY-MM') AS order_month
    FROM orders o
    JOIN cohort c ON o.customer_id = c.customer_id
    WHERE TO_CHAR(o.order_time, 'YYYY-MM') >= c.cohort_month
),
retention_counts AS (
    SELECT c.cohort_month, a.order_month, COUNT(DISTINCT a.customer_id) AS users
    FROM cohort c
    JOIN activity a ON c.customer_id = a.customer_id
    GROUP BY c.cohort_month, a.order_month
),
first_month_counts AS (
    SELECT cohort_month, MAX(users) AS base_users
    FROM retention_counts
    WHERE order_month = cohort_month
    GROUP BY cohort_month
)
SELECT rc.cohort_month, rc.order_month, rc.users,
       ROUND(100.0 * rc.users / fm.base_users, 2) AS retention_pct
FROM retention_counts rc
JOIN first_month_counts fm ON rc.cohort_month = fm.cohort_month
ORDER BY rc.cohort_month, rc.order_month;
