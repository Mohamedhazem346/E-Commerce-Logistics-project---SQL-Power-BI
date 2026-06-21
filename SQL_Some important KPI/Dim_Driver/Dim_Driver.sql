------ Important KPI -------- 
use s 
select * from  dwh.Dim_Drivers 
--1) Total Drivers Count   : 
select   
    count(driver_key) as  Total_Drivers_Count
from 
    dwh.Dim_Drivers ;
---2) Active Drivers Ratio   : 
select  
    cast(sum(case when  driver_status = 'Active' then 1 else 0 end) as float) 
    / count(driver_key) * 100 as  Active_Drivers_Ratio_Percentage
from 
    dwh.Dim_Drivers; 
----3) Average Driver Age  : 
SELECT 
    avg(datediff(year, date_of_birth, getdate())) as Average_Driver_Age
FROM 
    dwh.Dim_Drivers; 

---4)  Driver Experience Analysis  :  
select  
    avg(cast(years_experience as float )) as Average_Driver_Experience , 
    min(cast(years_experience as float )) as Min_Driver_Experience  , 
    max(cast(years_experience as float)) as Max_Driver_Experience 
FROM 
    dwh.Dim_Drivers; 

----5) Churn / Turnover Rate  : 
SELECT 
    cast(sum(case when employment_status = 'Terminated' then 1 else 0 end) as  float )  
    / count(driver_key) * 100 AS Churn_Rate_Percentage
FROM 
    dwh.Dim_Drivers;    