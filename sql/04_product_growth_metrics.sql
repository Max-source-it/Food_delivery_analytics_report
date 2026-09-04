-- =============================================================================
-- ПРОДУКТОВЫЕ МЕТРИКИ (DAU, WAU, MAU) и СТИКИНЕСС
-- Анализ вовлеченности аудитории
-- =============================================================================

-- Объяснение: Считаем уникальных пользователей по дням (DAU), неделям (WAU) и месяцам (MAU).
-- Затем вычисляем "стикинесс" (липкость) - процент пользователей, которые возвращаются
-- в приложение ежедневно относительно месячной аудитории.

CREATE OR REPLACE VIEW v_growth_metrics AS
WITH daily AS (
    SELECT DATE(order_time) AS day, COUNT(DISTINCT customer_id) AS dau
    FROM orders WHERE status != 'Cancelled' GROUP BY DATE(order_time)
),
weekly AS (
    SELECT DATE_TRUNC('week', order_time) AS week, COUNT(DISTINCT customer_id) AS wau
    FROM orders WHERE status != 'Cancelled' GROUP BY DATE_TRUNC('week', order_time)
),
monthly AS (
    SELECT DATE_TRUNC('month', order_time) AS month, COUNT(DISTINCT customer_id) AS mau
    FROM orders WHERE status != 'Cancelled' GROUP BY DATE_TRUNC('month', order_time)
)
SELECT d.day, d.dau, w.wau, m.mau,
       ROUND(100.0 * d.dau / NULLIF(m.mau, 0), 2) AS stickiness
FROM daily d
LEFT JOIN weekly w ON DATE_TRUNC('week', d.day) = w.week
LEFT JOIN monthly m ON DATE_TRUNC('month', d.day) = m.month;
