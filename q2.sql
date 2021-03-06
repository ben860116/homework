select s1.city_name,s1.dayofweek,100*sum(COALESCE(s2.driver_comp_trip, 0)/cast (s1.alltrip as FLOAT)) as percentage_sign_up 
from 
( select b.city_name,extract(dow FROM a._ts) as dayofweek, count(distinct a.rider_id) as alltrip 
from events a 
left join cities b 
on a.city_id=b.city_id 
where a.event_name='sign_up_success' 
and b.city_name in ('Qarth' , 'Meereen') 
and extract(year FROM a._ts) = 2016 
and extract(week from a._ts) = 1  
group by city_name,extract(dow FROM a._ts)
order by city_name,extract(dow FROM a._ts)
) s1
left Join 
(select m.city_name,extract(dow FROM n._ts) as dayofweek,count(distinct n.rider_id) as driver_comp_trip
from events n 
left join cities m on m.city_id=n.city_id 
left join trips o on n.rider_id=o.client_id 
where n.event_name='sign_up_success'
and m.city_name in ('Qarth' , 'Meereen')
and extract(year FROM n._ts) = 2015 
and extract(week from n._ts) = 53 
and o.status='completed'
and EXTRACT(EPOCH FROM o.request_at - n._ts)/3600 <= 168
group by m.city_name,extract(dow FROM n._ts)
order by m.city_name,extract(dow FROM n._ts) ) s2 
on s1.city_name=s2.city_name 
and s1.dayofweek=s2.dayofweek
group by s1.city_name,s1.dayofweek;
