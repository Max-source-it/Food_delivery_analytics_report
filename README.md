# 🍔 Food Delivery Analytics Report

Этот проект представляет собой комплексный анализ данных сервиса доставки еды. В ходе анализа исследуются финансовые показатели, удержание клиентов по когортам, проводится RFM-сегментация и детальный анализ заказов и ресторанов.

## 🛠 Технологии

* **Python 3.12**
* **Jupyter Notebook**
* **Pandas** (обработка данных)
* **NumPy** (математические вычисления)
* **Matplotlib** (визуализация)
* **Seaborn** (тепловые карты и стилизация)
* **Statsmodels** (статистические тесты)
* **IPywidgets** (интерактивный дашборд)

## 📂 Структура проекта

```text
Food_delivery_analytics_report/
├── data/
│   ├── raw/               # Исходные данные (CSV)
│   └── processed/         # Обработанные данные (создаются автоматически)
├── notebooks_cod/
│       └── food_delivery_analysis.ipynb   # Основной файл с кодом
├── images/                # Изображения из анализа
├── requirements.txt
└── README.md

## 🚀 Как запустить

1. Склонируйте репозиторий или скачайте ZIP-архив.
2. Установите зависимости командой:
   ```bash
   pip install -r requirements.txt

## 📊 Анализ и Визуализация

### 1. Когортное удержание клиентов
Анализ показывает, как меняется процент клиентов, возвращающихся в сервис. Чем темнее ячейка, тем выше процент удержания.

<img width="1300" height="784" alt="cohort_retention_heatmap" src="https://github.com/user-attachments/assets/27b27054-a850-47c7-bd66-a69db4536687" />


### 2. RFM-сегментация
Разбивка клиентов по частоте заказов (Frequency), выручке (Monetary) и давности покупок (Recency).

<img width="945" height="566" alt="rfm_segments_scatter" src="https://github.com/user-attachments/assets/ee81e16f-3599-4a18-b5e7-e26946682b00" />


### 3. Анализ заказов и ресторанов

**Распределение статусов заказов:**

<img width="544" height="514" alt="order_status_pie" src="https://github.com/user-attachments/assets/36e3ab61-f9c5-4857-896c-c7a25727b18a" />

**Топ-10 кухонь по количеству заказов:**

<img width="949" height="545" alt="top_cuisines" src="https://github.com/user-attachments/assets/e7388868-9c77-448c-b818-955fdc5aa96e" />

**Средний рейтинг по городам:**

<img width="970" height="531" alt="city_rating" src="https://github.com/user-attachments/assets/18b7a8b7-89f2-4d37-bb88-8d2d5098f2b9" />

**Влияние рейтинга на скорость доставки:**

<img width="852" height="552" alt="delivery_vs_rating" src="https://github.com/user-attachments/assets/08fe61dc-35a2-429c-9e40-ec6ae6abdc4f" />

---

## 💡 Ключевые выводы

* Наибольшее количество заказов приходится на кухни Thai и Indian.
* Высокий процент заказов (33.2%) доставляется с опозданием.
* Лондон (London) и Ливерпуль (Liverpool) лидируют по среднему рейтингу ресторанов.
* Модель RFM позволяет эффективно выделить лояльных клиентов ("Champions") и клиентов группы риска ("At Risk").

---

## 📄 Лицензия

Проект создан в учебных целях и свободен для использования.
