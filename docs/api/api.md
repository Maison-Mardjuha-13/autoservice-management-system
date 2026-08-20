# REST API

## Общая информация

REST API системы **AutoService Management System** предназначен для взаимодействия пользовательского интерфейса с серверной частью системы.

### Версия API

`v1`

### Базовый путь

`/api/v1`

### Формат данных

Все запросы и ответы используют формат `JSON`.

---

# Customers — Клиенты

## GET /customers

Получение списка клиентов.

### Response — 200 OK

    [
      {
        "customerId": "CUS-001",
        "fullName": "Иванов Иван Иванович",
        "phone": "+79990000000",
        "email": "ivanov@example.com"
      }
    ]

---

## GET /customers/{customerId}

Получение информации о конкретном клиенте.

### Path parameters

| Параметр | Тип | Описание |
|---|---|---|
| customerId | string | Идентификатор клиента |

### Response — 200 OK

    {
      "customerId": "CUS-001",
      "fullName": "Иванов Иван Иванович",
      "phone": "+79990000000",
      "email": "ivanov@example.com"
    }

### Ошибки

- `404 Not Found` — клиент не найден.

---

## POST /customers

Создание нового клиента.

### Request

    {
      "fullName": "Иванов Иван Иванович",
      "phone": "+79990000000",
      "email": "ivanov@example.com"
    }

### Response — 201 Created

    {
      "customerId": "CUS-001",
      "fullName": "Иванов Иван Иванович",
      "phone": "+79990000000",
      "email": "ivanov@example.com"
    }

### Ошибки

- `400 Bad Request` — некорректные данные.
- `409 Conflict` — клиент с указанными данными уже существует.

---

# Vehicles — Автомобили

## GET /vehicles/{vehicleId}

Получение информации об автомобиле.

### Path parameters

| Параметр | Тип | Описание |
|---|---|---|
| vehicleId | string | Идентификатор автомобиля |

### Response — 200 OK

    {
      "vehicleId": "VEH-001",
      "customerId": "CUS-001",
      "vin": "XTA00000000000001",
      "plateNumber": "A123BC",
      "brand": "Toyota",
      "model": "Camry",
      "year": 2022,
      "mileage": 45000
    }

### Ошибки

- `404 Not Found` — автомобиль не найден.

---

## POST /vehicles

Добавление автомобиля клиенту.

### Request

    {
      "customerId": "CUS-001",
      "vin": "XTA00000000000001",
      "plateNumber": "A123BC",
      "brand": "Toyota",
      "model": "Camry",
      "year": 2022,
      "mileage": 45000
    }

### Response — 201 Created

    {
      "vehicleId": "VEH-001",
      "customerId": "CUS-001",
      "vin": "XTA00000000000001",
      "plateNumber": "A123BC",
      "brand": "Toyota",
      "model": "Camry",
      "year": 2022,
      "mileage": 45000
    }

### Ошибки

- `400 Bad Request` — некорректные данные.
- `404 Not Found` — клиент не найден.
- `409 Conflict` — автомобиль с таким VIN уже существует.

---

# Requests — Заявки

## GET /requests

Получение списка заявок.

### Query parameters

| Параметр | Тип | Описание |
|---|---|---|
| status | string | Фильтр по статусу |
| date | date | Фильтр по дате |

### Response — 200 OK

    [
      {
        "requestId": "REQ-001",
        "vehicleId": "VEH-001",
        "serviceDate": "2026-08-25",
        "serviceTime": "10:00",
        "status": "NEW"
      }
    ]

---

## GET /requests/{requestId}

Получение заявки.

### Path parameters

| Параметр | Тип | Описание |
|---|---|---|
| requestId | string | Идентификатор заявки |

### Response — 200 OK

    {
      "requestId": "REQ-001",
      "vehicleId": "VEH-001",
      "serviceDate": "2026-08-25",
      "serviceTime": "10:00",
      "status": "NEW",
      "comment": "Плановое ТО"
    }

### Ошибки

- `404 Not Found` — заявка не найдена.

---

## POST /requests

Создание заявки на обслуживание.

### Request

    {
      "vehicleId": "VEH-001",
      "serviceDate": "2026-08-25",
      "serviceTime": "10:00",
      "comment": "Плановое ТО"
    }

### Response — 201 Created

    {
      "requestId": "REQ-001",
      "vehicleId": "VEH-001",
      "serviceDate": "2026-08-25",
      "serviceTime": "10:00",
      "status": "NEW",
      "comment": "Плановое ТО"
    }

### Ошибки

- `400 Bad Request` — некорректные данные.
- `404 Not Found` — автомобиль не найден.
- `409 Conflict` — выбранное время уже занято.

---

# Orders — Заказы-наряды

## GET /orders

Получение списка заказов.

### Query parameters

| Параметр | Тип | Описание |
|---|---|---|
| status | string | Фильтр по статусу |
| vehicleId | string | Фильтр по автомобилю |

### Response — 200 OK

    [
      {
        "orderId": "ORD-001",
        "requestId": "REQ-001",
        "status": "WAITING_FOR_SERVICE",
        "totalCost": 12500.00,
        "createdAt": "2026-08-25T10:30:00Z"
      }
    ]

