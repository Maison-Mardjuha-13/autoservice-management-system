-- =========================================================
-- Autoservice Management System
-- Database schema
-- PostgreSQL 17
-- =========================================================

-- ---------------------------------------------------------
-- 1. Customers
-- ---------------------------------------------------------

CREATE TABLE customers (
    customer_id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    email VARCHAR(150)
);

-- ---------------------------------------------------------
-- 2. Vehicles
-- ---------------------------------------------------------

CREATE TABLE vehicles (
    vehicle_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    vin VARCHAR(17) NOT NULL UNIQUE,
    plate_number VARCHAR(20) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INTEGER,
    mileage INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT fk_vehicle_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_vehicle_year
        CHECK (year IS NULL OR year >= 1886),

    CONSTRAINT chk_vehicle_mileage
        CHECK (mileage >= 0)
);

-- ---------------------------------------------------------
-- 3. Service requests
-- ---------------------------------------------------------

CREATE TABLE service_requests (
    request_id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL,
    service_date DATE NOT NULL,
    service_time TIME NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'NEW',
    comment TEXT,

    CONSTRAINT fk_request_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_request_status
        CHECK (
            status IN (
                'NEW',
                'CONFIRMED',
                'IN_PROGRESS',
                'COMPLETED',
                'CANCELLED'
            )
        ),

    CONSTRAINT uq_vehicle_service_datetime
        UNIQUE (vehicle_id, service_date, service_time)
);

-- ---------------------------------------------------------
-- 4. Service orders
-- ---------------------------------------------------------

CREATE TABLE service_orders (
    order_id BIGSERIAL PRIMARY KEY,
    request_id BIGINT NOT NULL UNIQUE,
    status VARCHAR(30) NOT NULL DEFAULT 'OPEN',
    total_cost NUMERIC(12, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_request
        FOREIGN KEY (request_id)
        REFERENCES service_requests(request_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_status
        CHECK (
            status IN (
                'OPEN',
                'DIAGNOSTICS',
                'WAITING_APPROVAL',
                'IN_PROGRESS',
                'QUALITY_CONTROL',
                'READY',
                'COMPLETED',
                'CANCELLED'
            )
        ),

    CONSTRAINT chk_order_total_cost
        CHECK (total_cost >= 0)
);

-- ---------------------------------------------------------
-- 5. Diagnostics
-- ---------------------------------------------------------

CREATE TABLE diagnostics (
    diagnostic_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_diagnostic_order
        FOREIGN KEY (order_id)
        REFERENCES service_orders(order_id)
        ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- 6. Works
-- ---------------------------------------------------------

CREATE TABLE works (
    work_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    price NUMERIC(12, 2) NOT NULL,

    CONSTRAINT chk_work_price
        CHECK (price >= 0)
);

-- ---------------------------------------------------------
-- 7. Parts
-- ---------------------------------------------------------

CREATE TABLE parts (
    part_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    article VARCHAR(100) NOT NULL UNIQUE,
    price NUMERIC(12, 2) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT chk_part_price
        CHECK (price >= 0),

    CONSTRAINT chk_part_quantity
        CHECK (quantity >= 0)
);

-- ---------------------------------------------------------
-- 8. Order works
-- ---------------------------------------------------------

CREATE TABLE order_works (
    order_id BIGINT NOT NULL,
    work_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,

    PRIMARY KEY (order_id, work_id),

    CONSTRAINT fk_order_work_order
        FOREIGN KEY (order_id)
        REFERENCES service_orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_work_work
        FOREIGN KEY (work_id)
        REFERENCES works(work_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_work_quantity
        CHECK (quantity > 0)
);

-- ---------------------------------------------------------
-- 9. Order parts
-- ---------------------------------------------------------

CREATE TABLE order_parts (
    order_id BIGINT NOT NULL,
    part_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,

    PRIMARY KEY (order_id, part_id),

    CONSTRAINT fk_order_part_order
        FOREIGN KEY (order_id)
        REFERENCES service_orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_part_part
        FOREIGN KEY (part_id)
        REFERENCES parts(part_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_part_quantity
        CHECK (quantity > 0)
);

-- =========================================================
-- Indexes
-- =========================================================

CREATE INDEX idx_vehicles_customer_id
    ON vehicles(customer_id);

CREATE INDEX idx_requests_vehicle_id
    ON service_requests(vehicle_id);

CREATE INDEX idx_requests_service_date
    ON service_requests(service_date);

CREATE INDEX idx_requests_status
    ON service_requests(status);

CREATE INDEX idx_orders_status
    ON service_orders(status);

CREATE INDEX idx_diagnostics_order_id
    ON diagnostics(order_id);

CREATE INDEX idx_order_works_work_id
    ON order_works(work_id);

CREATE INDEX idx_order_parts_part_id
    ON order_parts(part_id);

-- =========================================================
-- End of schema
-- =========================================================
