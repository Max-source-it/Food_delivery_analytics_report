-- =============================================================================
-- ФИНАНСОВЫЕ МЕТРИКИ (ARPPU, AOV, ARPU)
-- Расчет ежемесячной выручки, активных пользователей и ключевых финансовых KPI
-- =============================================================================

-- Объяснение: Сначала считаем помесячную выручку (исключая отмененные заказы),
-- количество платящих клиентов и общее число заказов. Затем на основе этих данных
-- рассчитываем средний доход на платящего пользователя (ARPPU), средний чек (AOV)
-- и средний доход на всех клиентов (ARPU).

CREATE OR REPLACE VIEW v_financial_metrics AS
WITH monthly_data AS (
    SELECT 
        TO_CHAR(o.order_time, 'YYYY-MM') AS month,
        COUNT(DISTINCT o.customer_id) AS paying_users,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * oi.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY TO_CHAR(o.order_time, 'YYYY-MM')
)
SELECT month, paying_users, total_orders, revenue,
       ROUND(revenue / NULLIF(paying_users, 0), 2) AS arppu,
       ROUND(revenue / NULLIF(total_orders, 0), 2) AS aov,
       ROUND(revenue / NULLIF((SELECT COUNT(*) FROM customers), 0), 2) AS arpu
FROM monthly_data;
