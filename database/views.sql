-- ============================================================
-- VIEWS.SQL
-- Представления для последующего BI-анализа
-- ============================================================


-- ============================================================
-- 1. Представление заявок
-- ============================================================
-- Объединяет заявки с информацией о клиентах
-- и автомобилях.
--
-- Используется для анализа количества заявок,
-- их статусов, дат обслуживания и клиентов.

CREATE OR REPLACE VIEW vw_requests AS
SELECT
    sr.request_id,
    c.customer_id,
    c.full_name AS customer,
    c.phone,
    v.vehicle_id,
    v.brand,
    v.model,
    v.plate_number,
    v.mileage,
    sr.service_date,
    sr.service_time,
    sr.status,
    sr.comment
FROM service_requests sr
JOIN vehicles v
    ON v.vehicle_id = sr.vehicle_id
JOIN customers c
    ON c.customer_id = v.customer_id;


-- ============================================================
-- 2. Представление заказ-нарядов
-- ============================================================
-- Содержит информацию о заказ-нарядах,
-- связанных заявках, клиентах и автомобилях.
--
-- Используется для анализа стоимости обслуживания
-- и количества выполненных заказов.

CREATE OR REPLACE VIEW vw_service_orders AS
SELECT
    so.order_id,
    so.request_id,
    c.customer_id,
    c.full_name AS customer,
    v.vehicle_id,
    v.brand,
    v.model,
    v.plate_number,
    sr.service_date,
    sr.service_time,
    so.status,
    so.total_cost
FROM service_orders so
JOIN service_requests sr
    ON sr.request_id = so.request_id
JOIN vehicles v
    ON v.vehicle_id = sr.vehicle_id
JOIN customers c
    ON c.customer_id = v.customer_id;


-- ============================================================
-- 3. Представление выполненных работ
-- ============================================================
-- Показывает состав работ по каждому заказ-наряду.
--
-- Для каждой работы рассчитывается её итоговая стоимость:
-- количество × цена.

CREATE OR REPLACE VIEW vw_order_works AS
SELECT
    so.order_id,
    sr.request_id,
    c.customer_id,
    c.full_name AS customer,
    v.vehicle_id,
    v.brand,
    v.model,
    v.plate_number,
    sr.service_date,
    w.work_id,
    w.name AS work,
    ow.quantity,
    w.price,
    ow.quantity * w.price AS work_total
FROM service_orders so
JOIN service_requests sr
    ON sr.request_id = so.request_id
JOIN vehicles v
    ON v.vehicle_id = sr.vehicle_id
JOIN customers c
    ON c.customer_id = v.customer_id
JOIN order_works ow
    ON ow.order_id = so.order_id
JOIN works w
    ON w.work_id = ow.work_id;


-- ============================================================
-- 4. Представление использованных запчастей
-- ============================================================
-- Показывает запчасти, использованные в заказ-нарядах.
--
-- Для каждой позиции рассчитывается итоговая стоимость:
-- количество × цена.

CREATE OR REPLACE VIEW vw_order_parts AS
SELECT
    so.order_id,
    sr.request_id,
    c.customer_id,
    c.full_name AS customer,
    v.vehicle_id,
    v.brand,
    v.model,
    v.plate_number,
    sr.service_date,
    p.part_id,
    p.name AS part,
    p.article,
    op.quantity,
    p.price,
    op.quantity * p.price AS parts_total
FROM service_orders so
JOIN service_requests sr
    ON sr.request_id = so.request_id
JOIN vehicles v
    ON v.vehicle_id = sr.vehicle_id
JOIN customers c
    ON c.customer_id = v.customer_id
JOIN order_parts op
    ON op.order_id = so.order_id
JOIN parts p
    ON p.part_id = op.part_id;


-- ============================================================
-- 5. Представление складских остатков
-- ============================================================
-- Содержит информацию о запчастях, их ценах
-- и текущем количестве на складе.
--
-- Используется для контроля складских запасов
-- и определения необходимости пополнения.

CREATE OR REPLACE VIEW vw_parts_stock AS
SELECT
    part_id,
    name AS part,
    article,
    price,
    quantity,
    CASE
        WHEN quantity < 5 THEN 'LOW'
        ELSE 'OK'
    END AS stock_status
FROM parts;


-- ============================================================
-- 6. Представление активности клиентов
-- ============================================================
-- Показывает количество автомобилей и заявок
-- каждого клиента.
--
-- Используется для анализа клиентской активности.

CREATE OR REPLACE VIEW vw_customer_activity AS
SELECT
    c.customer_id,
    c.full_name AS customer,
    c.phone,
    COUNT(DISTINCT v.vehicle_id) AS vehicles_count,
    COUNT(sr.request_id) AS requests_count
FROM customers c
LEFT JOIN vehicles v
    ON v.customer_id = c.customer_id
LEFT JOIN service_requests sr
    ON sr.vehicle_id = v.vehicle_id
GROUP BY
    c.customer_id,
    c.full_name,
    c.phone;


-- ============================================================
-- 7. Представление месячной выручки
-- ============================================================
-- Показывает выручку автосервиса по месяцам.
--
-- Учитываются только завершённые заказ-наряды.
-- Представление удобно использовать непосредственно
-- для построения графика выручки в Power BI.

CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    DATE_TRUNC('month', sr.service_date) AS month,
    COUNT(so.order_id) AS completed_orders,
    SUM(so.total_cost) AS revenue,
    ROUND(AVG(so.total_cost), 2) AS average_order_cost
FROM service_orders so
JOIN service_requests sr
    ON sr.request_id = so.request_id
WHERE so.status = 'COMPLETED'
GROUP BY DATE_TRUNC('month', sr.service_date);


-- ============================================================
-- 8. Представление популярных работ
-- ============================================================
-- Показывает количество выполнения каждого вида работ
-- и их общую стоимость.
--
-- Используется для определения наиболее востребованных
-- услуг автосервиса.

CREATE OR REPLACE VIEW vw_work_statistics AS
SELECT
    w.work_id,
    w.name AS work,
    SUM(ow.quantity) AS quantity_performed,
    SUM(ow.quantity * w.price) AS revenue
FROM order_works ow
JOIN works w
    ON w.work_id = ow.work_id
GROUP BY
    w.work_id,
    w.name;
