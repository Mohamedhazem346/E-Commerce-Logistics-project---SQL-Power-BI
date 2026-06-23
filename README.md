# 🚚 E-Commerce Logistics Analytics
### SQL Server · Power BI · Data Warehousing

A full end-to-end logistics analytics project built on a **Galaxy Schema (Fact Constellation) data warehouse** — multiple fact tables sharing conformed dimensions — combining **SQL Server** KPI analysis with an interactive **Power BI** report across 5 dashboards.

---

## 📐 Data Model

**Galaxy Schema** warehouse — 5 fact tables share conformed dimensions, enabling cross-domain analysis across trips, deliveries, loads, maintenance, and driver metrics:

| Layer | Tables |
|-------|--------|
| **Dimensions** | `Dim_Drivers`, `Dim_Facilities`, `Dim_Routes`, `Dim_Customers`, `Dim_Trucks`, `Dim_Date` |
| **Facts** | `Fact_Trips`, `Fact_DeliveryEvents`, `Fact_Loads`, `Fact_Maintenance`, `Fact_DriverMonthlyMetrics` |

![Data Model](Dashboards%20and%20Modeling/Modeling.png)

---

## 📊 Power BI Dashboards

### 1. Executive Overview
High-level KPIs: Net Performance **$256.80M**, Maintenance Cost **$5.73M**, Active Customers **168**, Total Trips **85K**.

![Executive Overview](Dashboards%20and%20Modeling/Overview.png)

---

### 2. Sales & Revenue Dashboard
Total Revenue **$262.53M** | Total Charges **$298.62M** | Fuel Surcharges **$29.98M**
- Revenue trend across 2022–2024
- Revenue breakdown by customer and load type (Refrigerated vs Dry Van)

![Sales & Revenue](Dashboards%20and%20Modeling/Sales%20%26%20Revenue%20Dashboard.png)

---

### 3. Driver Performance Dashboard
151 Drivers | 124 Active | Avg Trips/Driver: **674.97** | Avg Revenue/Driver: **$2.07M**
- MPG analysis per driver
- Idle hours tracking
- Driver status and experience category breakdown

![Driver Performance](Dashboards%20and%20Modeling/Driver%20Performance%20Dashboard.png)

---

### 4. Delivery & Operations Dashboard
120M Miles | 85K Trips | Avg Detention: **91.54 min** | Avg Revenue/Trip: **$3.07K**
- On-Time vs Delayed rate: **55.67% On-Time**
- Geographic detention heatmap across US cities

![Delivery & Operations](Dashboards%20and%20Modeling/Delivery%20%26%20operations%20Dashboard.png)

---

### 5. Fleet Maintenance Dashboard
120 Trucks | Total Cost **$5.73M** | Avg Cost/Truck: **$47.75K** | Labor Hours: **12.20K**
- Monthly downtime trend
- Maintenance cost by truck make (Freightliner, Peterbilt, Mack…)
- Work orders by maintenance type

![Fleet Maintenance](Dashboards%20and%20Modeling/Fleet%20Maintenance%20Dashboard.png)

---

## 🗄️ SQL KPIs

### Dim_Drivers
```sql
-- 1) Total Drivers Count
SELECT COUNT(driver_key) AS Total_Drivers_Count
FROM dwh.Dim_Drivers;

-- 2) Active Drivers Ratio
SELECT CAST(SUM(CASE WHEN driver_status = 'Active' THEN 1 ELSE 0 END) AS FLOAT)
       / COUNT(driver_key) * 100 AS Active_Drivers_Ratio_Percentage
FROM dwh.Dim_Drivers;

-- 3) Average Driver Age
SELECT AVG(DATEDIFF(year, date_of_birth, GETDATE())) AS Average_Driver_Age
FROM dwh.Dim_Drivers;

-- 4) Driver Experience Analysis
SELECT AVG(CAST(years_experience AS FLOAT)) AS Avg_Experience,
       MIN(CAST(years_experience AS FLOAT)) AS Min_Experience,
       MAX(CAST(years_experience AS FLOAT)) AS Max_Experience
FROM dwh.Dim_Drivers;

-- 5) Churn / Turnover Rate
SELECT CAST(SUM(CASE WHEN employment_status = 'Terminated' THEN 1 ELSE 0 END) AS FLOAT)
       / COUNT(driver_key) * 100 AS Churn_Rate_Percentage
FROM dwh.Dim_Drivers;
```

