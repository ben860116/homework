

create table cities (city_id integer,city_name varchar(30));


Create table If Not Exists trips (Id int, Client_Id int, Driver_Id int, City_Id int, Status varchar(100), Request_at timestamp);
Create table If Not Exists events (rider_Id int,City_Id int, event_name varchar(100), _ts timestamp );
Truncate table Trips;
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('1', '1', '1', '10', 'cancelled_by_driver', '2016-01-05');
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('2', '2', '2', '11', 'cancelled_by_driver', '2016-01-05');
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('3', '3', '3', '10', 'completed', '2016-01-05');
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('4', '4', '4', '10', 'cancelled_by_client', '2016-01-05');
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('5', '1', '1', '10', 'cancelled_by_driver', '2016-01-05');
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('6', '2', '2', '11', 'completed', '2016-01-25');
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('7', '3', '3', '10', 'completed', '2016-01-05');
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('8', '2', '2', '11', 'completed', '2016-01-25');
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('9', '3', '3', '10', 'completed', '2013-01-05');
insert into Trips (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) values ('10', '4', '4', '10', 'cancelled_by_driver', '2016-01-05');
Truncate table events;
insert into events (rider_Id, City_ID, event_name, _ts) values ('1', '10', 'attempted_sign_up','2013-09-01');
insert into events (rider_Id, City_ID, event_name, _ts) values ('2', '11', 'attempted_sign_up','2013-09-26');
insert into events (rider_Id, City_ID, event_name, _ts) values ('3', '10', 'attempted_sign_up','2013-09-27');
insert into events (rider_Id, City_ID, event_name, _ts) values ('4', '11', 'attempted_sign_up','2013-09-27');
insert into events (rider_Id, City_ID, event_name, _ts) values ('1', '10', 'sign_up_failure','2013-09-02');
insert into events (rider_Id, City_ID, event_name, _ts) values ('2', '11', 'sign_up_failure','2013-09-26');
insert into events (rider_Id, City_ID, event_name, _ts) values ('3', '10', 'sign_up_failure','2013-09-27');
insert into events (rider_Id, City_ID, event_name, _ts) values ('4', '11', 'sign_up_failure','2013-09-28');
insert into events (rider_Id, City_ID, event_name, _ts) values ('1', '10', 'sign_up_success','2016-01-04');
insert into events (rider_Id, City_ID, event_name, _ts) values ('2', '11', 'attempted_sign_up','2013-09-28');
insert into events (rider_Id, City_ID, event_name, _ts) values ('3', '10', 'attempted_sign_up','2013-09-28');
insert into events (rider_Id, City_ID, event_name, _ts) values ('4', '11', 'attempted_sign_up','2013-09-28');
insert into events (rider_Id, City_ID, event_name, _ts) values ('2', '10', 'sign_up_success','2016-01-04');
insert into events (rider_Id, City_ID, event_name, _ts) values ('3', '11', 'sign_up_success','2016-01-04');
insert into events (rider_Id, City_ID, event_name, _ts) values ('4', '10', 'sign_up_success','2016-01-04');
Truncate table cities;
insert into cities (city_id,city_name) values ('10','Qarth');
insert into cities (city_id,city_name) values('11', 'Meereen');













select b.city_name,extract(dow FROM a._ts) as dayofweek, count(distinct a.rider_id) as alltrip 
from events a 
left join cities b 
on a.city_id=b.city_id 
where a.event_name='sign_up_success' 
and b.city_name in ('Qarth' , 'Meereen') 
and extract(year FROM a._ts) = 2016 
and extract(week from a._ts) = 1  
group by city_name,extract(dow FROM a._ts)
order by city_name,extract(dow FROM a._ts);

select m.city_name,extract(dow FROM n._ts) as dayofweek,count(distinct n.rider_id) as driver_comp_trip
from events n 
left join cities m on m.city_id=n.city_id 
left join trips o on n.rider_id=o.driver_id 

where n.event_name='sign_up_success'
and m.city_name in ('Qarth' , 'Meereen')
and extract(year FROM n._ts) = 2016 
and extract(week from n._ts) = 1  
 and o.status='completed'

and EXTRACT(EPOCH FROM o.request_at - n._ts)/3600 <= 168
group by m.city_name,extract(dow FROM n._ts)
order by m.city_name,extract(dow FROM n._ts) ;


Select s1.city_name,s1.dayofweek,100*sum(COALESCE(s2.driver_comp_trip, 0 )/cast (s1.alltrip as FLOAT) ) as percentage_sign_up 
From 
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
Left Join 
(select m.city_name,extract(dow FROM n._ts) as dayofweek,count(distinct n.rider_id) as driver_comp_trip
from events n 
left join cities m on m.city_id=n.city_id 
left join trips o on n.rider_id=o.driver_id 

where n.event_name='sign_up_success'
and m.city_name in ('Qarth' , 'Meereen')
and extract(year FROM n._ts) = 2016 
and extract(week from n._ts) = 1  
 and o.status='completed'

and EXTRACT(EPOCH FROM o.request_at - n._ts)/3600 <= 168
group by m.city_name,extract(dow FROM n._ts)
order by m.city_name,extract(dow FROM n._ts) ) s2 
on s1.city_name=s2.city_name 
and s1.dayofweek=s2.dayofweek
group by s1.city_name,s1.dayofweek








