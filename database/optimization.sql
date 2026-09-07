-- ============================================================
-- ОПТИМИЗАЦИЯ ЗАПРОСОВ
-- ============================================================

-- Проверка поиска заявок по автомобилю
EXPLAIN ANALYZE
SELECT *
FROM service_requests
WHERE vehicle_id = 2;


-- Проверка поиска заявок по статусу
EXPLAIN ANALYZE
SELECT *
FROM service_requests
WHERE status IN ('NEW', 'CONFIRMED', 'IN_PROGRESS');


-- Проверка выборки заявок по дате
EXPLAIN ANALYZE
SELECT *
FROM service_requests
WHERE service_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY service_date DESC;