---

### Dim_Facilities
```sql
-- 1) Total Facilities & Total Dock Doors
SELECT COUNT(facility_key) AS Total_Facilities,   -- Result: 50
       SUM(dock_doors)     AS Total_Dock_Doors,   -- Result: 3929
       AVG(dock_doors)     AS Avg_Doors_Per_Facility -- Result: 78
FROM dwh.Dim_Facilities;

-- 2) Capacity by Facility Type
SELECT facility_type,
       COUNT(facility_key)           AS Facility_Count,
       SUM(dock_doors)               AS Total_Dock_Doors,
       AVG(operating_hours_numeric)  AS Avg_Operating_Hours
FROM dwh.Dim_Facilities
GROUP BY facility_type
ORDER BY Total_Dock_Doors DESC;
-- Cross-Dock: 1452 | Distribution Center: 1070 | Terminal: 884 | Warehouse: 523

-- 3) Geographic Distribution (Top 3 Cities)
SELECT TOP 3 state, city,
       COUNT(facility_key) AS Facility_Count,
       SUM(dock_doors)     AS Total_Doors_In_Area
FROM dwh.Dim_Facilities
GROUP BY state, city
ORDER BY Facility_Count DESC;
-- Nashville TN: 5 | Atlanta GA: 4 | Detroit MI: 4

-- 4) 24/7 Availability Rate
SELECT COUNT(CASE WHEN operating_hours = '24/7' THEN 1 END) AS Active_24_7_Count,
       COUNT(facility_key) AS Total_Facilities,
       COUNT(CASE WHEN operating_hours = '24/7' THEN 1 END) * 100.0
       / COUNT(facility_key) AS Availability_Rate_Percentage
FROM dwh.Dim_Facilities;

-- 5) Facility Capacity Tiering
SELECT facility_name, facility_type, dock_doors,
       CASE
           WHEN dock_doors >= 100           THEN 'High Capacity (Hub)'
           WHEN dock_doors BETWEEN 50 AND 99 THEN 'Medium Capacity'
           ELSE                                  'Low Capacity (Spoke)'
       END AS Capacity_Tier
FROM dwh.Dim_Facilities
ORDER BY dock_doors DESC;
```

---

### Dim_Routes
```sql
-- Base Rate per Mile (Top 5 Routes)
SELECT TOP 5
       route_id,
       origin_city + ' -> ' + destination_city AS route_name,
       base_rate_per_mile
FROM dwh.Dim_Routes
ORDER BY base_rate_per_mile DESC;
-- Philadelphia -> New York: $2.79 | Minneapolis -> Houston: $2.75
```

---

## 🛠️ Tools & Technologies

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=flat&logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Measures-blue?style=flat)
![Galaxy Schema](https://img.shields.io/badge/Galaxy%20Schema-DWH-green?style=flat)

---

## 📁 Repository Structure

```
E-Commerce-Logistics/
├── Dashboards and Modeling/
│   ├── Overview.png
│   ├── Sales & Revenue Dashboard.png
│   ├── Driver Performance Dashboard.png
│   ├── Delivery & operations Dashboard.png
│   ├── Fleet Maintenance Dashboard.png
│   └── Modeling.png
├── SQL_Some important KPI/
│   ├── Dim_Driver.sql
│   ├── Dim_Facilities.sql
│   └── Dim_Routes.sql
├── Measures/
├── Logistics Analytics.pbix
└── README.md
```

---

> 📬 **Mohamed Hazem** · [GitHub](https://github.com/Mohamedhazem346)

