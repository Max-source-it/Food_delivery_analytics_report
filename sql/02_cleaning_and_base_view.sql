-- =============================================================================
-- ОБЩАЯ ВИТРИНА ДАННЫХ
-- Объединение всех связанных таблиц в единое представление для построения дашбордов
-- =============================================================================

-- Объяснение: Мы связываем 4 таблицы через JOIN (заказы, клиенты, рестораны, позиции заказа),
-- чтобы получить полную картину по каждому заказу. Также считаем выручку по строке.

CREATE OR REPLACE VIEW v_full_orders AS
SELECT 
    o.order_id, o.customer_id, o.restaurant_id, o.order_time, o.delivery_time, o.status,
    r.cuisine, r.city, r.rating, c.signup_date,
    oi.item_id, oi.quantity, oi.price,
    (oi.quantity * oi.price) AS line_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
JOIN order_items oi ON o.order_id = oi.order_id;
