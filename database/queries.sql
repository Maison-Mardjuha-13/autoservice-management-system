-- ============================================================
-- QUERIES.SQL
-- Аналитические и проверочные SQL-запросы для базы автосервиса
-- ============================================================


-- ============================================================
-- 1. Список клиентов и их автомобилей
-- ============================================================
-- Запрос выводит всех клиентов и автомобили,
-- которые за ними закреплены.
-- Для каждого автомобиля отображается:
-- марка, модель, государственный номер и пробег.
-- Используется JOIN между таблицами customers и vehicles.

SELECT
    c.customer_id,
    c.full_name,
    c.phone,
    v.brand,
    v.model,
    v.plate_number,
    v.mileage
FROM customers c
JOIN vehicles v
    ON v.customer_id = c.customer_id
ORDER BY c.customer_id;


-- ============================================================
-- 2. Все заявки с информацией о клиенте и машине
-- ============================================================
-- Запрос показывает все заявки на техническое обслуживание.
-- Для каждой заявки выводятся данные клиента,
-- информация об автомобиле, дата и время обслуживания,
-- статус заявки и комментарий.
-- Данные объединяются из таблиц service_requests,
-- vehicles и customers.

SELECT
    sr.request_id,
    c.full_name AS customer,
    v.brand,
    v.model,
    v.plate_number,
    sr.service_date,
    sr.service_time,
    sr.status,
    sr.comment
FROM service_requests sr
JOIN vehicles v
    ON v.vehicle_id = sr.vehicle_id
JOIN customers c
    ON c.customer_id = v.customer_id
ORDER BY sr.service_date, sr.service_time;


-- ============================================================
-- 3. История обслуживания конкретного автомобиля
-- ============================================================
-- Запрос показывает историю обслуживания автомобиля
-- с указанным vehicle_id.
-- В результате отображаются заявки на обслуживание,
-- их статусы, связанные заказ-наряды и их стоимость.
-- LEFT JOIN с service_orders позволяет увидеть заявку,
-- даже если заказ-наряд для неё ещё не создан.
--
-- В данном примере используется автомобиль vehicle_id = 2.

SELECT
    v.brand,
    v.model,
    v.plate_number,
    sr.service_date,
    sr.status AS request_status,
    so.order_id,
    so.status AS order_status,
    so.total_cost
FROM vehicles v
JOIN service_requests sr
    ON sr.vehicle_id = v.vehicle_id
LEFT JOIN service_orders so
    ON so.request_id = sr.request_id
WHERE v.vehicle_id = 2
ORDER BY sr.service_date DESC;


-- ============================================================
-- 4. Состав заказ-наряда: выполненные работы
-- ============================================================
-- Запрос показывает, какие работы входят в конкретный
-- заказ-наряд.
-- Для каждой работы выводится её название, количество,
-- цена и рассчитанная стоимость.
--
-- В данном примере рассматривается заказ-наряд №2.

SELECT
    so.order_id,
    w.name AS work,
    ow.quantity,
    w.price,
    ow.quantity * w.price AS work_total
FROM service_orders so
JOIN order_works ow
    ON ow.order_id = so.order_id
JOIN works w
    ON w.work_id = ow.work_id
WHERE so.order_id = 2;


-- ============================================================
-- 4. Состав заказ-наряда: использованные запчасти
-- ============================================================
-- Запрос показывает запчасти, использованные
-- в конкретном заказ-наряде.
-- Для каждой запчасти выводятся название, артикул,
-- количество, цена и общая стоимость.
--
-- В данном примере рассматривается заказ-наряд №2.

SELECT
    so.order_id,
    p.name AS part,
    p.article,
    op.quantity,
    p.price,
    op.quantity * p.price AS parts_total
FROM service_orders so
JOIN order_parts op
    ON op.order_id = so.order_id
JOIN parts p
    ON p.part_id = op.part_id
WHERE so.order_id = 2;


-- ============================================================
-- 5. Расчёт фактической стоимости заказ-нарядов
-- ============================================================
-- Запрос рассчитывает стоимость работ и запчастей
-- для каждого заказ-наряда.
--
-- calculated_total — стоимость, рассчитанная на основе
-- количества и цены работ и запчастей.
--
-- stored_total — стоимость, которая сохранена
-- непосредственно в таблице service_orders.
--
-- Такой запрос позволяет проверить корректность
-- сохранённой общей стоимости заказ-наряда.

SELECT
    so.order_id,
    COALESCE(SUM(DISTINCT ow.quantity * w.price), 0) AS works_cost,
    COALESCE(SUM(DISTINCT op.quantity * p.price), 0) AS parts_cost,
    COALESCE(SUM(DISTINCT ow.quantity * w.price), 0)
        + COALESCE(SUM(DISTINCT op.quantity * p.price), 0) AS calculated_total,
    so.total_cost AS stored_total
FROM service_orders so
LEFT JOIN order_works ow
    ON ow.order_id = so.order_id
LEFT JOIN works w
    ON w.work_id = ow.work_id
LEFT JOIN order_parts op
    ON op.order_id = so.order_id
LEFT JOIN parts p
    ON p.part_id = op.part_id
GROUP BY so.order_id, so.total_cost
ORDER BY so.order_id;


-- ============================================================
-- 6. Остатки запчастей
-- ============================================================
-- Запрос выводит текущие остатки запчастей на складе.
-- Запчасти сортируются по количеству от меньшего
-- остатка к большему.
--
-- Это позволяет быстро определить запчасти,
-- которые заканчиваются на складе.

SELECT
    part_id,
    name,
    article,
    price,
    quantity
FROM parts
ORDER BY quantity ASC;


-- ============================================================
-- 7. Заявки, которые сейчас требуют работы
-- ============================================================
-- Запрос выводит заявки, которые находятся
-- в рабочих статусах:
-- NEW        — новая заявка;
-- CONFIRMED  — заявка подтверждена;
-- IN_PROGRESS — обслуживание выполняется.
--
-- Такие заявки требуют дальнейшей обработки
-- сотрудниками автосервиса.

SELECT
    sr.request_id,
    c.full_name,
    v.brand,
    v.model,
    sr.service_date,
    sr.service_time,
    sr.status
FROM service_requests sr
JOIN vehicles v
    ON v.vehicle_id = sr.vehicle_id
JOIN customers c
    ON c.customer_id = v.customer_id
WHERE sr.status IN ('NEW', 'CONFIRMED', 'IN_PROGRESS')
ORDER BY sr.service_date, sr.service_time;
