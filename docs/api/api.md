# REST API

## Версия

`v1`

Базовый URL:

`/api/v1`

---

## Customers

| Метод | Endpoint | Назначение |
|---|---|---|
| GET | `/customers` | Получить список клиентов |
| GET | `/customers/{id}` | Получить клиента |
| POST | `/customers` | Создать клиента |
| PUT | `/customers/{id}` | Изменить клиента |

---

## Vehicles

| Метод | Endpoint | Назначение |
|---|---|---|
| GET | `/vehicles/{id}` | Получить автомобиль |
| POST | `/vehicles` | Добавить автомобиль |
| PUT | `/vehicles/{id}` | Изменить автомобиль |

---

## Requests

| Метод | Endpoint | Назначение |
|---|---|---|
| GET | `/requests` | Получить список заявок |
| GET | `/requests/{id}` | Получить заявку |
| POST | `/requests` | Создать заявку |
| PUT | `/requests/{id}` | Изменить заявку |

---

## Orders

| Метод | Endpoint | Назначение |
|---|---|---|
| GET | `/orders` | Получить список заказов |
| GET | `/orders/{id}` | Получить заказ |
| POST | `/orders` | Создать заказ-наряд |
| PUT | `/orders/{id}` | Изменить заказ |
| PATCH | `/orders/{id}/status` | Изменить статус заказа |

---

## Diagnostics

| Метод | Endpoint | Назначение |
|---|---|---|
| GET | `/orders/{orderId}/diagnostics` | Получить диагностику |
| POST | `/orders/{orderId}/diagnostics` | Сохранить результаты диагностики |

---

## Works

| Метод | Endpoint | Назначение |
|---|---|---|
| GET | `/works` | Получить список работ |
| POST | `/orders/{orderId}/works` | Добавить работу в заказ |

---

## Parts

| Метод | Endpoint | Назначение |
|---|---|---|
| GET | `/parts` | Получить список запчастей |
| GET | `/parts/{id}` | Получить запчасть |
| GET | `/parts/availability` | Проверить наличие запчасти |
