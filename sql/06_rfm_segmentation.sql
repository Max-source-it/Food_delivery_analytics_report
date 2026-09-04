-- =============================================================================
-- RFM-СЕГМЕНТАЦИЯ КЛИЕНТОВ
-- Разбивка базы на сегменты по давности (R), частоте (F) и деньгам (M)
-- =============================================================================

-- Объяснение:
-- 1. Считаем базовые метрики: дату последнего заказа, частоту заказов и общую сумму.
-- 2. Через оконную функцию NTILE делим клиентов на 4 квартиля по каждому показателю.
-- 3. Логикой CASE присваиваем клиентам сегменты (Champions, At Risk и т.д.).

CREATE OR REPLACE VIEW v_customer_rfm AS
WITH rfm_base AS (
    SELECT o.customer_id,
           MAX(o.order_time) AS last_order,
           COUNT(DISTINCT o.order_id) AS frequency,
           SUM(oi.quantity * oi.price) AS monetary
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY o.customer_id
),
rfm_scores AS (
    SELECT *, 
           NTILE(4) OVER (ORDER BY last_order ASC) AS R_Score, 
           NTILE(4) OVER (ORDER BY frequency DESC) AS F_Score,
           NTILE(4) OVER (ORDER BY monetary DESC) AS M_Score
    FROM rfm_base
)
SELECT customer_id, frequency, monetary, R_Score, F_Score, M_Score,
       CASE 
           WHEN R_Score >= 3 AND F_Score >= 3 THEN 'Champions'
           WHEN R_Score >= 3 AND F_Score = 2 THEN 'Potential Loyalists'
           WHEN R_Score <= 2 AND F_Score >= 3 THEN 'At Risk'
           WHEN R_Score = 1 AND F_Score = 1 THEN 'Hibernating'
           ELSE 'Others'
       END AS segment
FROM rfm_scores;
