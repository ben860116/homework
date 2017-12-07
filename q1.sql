select cities.city_name,
percentile_cont(0.9) WITHIN GROUP (ORDER BY (trips.actual_eta-trips.predicted_eta))
from trips 
right join cities
on trips.city_id= cities.city_id
where
trips.status='completed'
and cities.city_name in ('Qarth','Meereen') 
and EXTRACT(EPOCH FROM now()-trips.request_at)/3600 <= 720  
group by cities.city_name;
