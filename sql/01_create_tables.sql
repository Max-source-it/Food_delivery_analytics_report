-- Пересоздание таблиц для идемпотентности (безопасный повторный запуск)
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS restaurants CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;

-- =============================================================================
-- 1. ТАБЛИЦА: customers (Клиенты)
-- Хранит базовую информацию о пользователях сервиса.
-- customer_id: Уникальный идентификатор клиента (первичный ключ).
-- =============================================================================
CREATE TABLE "customers" (
	"customer_id" varchar(20) PRIMARY KEY,  -- PK: Уникальный ID клиента
	"city" varchar(50),                     -- Город проживания
	"signup_date" date                      -- Дата регистрации
);
CREATE UNIQUE INDEX "customers_pkey" ON "customers" ("customer_id");

-- =============================================================================
-- 2. ТАБЛИЦА: restaurants (Рестораны)
-- Содержит данные о ресторанах-партнерах.
-- restaurant_id: Уникальный идентификатор ресторана (первичный ключ).
-- =============================================================================
CREATE TABLE "restaurants" (
	"restaurant_id" varchar(20) PRIMARY KEY, -- PK: Уникальный ID ресторана
	"cuisine" varchar(50),                   -- Тип кухни (Thai, Italian и т.д.)
	"city" varchar(50),                      -- Город, в котором находится ресторан
	"rating" numeric(2, 1)                   -- Рейтинг ресторана (от 1.0 до 5.0)
);
CREATE UNIQUE INDEX "restaurants_pkey" ON "restaurants" ("restaurant_id");

-- =============================================================================
-- 3. ТАБЛИЦА: menu_items (Позиции меню)
-- Список блюд, доступных в ресторанах.
-- item_id: Уникальный идентификатор блюда (первичный ключ).
-- Внешний ключ связывает блюдо с конкретным рестораном.
-- =============================================================================
CREATE TABLE "menu_items" (
	"item_id" varchar(20) PRIMARY KEY,       -- PK: Уникальный ID блюда
	"restaurant_id" varchar(20) NOT NULL,   -- FK: ID ресторана, к которому относится блюдо
	"price" numeric(10, 2)                  -- Цена блюда
);
CREATE UNIQUE INDEX "menu_items_pkey" ON "menu_items" ("item_id");
-- Связь «меню-ресторан»
ALTER TABLE "menu_items" ADD CONSTRAINT "fk_menu_restaurant" FOREIGN KEY ("restaurant_id") REFERENCES "restaurants"("restaurant_id");

-- =============================================================================
-- 4. ТАБЛИЦА: orders (Заказы)
-- Основная таблица транзакций. Связывает клиента и ресторан в момент заказа.
-- order_id: Уникальный идентификатор заказа (первичный ключ).
-- =============================================================================
CREATE TABLE "orders" (
	"order_id" varchar(20) PRIMARY KEY,      -- PK: Уникальный ID заказа
	"customer_id" varchar(20) NOT NULL,     -- FK: ID клиента, сделавшего заказ
	"restaurant_id" varchar(20) NOT NULL,   -- FK: ID ресторана, принявшего заказ
	"order_time" timestamp,                  -- Время создания заказа
	"delivery_time" timestamp,               -- Время доставки заказа
	"status" varchar(20)                     -- Статус заказа (Delivered, Cancelled, Late)
);
CREATE UNIQUE INDEX "orders_pkey" ON "orders" ("order_id");
-- Связи «заказ-клиент» и «заказ-ресторан»
ALTER TABLE "orders" ADD CONSTRAINT "fk_orders_customer" FOREIGN KEY ("customer_id") REFERENCES "customers"("customer_id");
ALTER TABLE "orders" ADD CONSTRAINT "fk_orders_restaurant" FOREIGN KEY ("restaurant_id") REFERENCES "restaurants"("restaurant_id");

-- =============================================================================
-- 5. ТАБЛИЦА: order_items (Состав заказов)
-- Детализирует, какие именно блюда и в каком количестве вошли в каждый заказ.
-- Составной первичный ключ (order_id + item_id) гарантирует уникальность строки.
-- =============================================================================
CREATE TABLE "order_items" (
	"order_id" varchar(20),                  -- FK: ID заказа
	"item_id" varchar(20),                   -- FK: ID блюда
	"quantity" integer,                      -- Количество единиц блюда в заказе
	"price" numeric(10, 2),                  -- Цена за единицу на момент заказа
	CONSTRAINT "order_items_pkey" PRIMARY KEY("order_id","item_id") -- Составной PK
);
CREATE UNIQUE INDEX "order_items_pkey" ON "order_items" ("order_id","item_id");
-- Связи «детали-меню» и «детали-заказ»
ALTER TABLE "order_items" ADD CONSTRAINT "fk_order_items_item" FOREIGN KEY ("item_id") REFERENCES "menu_items"("item_id");
ALTER TABLE "order_items" ADD CONSTRAINT "fk_order_items_order" FOREIGN KEY ("order_id") REFERENCES "orders"("order_id");
