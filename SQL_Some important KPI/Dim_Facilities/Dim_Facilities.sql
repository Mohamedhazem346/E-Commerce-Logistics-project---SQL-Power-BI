
select * from dwh.Dim_Facilities  

---- Important KPI----- : 
----1) Total Facilities & Total Dock Doors : 
select 
    count(facility_key) as Total_Facilities,
    sum(dock_doors) as Total_Dock_Doors,
    avg(dock_doors) as Avg_Doors_Per_Facility
from  dwh.Dim_Facilities; 

-----2) Capacity by Facility Type  : 
select 
    facility_type,
    count(facility_key) as Facility_Count,
    sum(dock_doors) as Total_Dock_Doors,
    avg (operating_hours_numeric) as Avg_Operating_Hours
from dwh.Dim_Facilities
group by facility_type
order by  Total_Dock_Doors desc ; 

-----3) Geographic Distribution : 
select top 3 
    state,
    city,
    count(facility_key) as Facility_Count,
    sum (dock_doors) as Total_Doors_In_Area
from  dwh.Dim_Facilities
group by state, city 
order by Facility_Count desc; 

---4)--- 24/7 Availability Rate  : 
SELECT 
    COUNT(CASE WHEN operating_hours = '24/7' THEN 1 END) AS Active_24_7_Count,
    COUNT(facility_key) AS Total_Facilities,
    (COUNT(CASE WHEN operating_hours = '24/7' THEN 1 END) * 100.0 / COUNT(facility_key)) AS Availability_Rate_Percentage
FROM dwh.Dim_Facilities;

------5)-----Facility Capacity Tiering : 
SELECT 
    facility_name,
    facility_type,
    dock_doors,
    CASE 
        WHEN dock_doors >= 100 THEN 'High Capacity (Hub)'
        WHEN dock_doors BETWEEN 50 AND 99 THEN 'Medium Capacity'
        ELSE 'Low Capacity (Spoke)'
    END AS Capacity_Tier
FROM dwh.Dim_Facilities
ORDER BY dock_doors DESC;  