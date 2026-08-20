# Data Dictionary

## Customers

| Поле | Тип | Описание |
|---|---|---|
| customer_id | UUID | Идентификатор клиента |
| full_name | VARCHAR | ФИО клиента |
| phone | VARCHAR | Телефон |
| email | VARCHAR | Email |

---

## Vehicles

| Поле | Тип | Описание |
|---|---|---|
| vehicle_id | UUID | Идентификатор автомобиля |
| customer_id | UUID | Владелец автомобиля |
| vin | VARCHAR | VIN |
| plate_number | VARCHAR | Гос. номер |
| brand | VARCHAR | Марка |
| model | VARCHAR | Модель |
| year | INT | Год выпуска |
| mileage | INT | Пробег |

---

## Requests

| Поле | Тип | Описание |
|---|---|---|
| request_id | UUID | Идентификатор заявки |
| vehicle_id | UUID | Автомобиль |
| service_date | DATE | Дата записи |
| service_time | TIME | Время записи |
| status | VARCHAR | Статус заявки |

---

## ServiceOrders

| Поле | Тип | Описание |
|---|---|---|
| order_id | UUID | Идентификатор заказа |
| request_id | UUID | Исходная заявка |
| status | VARCHAR | Статус заказа |
| total_cost | DECIMAL | Итоговая стоимость |
| created_at | TIMESTAMP | Дата создания |

---

## Diagnostics

| Поле | Тип | Описание |
|---|---|---|
| diagnostic_id | UUID | Идентификатор |
| order_id | UUID | Заказ |
| description | TEXT | Результат диагностики |
| created_at | TIMESTAMP | Дата проведения |

---

## Works

| Поле | Тип | Описание |
|---|---|---|
| work_id | UUID | Идентификатор работы |
| name | VARCHAR | Название |
| price | DECIMAL | Базовая стоимость |

---

## Parts

| Поле | Тип | Описание |
|---|---|---|
| part_id | UUID | Идентификатор запчасти |
| name | VARCHAR | Название |
| article | VARCHAR | Артикул |
| price | DECIMAL | Стоимость |
| quantity | INT | Остаток на складе |
