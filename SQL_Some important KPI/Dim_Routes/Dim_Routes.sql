
select * from dwh.Dim_Routes 

-----important KPI------ 
---1) : Base Rate per Mile 
SELECT top 5 
    route_id,
    origin_city + ' -> ' + destination_city AS route_name,
    base_rate_per_mile
FROM dwh.Dim_Routes
ORDER BY base_rate_per_mile DESC; 
------2) Estimated Route Cost  
SELECT top 5 
    route_id,
    origin_city,
    destination_city,
    typical_distance_miles * base_rate_per_mile AS estimated_total_route_cost
FROM dwh.Dim_Routes
ORDER BY estimated_total_route_cost DESC; 

-----3) Origin State Profile 
SELECT top 5 
    origin_state,
    COUNT(route_id) AS total_routes,
    AVG(typical_distance_miles) AS avg_distance,
    AVG(base_rate_per_mile) AS avg_base_rate
FROM dwh.Dim_Routes
GROUP BY origin_state
ORDER BY total_routes DESC;