---

## GET /orders/{orderId}

Получение заказа-наряда.

### Path parameters

| Параметр | Тип | Описание |
|---|---|---|
| orderId | string | Идентификатор заказа |

### Response — 200 OK

    {
      "orderId": "ORD-001",
      "requestId": "REQ-001",
      "status": "WAITING_FOR_SERVICE",
      "totalCost": 12500.00,
      "createdAt": "2026-08-25T10:30:00Z"
    }

### Ошибки

- `404 Not Found` — заказ не найден.

---

## POST /orders

Создание заказа-наряда на основании заявки.

### Request

    {
      "requestId": "REQ-001",
      "employeeId": "EMP-001"
    }

### Response — 201 Created

    {
      "orderId": "ORD-001",
      "requestId": "REQ-001",
      "status": "WAITING_FOR_SERVICE",
      "totalCost": 0,
      "createdAt": "2026-08-25T10:30:00Z"
    }

### Ошибки

- `400 Bad Request` — некорректные данные.
- `404 Not Found` — заявка не найдена.
- `409 Conflict` — для заявки уже существует заказ.

---

## PATCH /orders/{orderId}/status

Изменение статуса заказа.

### Path parameters

| Параметр | Тип | Описание |
|---|---|---|
| orderId | string | Идентификатор заказа |

### Request

    {
      "status": "READY_FOR_PICKUP"
    }

### Response — 200 OK

    {
      "orderId": "ORD-001",
      "status": "READY_FOR_PICKUP"
    }

### Возможные статусы

- `WAITING_FOR_SERVICE`
- `DIAGNOSTICS`
- `IN_PROGRESS`
- `WAITING_FOR_APPROVAL`
- `READY_FOR_PICKUP`
- `COMPLETED`
- `CANCELLED`

### Ошибки

- `400 Bad Request` — недопустимый статус.
- `404 Not Found` — заказ не найден.
- `409 Conflict` — переход в выбранный статус невозможен.

---

# Diagnostics — Диагностика

## GET /orders/{orderId}/diagnostics

Получение результатов диагностики.

### Path parameters

| Параметр | Тип | Описание |
|---|---|---|
| orderId | string | Идентификатор заказа |

### Response — 200 OK

    {
      "diagnosticId": "DIA-001",
      "orderId": "ORD-001",
      "description": "Обнаружен износ тормозных колодок.",
      "createdAt": "2026-08-25T12:00:00Z"
    }

---

## POST /orders/{orderId}/diagnostics

Сохранение результатов диагностики.

### Request

    {
      "description": "Обнаружен износ тормозных колодок."
    }

### Response — 201 Created

    {
      "diagnosticId": "DIA-001",
      "orderId": "ORD-001",
      "description": "Обнаружен износ тормозных колодок.",
      "createdAt": "2026-08-25T12:00:00Z"
    }

### Ошибки

- `404 Not Found` — заказ не найден.
- `409 Conflict` — диагностика уже завершена.

---

# Works — Работы

## GET /works

Получение списка доступных работ.

### Response — 200 OK

    [
      {
        "workId": "WRK-001",
        "name": "Замена моторного масла",
        "price": 2500.00
      }
    ]

---

## POST /orders/{orderId}/works

Добавление работы в заказ.

### Path parameters

| Параметр | Тип | Описание |
|---|---|---|
| orderId | string | Идентификатор заказа |

### Request

    {
      "workId": "WRK-001",
      "quantity": 1
    }

### Response — 201 Created

    {
      "orderId": "ORD-001",
      "workId": "WRK-001",
      "quantity": 1,
      "price": 2500.00
    }

---

# Parts — Запчасти

## GET /parts

Получение списка запчастей.

### Response — 200 OK

    [
      {
        "partId": "PRT-001",
        "name": "Масляный фильтр",
        "article": "OF-123",
        "price": 1200.00,
        "quantity": 15
      }
    ]

---

## GET /parts/{partId}

Получение информации о запчасти.

### Path parameters

| Параметр | Тип | Описание |
|---|---|---|
| partId | string | Идентификатор запчасти |

### Response — 200 OK

    {
      "partId": "PRT-001",
      "name": "Масляный фильтр",
      "article": "OF-123",
      "price": 1200.00,
      "quantity": 15
    }

### Ошибки

- `404 Not Found` — запчасть не найдена.

---

## GET /parts/availability

Проверка наличия запчасти.

### Query parameters

| Параметр | Тип | Обязательный | Описание |
|---|---|---|---|
| partId | string | Да | Идентификатор запчасти |

### Пример запроса

    GET /parts/availability?partId=PRT-001

### Response — 200 OK

    {
      "partId": "PRT-001",
      "available": true,
      "quantity": 15
    }

### Ошибки

- `404 Not Found` — запчасть не найдена.

---

# Коды ответа

| Код | Значение |
|---|---|
| 200 | Операция выполнена успешно |
| 201 | Ресурс создан |
| 400 | Некорректный запрос |
| 401 | Пользователь не авторизован |
| 403 | Недостаточно прав |
| 404 | Ресурс не найден |
| 409 | Конфликт данных |
| 500 | Внутренняя ошибка сервера |
