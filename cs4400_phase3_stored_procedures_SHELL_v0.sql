-- CS4400: Introduction to Database Systems (Fall 2022)
-- Project Phase III: Stored Procedures SHELL [v0] Monday, Oct 31, 2022
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

use restaurant_supply_express;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [1] add_owner()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new owner.  A new owner must have a unique
username.  Also, the new owner is not allowed to be an employee. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_owner;
delimiter //
create procedure add_owner (in ip_username varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500), in ip_birthdate date)
sp_main: begin
    -- ensure new owner has a unique username
    
    if ((ip_username is null or ip_first_name is null or ip_last_name is null or ip_address is null or ip_birthdate is null)
    or (ip_username = '' or ip_first_name = '' or ip_last_name = '' or ip_address=''))
		then leave sp_main; end if;
	
    if (ip_username not in (select username from users)) then 
		insert into users (username, first_name, last_name, address, birthdate)
		values (ip_username, ip_first_name, ip_last_name, ip_address, ip_birthdate);
        
        insert into restaurant_owners (username)
        value (ip_username);
    end if;
    
end //
delimiter ;

-- [2] add_employee()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new employee without any designated pilot or
worker roles.  A new employee must have a unique username unique tax identifier. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_employee;
delimiter //
create procedure add_employee (in ip_username varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500), in ip_birthdate date,
    in ip_taxID varchar(40), in ip_hired date, in ip_employee_experience integer,
    in ip_salary integer)
sp_main: begin
    -- ensure new owner has a unique username
    -- ensure new employee has a unique tax identifier
    
    if ((ip_username is null or ip_first_name is null or ip_last_name is null or ip_address is null or ip_birthdate is null
    or ip_taxID is null or ip_hired is null or ip_employee_experience is null or ip_salary is null)
	or (ip_username = '' or ip_first_name = '' or ip_last_name = '' or ip_address = '' or ip_taxID = '' or ip_employee_experience < 0 or ip_salary < 0))
		then leave sp_main; end if;
        
    if (ip_username not in (select username from employees) and ip_taxID not in (select taxID from employees))
    then 
		insert into users
        values (ip_username, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    
		insert into employees
		values (ip_username, ip_taxID, ip_hired, ip_employee_experience, ip_salary);
    end if;
    
end //
delimiter ;

-- [3] add_pilot_role()
-- -----------------------------------------------------------------------------
/* This stored procedure adds the pilot role to an existing employee.  The
employee/new pilot must have a unique license identifier. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_pilot_role;
delimiter //
create procedure add_pilot_role (in ip_username varchar(40), in ip_licenseID varchar(40),
	in ip_pilot_experience integer)
sp_main: begin
    -- ensure new employee exists
    -- ensure new pilot has a unique license identifier

    if ((ip_username is null or ip_licenseID is null or ip_pilot_experience is null)
	or (ip_username = '' or ip_licenseID = '' or ip_pilot_experience < 0))
		then leave sp_main; end if;
    
    if (ip_username in (select username from employees) and ip_licenseID not in (select licenseID from pilots))
    then insert into pilots (username, licenseID, experience)
		values (ip_username, ip_licenseID, ip_pilot_experience);
    end if;
    
end //
delimiter ;

-- [4] add_worker_role()
-- -----------------------------------------------------------------------------
/* This stored procedure adds the worker role to an existing employee. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_worker_role;
delimiter //
create procedure add_worker_role (in ip_username varchar(40))
sp_main: begin
    -- ensure new employee exists
    
    if (ip_username is null or ip_username = '')
		then leave sp_main; end if;
    
    if (ip_username in (select username from employees)) then
		insert into workers (username)
        value (ip_username);
	end if;
    
end //
delimiter ;

-- [5] add_ingredient()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new ingredient.  A new ingredient must have a
unique barcode. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_ingredient;
delimiter //
create procedure add_ingredient (in ip_barcode varchar(40), in ip_iname varchar(100),
	in ip_weight integer)
sp_main: begin
	-- ensure new ingredient doesn't already exist
    
    if ((ip_barcode is null or ip_iname is null or ip_weight is null)
	or (ip_barcode = '' or ip_iname = '' or ip_weight < 0))
		then leave sp_main; end if;
    
    if (ip_barcode not in (select barcode from ingredients)) then
		insert into ingredients (barcode, iname, weight)
        values (ip_barcode, ip_iname, ip_weight);
	end if;
    
end //
delimiter ;

-- [6] add_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new drone.  A new drone must be assigned 
to a valid delivery service and must have a unique tag.  Also, it must be flown
by a valid pilot initially (i.e., pilot works for the same service), but the pilot
can switch the drone to working as part of a swarm later. And the drone's starting
location will always be the delivery service's home base by default. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_drone;
delimiter //
create procedure add_drone (in ip_id varchar(40), in ip_tag integer, in ip_fuel integer,
	in ip_capacity integer, in ip_sales integer, in ip_flown_by varchar(40))
sp_main: begin
	-- ensure new drone doesn't already exist
    -- ensure that the delivery service exists
    -- ensure that a valid pilot will control the drone
    
	if ((ip_id is null or ip_tag is null or ip_fuel is null or ip_capacity is null or ip_sales is null or ip_flown_by is null)
	or (ip_id = '' or ip_tag = '' or ip_fuel < 0  or ip_fuel > 100 or ip_capacity < 0 or ip_sales < 0 or ip_flown_by = ''))
		then leave sp_main; end if;
    
    if (ip_id in (select id from delivery_services)
	and ip_tag not in (select tag from drones where ip_id = id)
    and ip_flown_by in (select username from pilots)) then
		insert into drones(id, tag, fuel, capacity, sales, flown_by, swarm_id, swarm_tag, hover)
        values (ip_id, ip_tag, ip_fuel, ip_capacity, ip_sales, ip_flown_by, NULL, NULL, (select home_base from delivery_services where id = ip_id));
	end if;
    
end //
delimiter ;

-- [7] add_restaurant()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new restaurant.  A new restaurant must have a
unique (long) name and must exist at a valid location, and have a valid rating.
And a resturant is initially "independent" (i.e., no owner), but will be assigned
an owner later for funding purposes. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_restaurant;
delimiter //
create procedure add_restaurant (in ip_long_name varchar(40), in ip_rating integer,
	in ip_spent integer, in ip_location varchar(40))
sp_main: begin
	-- ensure new restaurant doesn't already exist
    -- ensure that the location is valid
    -- ensure that the rating is valid (i.e., between 1 and 5 inclusively)
    
    if ((ip_long_name is null or ip_rating is null or ip_spent is null or ip_location is null)
	or (ip_long_name = '' or ip_rating < 0 or ip_rating > 5 or ip_spent < 0 or ip_location = ''))
		then leave sp_main; end if;
    
    if (ip_long_name not in (select long_name from restaurants)
    and ip_location in (select label from locations)
    and ip_rating between 1 and 5) then
		insert into restaurants (long_name, rating, spent, location, funded_by)
        values (ip_long_name, ip_rating, ip_spent, ip_location, NULL);
	end if;
    
end //
delimiter ;

-- [8] add_service()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new delivery service.  A new service must have
a unique identifier, along with a valid home base and manager. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_service;
delimiter //
create procedure add_service (in ip_id varchar(40), in ip_long_name varchar(100),
	in ip_home_base varchar(40), in ip_manager varchar(40))
sp_main: begin
	-- ensure new delivery service doesn't already exist
    -- ensure that the home base location is valid
    -- ensure that the manager is valid
    
    if ((ip_id is null or ip_long_name is null or ip_home_base is null or ip_manager is null)
	or (ip_id = '' or ip_long_name = '' or ip_home_base = '' or ip_manager = ''))
		then leave sp_main; end if;
    
    if (ip_id not in (select id from delivery_services)
    and ip_home_base in (select label from locations)
    and ip_manager not in (select manager from delivery_services)
    and ip_manager in (select username from workers)) then
		insert into delivery_services (id, long_name, home_base, manager)
        values (ip_id, ip_long_name, ip_home_base, ip_manager);
        update work_for set id = ip_id where ip_manager = username;
    end if;
    
end //
delimiter ;

-- [9] add_location()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new location that becomes a new valid drone
destination.  A new location must have a unique combination of coordinates.  We
could allow for "aliased locations", but this might cause more confusion that
it's worth for our relatively simple system. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_location;
delimiter //
create procedure add_location (in ip_label varchar(40), in ip_x_coord integer,
	in ip_y_coord integer, in ip_space integer)
sp_main: begin
	-- ensure new location doesn't already exist
    -- ensure that the coordinate combination is distinct
    
    if ((ip_label is null or ip_x_coord is null or ip_y_coord is null or ip_space is null)
	or (ip_label = '' or ip_space < 0))
		then leave sp_main; end if;
    
    if (ip_label not in (select label from locations)
    and (ip_x_coord not in (select x_coord from locations) or ip_y_coord not in (select y_coord from locations))) then
		insert into locations (label, x_coord, y_coord, space)
		values (ip_label, ip_x_coord, ip_y_coord, ip_space);
    end if;
    
end //
delimiter ;

-- [10] start_funding()
-- -----------------------------------------------------------------------------
/* This stored procedure opens a channel for a restaurant owner to provide funds
to a restaurant. If a different owner is already providing funds, then the current
owner is replaced with the new owner.  The owner and restaurant must be valid. */
-- -----------------------------------------------------------------------------
drop procedure if exists start_funding;
delimiter //
create procedure start_funding (in ip_owner varchar(40), in ip_long_name varchar(40))
sp_main: begin
	-- ensure the owner and restaurant are valid
    
    if ((ip_owner is null or ip_long_name is null)
	or (ip_owner = '' or ip_long_name = ''))
		then leave sp_main; end if;
    
    if (ip_long_name in (select long_name from restaurants)
    and ip_owner in (select username from restaurant_owners)) then
			update restaurants set funded_by = ip_owner where ip_long_name = long_name;
	end if;
    
end //
delimiter ;

-- [11] hire_employee()
-- -----------------------------------------------------------------------------
/* This stored procedure hires an employee to work for a delivery service.
Employees can be combinations of workers and pilots. If an employee is actively
controlling drones or serving as manager for a different service, then they are
not eligible to be hired.  Otherwise, the hiring is permitted. */
-- -----------------------------------------------------------------------------
drop procedure if exists hire_employee;
delimiter //
create procedure hire_employee (in ip_username varchar(40), in ip_id varchar(40))
sp_main: begin
	-- ensure that the employee hasn't already been hired
	-- ensure that the employee and delivery service are valid
    -- ensure that the employee isn't a manager for another service
	-- ensure that the employee isn't actively controlling drones for another service
    
    if ((ip_username is null or ip_id is null)
	or (ip_username = '' or ip_id = ''))
		then leave sp_main; end if;
    
    if (ip_username in (select username from work_for where id = ip_id))
		then leave sp_main; end if;
    if ip_username not in (select username from employees)
		then leave sp_main; end if;
    if ip_id not in (select id from delivery_services)
		then leave sp_main; end if;
    if ip_username in (select manager from delivery_services)
		then leave sp_main; end if;
    if ip_username in (select flown_by from drones)
		then leave sp_main; end if;
    
	insert into work_for values (ip_username, ip_id);
    
    
end //
delimiter ;

-- [12] fire_employee()
-- -----------------------------------------------------------------------------
/* This stored procedure fires an employee who is currently working for a delivery
service.  The only restrictions are that the employee must not be: [1] actively
controlling one or more drones; or, [2] serving as a manager for the service.
Otherwise, the firing is permitted. */
-- -----------------------------------------------------------------------------
drop procedure if exists fire_employee;
delimiter //
create procedure fire_employee (in ip_username varchar(40), in ip_id varchar(40))
sp_main: begin
	-- ensure that the employee is currently working for the service
    -- ensure that the employee isn't an active manager
	-- ensure that the employee isn't controlling any drones
    
    if ((ip_username is null or ip_id is null)
	or (ip_username = '' or ip_id = ''))
		then leave sp_main; end if;
    
    if ip_username not in (select username from work_for where ip_id = id)
		then leave sp_main; end if;
    if ip_username in (select manager from delivery_services)
		then leave sp_main; end if;
    if ip_username not in (select flown_by from drones)
		then leave sp_main; end if;
        
	delete from work_for where (username = ip_username and id = ip_id);

end //
delimiter ;

-- [13] manage_service()
-- -----------------------------------------------------------------------------
/* This stored procedure appoints an employee who is currently hired by a delivery
service as the new manager for that service.  The only restrictions are that: [1]
the employee must not be working for any other delivery service; and, [2] the
employee can't be flying drones at the time.  Otherwise, the appointment to manager
is permitted.  The current manager is simply replaced.  And the employee must be
granted the worker role if they don't have it already. */
-- -----------------------------------------------------------------------------
drop procedure if exists manage_service;
delimiter //
create procedure manage_service (in ip_username varchar(40), in ip_id varchar(40))
sp_main: begin
	-- ensure that the employee is currently working for the service
	-- ensure that the employee is not flying any drones
    -- ensure that the employee isn't working for any other services
    -- add the worker role if necessary
    
    if ((ip_username is null or ip_id is null)
	or (ip_username = '' or ip_id = ''))
		then leave sp_main; end if;
    
    if ip_username in (select username from work_for where id != ip_id)
		then leave sp_main; end if;
    if ip_username not in (select username from work_for where id = ip_id)
		then leave sp_main; end if;
    if ip_username in (select flown_by from drones)
		then leave sp_main; end if;
	if (ip_username not in (select username from workers)) then
		insert into workers values (ip_username);
	end if;
        update delivery_services set manager = ip_username where id = ip_id;

end //
delimiter ;

-- [14] takeover_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure allows a valid pilot to take control of a lead drone owned
by the same delivery service, whether it's a "lone drone" or the leader of a swarm.
The current controller of the drone is simply relieved of those duties. And this
should only be executed if a "leader drone" is selected. */
-- -----------------------------------------------------------------------------
drop procedure if exists takeover_drone;
delimiter //
create procedure takeover_drone (in ip_username varchar(40), in ip_id varchar(40),
	in ip_tag integer)
sp_main: begin
	-- ensure that the employee is currently working for the service
	-- ensure that the selected drone is owned by the same service and is a leader and not follower
	-- ensure that the employee isn't a manager
    -- ensure that the employee is a valid pilot
    
    if ((ip_username is null or ip_id is null or ip_tag is null)
	or (ip_username = '' or ip_id = ''))
		then leave sp_main; end if;
    
    if ip_username not in (select username from work_for where id = ip_id)
		then leave sp_main; end if;
    if ip_tag not in (select tag from drones where ip_id = id and flown_by is not null)
		then leave sp_main; end if;
    if ip_username in (select manager from delivery_services)
		then leave sp_main; end if;
    if ip_username not in (select username from pilots)
		then leave sp_main; end if;
	
	update drones set flown_by = ip_username where (ip_tag = tag and ip_id = id);
    
end //
delimiter ;

-- [15] join_swarm()
-- -----------------------------------------------------------------------------
/* This stored procedure takes a drone that is currently being directly controlled
by a pilot and has it join a swarm (i.e., group of drones) led by a different
directly controlled drone. A drone that is joining a swarm connot be leading a
different swarm at this time.  Also, the drones must be at the same location, but
they can be controlled by different pilots. */
-- -----------------------------------------------------------------------------
drop procedure if exists join_swarm;
delimiter //
create procedure join_swarm (in ip_id varchar(40), in ip_tag integer,
	in ip_swarm_leader_tag integer)
sp_main: begin
	-- ensure that the swarm leader is a different drone
	-- ensure that the drone joining the swarm is valid and owned by the service
    -- ensure that the drone joining the swarm is not already leading a swarm
	-- ensure that the swarm leader drone is directly controlled
	-- ensure that the drones are at the same location
    
    if ((ip_id is null or ip_tag is null or ip_swarm_leader_tag is null)
	or (ip_id = ''))
		then leave sp_main; end if;
    
    if ip_swarm_leader_tag = ip_tag
		then leave sp_main; end if;
	if ip_id not in (select id from drones where tag = ip_tag)
		then leave sp_main; end if;
	if (select swarm_tag from drones where (id = ip_id and tag = ip_tag)) = ip_tag
		then leave sp_main; end if;
    if ip_id not in (select id from drones where (tag = ip_swarm_leader_tag and flown_by is not null))
		then leave sp_main; end if;
        
    if (select hover from drones where (id = ip_id and tag = ip_swarm_leader_tag))
    != (select hover from drones where (id = ip_id and tag = ip_tag))
		then leave sp_main; end if;
    
    
		update drones set flown_by = NULL, swarm_id = ip_id, swarm_tag = ip_swarm_leader_tag 
        where (ip_id = id and ip_tag = tag);
    
end //
delimiter ;

-- [16] leave_swarm()
-- -----------------------------------------------------------------------------
/* This stored procedure takes a drone that is currently in a swarm and returns
it to being directly controlled by the same pilot who's controlling the swarm. */
-- -----------------------------------------------------------------------------
drop procedure if exists leave_swarm;
delimiter //
create procedure leave_swarm (in ip_id varchar(40), in ip_swarm_tag integer)
sp_main: begin
	-- ensure that the selected drone is owned by the service and flying in a swarm
    
    if ((ip_id is null or ip_swarm_tag is null)
	or (ip_id = ''))
		then leave sp_main; end if;
    
    if ip_swarm_tag in (select tag from drones where (id = ip_id and flown_by is null))then
    
		set @leadID = (select swarm_id from drones where (id = ip_id and tag = ip_swarm_tag));
		set @leadTag = (select swarm_tag from drones where (id = ip_id and tag = ip_swarm_tag));
		set @pilot = (select flown_by from drones where (id = @leadID and tag = @leadTag));
    
		update drones 
        set flown_by = @pilot, swarm_id = NULL, swarm_tag = NULL 
        where id = ip_id and tag = ip_swarm_tag;
	end if;
        
end //
delimiter ;

-- [17] load_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure allows us to add some quantity of fixed-size packages of
a specific ingredient to a drone's payload so that we can sell them for some
specific price to other restaurants.  The drone can only be loaded if it's located
at its delivery service's home base, and the drone must have enough capacity to
carry the increased number of items.

The change/delta quantity value must be positive, and must be added to the quantity
of the ingredient already loaded onto the drone as applicable.  And if the ingredient
already exists on the drone, then the existing price must not be changed. */
-- -----------------------------------------------------------------------------
drop procedure if exists load_drone;
delimiter //
create procedure load_drone (in ip_id varchar(40), in ip_tag integer, in ip_barcode varchar(40),
	in ip_more_packages integer, in ip_price integer)
sp_main: begin
	-- ensure that the drone being loaded is owned by the service
	-- ensure that the ingredient is valid
    -- ensure that the drone is located at the service home base
	-- ensure that the quantity of new packages is greater than zero
	-- ensure that the drone has sufficient capacity to carry the new packages
    -- add more of the ingredient to the drone
    
    if ((ip_id is null or ip_tag is null or ip_barcode is null or ip_more_packages is null or ip_price is null)
	or (ip_id = '' or ip_barcode = '' or ip_more_packages < 0 or ip_price < 0))
		then leave sp_main; end if;
    if (ip_id not in (select id from delivery_services)) then leave sp_main; end if;
    if (select hover from drones where (id = ip_id and tag = ip_tag)) != (select home_base from delivery_services where id = ip_id) then leave sp_main; end if;
    if ip_barcode not in (select barcode from ingredients) then leave sp_main; end if;
    if ip_more_packages <= 0 then leave sp_main; end if;
    
    if (select count(*) from payload where (id = ip_id and tag = ip_tag)) > 0 and (select capacity from drones where (id = ip_id and tag = ip_tag)) - (select sum(quantity) from payload where (id = ip_id and tag = ip_tag)) < ip_more_packages then
		leave sp_main; end if;
	if (select capacity from drones where (id = ip_id and tag = ip_tag)) < ip_more_packages then
		leave sp_main; end if;
        
	if ip_barcode in (select barcode from payload where (id = ip_id and tag = ip_tag)) then
		update payload
        set quantity = (select quantity from payload where (id = ip_id and tag = ip_tag and barcode = ip_barcode)) + ip_more_packages
        where (id = ip_id and tag = ip_tag and barcode = ip_barcode);
	else
		insert into payload (id, tag, barcode, quantity, price)
        values (ip_id, ip_tag, ip_barcode, ip_more_packages, ip_price);
	end if;

    -- if (ip_id in (select id from delivery_services)
--     and (select hover from drones where (id = ip_id and tag = ip_tag)) = (select home_base from delivery_services where id = ip_id)
--     and ip_barcode in (select barcode from ingredients)
--     and ip_more_packages > 0    
--     and (select capacity from drones where (id = ip_id and tag = ip_tag)) - (select sum(ifnull(quantity, 0)) from payload where (id = ip_id and tag = ip_tag)) >= ip_more_packages) then
-- 		if (ip_barcode in (select barcode from payload where (id = ip_id and tag = ip_tag))) then
-- 			update payload 
--             set quantity = (select quantity from payload where (id = ip_id and tag = ip_tag and barcode = ip_barcode)) + ip_more_packages
--             where (id = ip_id and tag = ip_tag and barcode = ip_barcode);
-- 		else
-- 			insert into payload (id, tag, barcode, quantity, price)
--             values (ip_id, ip_tag, ip_barcode, ip_more_packages, ip_price);
-- 		end if;
-- 	end if;
    
end //
delimiter ;

-- [18] refuel_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure allows us to add more fuel to a drone. The drone can only
be refueled if it's located at the delivery service's home base. */
-- -----------------------------------------------------------------------------
drop procedure if exists refuel_drone;
delimiter //
create procedure refuel_drone (in ip_id varchar(40), in ip_tag integer, in ip_more_fuel integer)
sp_main: begin
	-- ensure that the drone being switched is valid and owned by the service
    -- ensure that the drone is located at the service home base
    
    if ((ip_id is null or ip_tag is null or ip_more_fuel is null)
	or (ip_id = '' or ip_more_fuel < 0))
		then leave sp_main; end if;
    
    if (ip_tag in (select tag from drones)
    and ip_id in (select id from delivery_services)
    and (select hover from drones where (ip_id = id and ip_tag = tag)) = (select home_base from delivery_services where ip_id = id)) then
		set @newfuel = ((select fuel from drones where (ip_id = id and ip_tag = tag)) + ip_more_fuel);
        if @newfuel > 100 then 
			set @newfuel = 100;
		end if;
		update drones 
        set fuel = @newfuel
        where (ip_id = id and ip_tag = tag);
	end if;
    
end //
delimiter ;

-- [19] fly_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure allows us to move a single or swarm of drones to a new
location (i.e., destination). The main constraints on the drone(s) being able to
move to a new location are fuel and space.  A drone can only move to a destination
if it has enough fuel to reach the destination and still move from the destination
back to home base.  And a drone can only move to a destination if there's enough
space remaining at the destination.  For swarms, the flight directions will always
be given to the lead drone, but the swarm must always stay together. */
-- -----------------------------------------------------------------------------
drop function if exists fuel_required;
delimiter //
create function fuel_required (ip_departure varchar(40), ip_arrival varchar(40))
	returns integer reads sql data
begin
	if (ip_departure = ip_arrival) then return 0;
    else return (select 1 + truncate(sqrt(power(arrival.x_coord - departure.x_coord, 2) + power(arrival.y_coord - departure.y_coord, 2)), 0) as fuel
		from (select x_coord, y_coord from locations where label = ip_departure) as departure,
        (select x_coord, y_coord from locations where label = ip_arrival) as arrival);
	end if;
end //
delimiter ;

drop procedure if exists fly_drone;
delimiter //
create procedure fly_drone (in ip_id varchar(40), in ip_tag integer, in ip_destination varchar(40))
sp_main: begin
	-- ensure that the lead drone being flown is directly controlled and owned by the service
    -- ensure that the destination is a valid location
    -- ensure that the drone isn't already at the location
    -- ensure that the drone/swarm has enough fuel to reach the destination and (then) home base
    -- ensure that the drone/swarm has enough space at the destination for the flight
    
    if ((ip_id is null or ip_tag is null or ip_destination is null)
	or (ip_id = '' or ip_destination = ''))
		then leave sp_main; end if;
    
    if ip_tag not in (select tag from drones where ip_id = id)
		then leave sp_main; end if;
    if ip_destination not in (select label from locations)
		then leave sp_main; end if;
    if ip_destination in (select hover from drones where (ip_id = id and ip_tag = tag))
		then leave sp_main; end if;
	
    set @homeBase = (select home_base from delivery_services where id = ip_id);
    set @curr = (select hover from drones where (ip_id = id and ip_tag = tag));
    set @fuelReqTotal = fuel_required(ip_destination, @homeBase) + fuel_required(@curr, ip_destination);
	
    if (with recursive swarm (id, tag, fuel)
		as (select id, tag, fuel
        from drones
        where id = ip_id and tag = ip_tag
        union all
        select dr.id, dr.tag, dr.fuel
        from drones as dr
        inner join swarm on 
			swarm_id = swarm.id and swarm_tag = swarm.tag
		)
		select count(*) from swarm where fuel < @fuelReqTotal) > 0
			then leave sp_main; end if;
	
    set @atDest = (select count(*) from drones where hover in (select ip_destination from drones));
	if ((with recursive swarm (id, tag, fuel)
		as (select id, tag, fuel
		from drones
		where id = ip_id and tag = ip_tag
		union all
		select dr.id, dr.tag, dr.fuel
		from drones as dr
		inner join swarm on 
			swarm_id = swarm.id and swarm_tag = swarm.tag
	) select count(*) from swarm) + @atDest)
	> (select space from locations where label = ip_destination)
        then leave sp_main; end if;
        
	with recursive swarm (id, tag)
		as (select id, tag
		from drones
		where id = ip_id and tag = ip_tag
		union all
		select dr.id, dr.tag
		from drones as dr
		inner join swarm on 
			swarm_id = swarm.id and swarm_tag = swarm.tag
	)
    update drones
    set fuel = fuel - fuel_required(drones.hover, ip_destination), hover = ip_destination
    where (id, tag) in (select id, tag from swarm);
    
end //
delimiter ;

-- [20] purchase_ingredient()
-- -----------------------------------------------------------------------------
/* This stored procedure allows a restaurant to purchase ingredients from a drone
at its current location.  The drone must have the desired quantity of the ingredient
being purchased.  And the restaurant must have enough money to purchase the
ingredients.  If the transaction is otherwise valid, then the drone and restaurant
information must be changed appropriately.  Finally, we need to ensure that all
quantities in the payload table (post transaction) are greater than zero. */
-- -----------------------------------------------------------------------------
drop procedure if exists purchase_ingredient;
delimiter //
create procedure purchase_ingredient (in ip_long_name varchar(40), in ip_id varchar(40),
	in ip_tag integer, in ip_barcode varchar(40), in ip_quantity integer)
sp_main: begin
	-- ensure that the restaurant is valid
    -- ensure that the drone is valid and exists at the resturant's location
	-- ensure that the drone has enough of the requested ingredient
	-- update the drone's payload
    -- update the monies spent and gained for the drone and restaurant
    -- ensure all quantities in the payload table are greater than zero
    
    if ((ip_long_name is null or ip_id is null or ip_tag is null or ip_barcode is null or ip_quantity is null)
	or (ip_long_name = '' or ip_id = '' or ip_barcode = '' or ip_quantity < 0))
		then leave sp_main; end if;
    
    if (ip_long_name not in (select long_name from restaurants))
		then leave sp_main; end if;
	if (ip_tag not in (select tag from drones where ip_id = id))
		then leave sp_main; end if;
	if ((select hover from drones where ip_id = id and ip_tag = tag) != (select location from restaurants where long_name = ip_long_name))
		then leave sp_main; end if;
	if ((select quantity from payload where ip_id = id and ip_tag = tag and ip_barcode = barcode) <= ip_quantity)
		 then leave sp_main; end if;
	
    update payload set quantity = quantity - ip_quantity where ip_id = id and ip_tag = tag and ip_barcode = barcode;
    
    set @itemVal = ip_quantity * (select price from payload where (ip_id = id and ip_tag = tag and ip_barcode = barcode));
    update drones set sales = sales + @itemVal where (id = ip_id and tag = ip_tag);
    update restaurants set spent = spent + @itemVal where long_name = ip_long_name;
    
    delete from payload where quantity = 0;
    
end //
delimiter ;

-- [21] remove_ingredient()
-- -----------------------------------------------------------------------------
/* This stored procedure removes an ingredient from the system.  The removal can
occur if, and only if, the ingredient is not being carried by any drones. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_ingredient;
delimiter //
create procedure remove_ingredient (in ip_barcode varchar(40))
sp_main: begin
	-- ensure that the ingredient exists
    -- ensure that the ingredient is not being carried by any drones
    
    if (ip_barcode is null or ip_barcode = '')
		then leave sp_main; end if;
    
    if (ip_barcode in (select barcode from ingredients)
	and ip_barcode not in (select barcode from payload)) then
        delete from ingredients where (barcode = ip_barcode);
	end if;
    
end //
delimiter ;

-- [22] remove_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a drone from the system.  The removal can
occur if, and only if, the drone is not carrying any ingredients, and if it is
not leading a swarm. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_drone;
delimiter //
create procedure remove_drone (in ip_id varchar(40), in ip_tag integer)
sp_main: begin
	-- ensure that the drone exists
    -- ensure that the drone is not carrying any ingredients
	-- ensure that the drone is not leading a swarm
    
    if ((ip_id is null or ip_tag is null) or (ip_id = '' or ip_tag = ''))
		then leave sp_main; end if;
    
    if ip_tag not in (select tag from drones where id = ip_id)
		then leave sp_main; end if;
    if ip_tag in (select tag from payload where id = ip_id)
		then leave sp_main; end if;
    if ip_tag in (select swarm_tag from drones where swarm_id = ip_id)
		then leave sp_main; end if;
	
    delete from drones where id = ip_id and tag = ip_tag;
    
end //
delimiter ;

-- [23] remove_pilot_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a pilot from the system.  The removal can
occur if, and only if, the pilot is not controlling any drones.  Also, if the
pilot also has a worker role, then the worker information must be maintained;
otherwise, the pilot's information must be completely removed from the system. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_pilot_role;
delimiter //
create procedure remove_pilot_role (in ip_username varchar(40))
sp_main: begin
	-- ensure that the pilot exists
    -- ensure that the pilot is not controlling any drones
    -- remove all remaining information unless the pilot is also a worker
    
     if (ip_username is null or ip_username = '')
		then leave sp_main; end if;
    
	if ip_username not in (select username from pilots)
		then leave sp_main; end if;
    if ip_username in (select flown_by from drones)
		then leave sp_main; end if;
		if (ip_username in (select username from workers)) then
			delete from pilots where ip_username = username;
		else
			delete from pilots where ip_username = username;
            delete from employees where username = ip_username;
            delete from users where username = ip_username;
		end if;
    
end //
delimiter ;

-- [24] display_owner_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of an owner.
For each owner, it includes the owner's information, along with the number of
restaurants for which they provide funds and the number of different places where
those restaurants are located.  It also includes the highest and lowest ratings
for each of those restaurants, as well as the total amount of debt based on the
monies spent purchasing ingredients by all of those restaurants. And if an owner
doesn't fund any restaurants then display zeros for the highs, lows and debt. */
-- -----------------------------------------------------------------------------
create or replace view display_owner_view as
select owner_info.username, first_name, last_name, address, Restaurants, Locations, High, Low, Debt from
(select users.username, first_name, last_name, address 
from users join restaurant_owners
on users.username = restaurant_owners.username) as owner_info 
left join
(select restaurant_owners.username, count(distinct long_name) as Restaurants, count(distinct location) as Locations, ifnull(max(rating), 0) as High, ifnull(min(rating), 0) as Low, ifnull(sum(spent), 0) as Debt
from restaurant_owners left join restaurants
on restaurant_owners.username = restaurants.funded_by
group by username) as owner_data
on owner_info.username = owner_data.username;

-- [25] display_employee_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of an employee.
For each employee, it includes the username, tax identifier, hiring date and
experience level, along with the license identifer and piloting experience (if
applicable), and a 'yes' or 'no' depending on the manager status of the employee. */
-- -----------------------------------------------------------------------------
create or replace view display_employee_view as
select e.username, e.taxID, e.salary, e.hired, e.experience as 'Employee Experience',
ifnull(p.licenseID, 'n/a') as 'Pilot License',
ifnull(p.experience, 'n/a') as 'Pilot Experience',
if(d.manager is not null, 'yes', 'no') as Manager 
from employees as e
left join pilots as p
on e.username = p.username
left join delivery_services d
on e.username = d.manager;

-- [26] display_pilot_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of a pilot.
For each pilot, it includes the username, licenseID and piloting experience, along
with the number of drones that they are controlling. */
-- -----------------------------------------------------------------------------
create or replace view display_pilot_view as
with recursive swarm (username, licenseID, experience, id, tag, hover) as (
select pilots.username, pilots.licenseID, pilots.experience, drones.id, drones.tag, drones.hover
from pilots, drones
where pilots.username = drones.flown_by
union all
select swarm.username, swarm.licenseID, swarm.experience, d.id, d.tag, d.hover
from drones as d
inner join swarm on
swarm_id = swarm.id and swarm_tag = swarm.tag
) select pilots.username, pilots.licenseID, pilots.experience, ifnull(count(distinct swarm.tag), 0) as drones, ifnull(count(distinct swarm.hover), 0) as locations
from pilots left join swarm on pilots.username = swarm.username group by pilots.username;

-- [27] display_location_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of a location.
For each location, it includes the label, x- and y- coordinates, along with the
number of restaurants, delivery services and drones at that location. */
-- -----------------------------------------------------------------------------
create or replace view display_location_view as
select 
label, x_coord, y_coord,
ifnull(count(distinct restaurants.long_name), 0) as Restaurants,
ifnull(count(distinct delivery_services.long_name), 0) as Services,
ifnull(count(distinct tag), 0) as Drones
from locations
left join restaurants
on locations.label = restaurants.location
left join delivery_services
on locations.label = delivery_services.home_base
left join drones
on locations.label = drones.hover
group by locations.label;

-- [28] display_ingredient_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of the ingredients.
For each ingredient that is being carried by at least one drone, it includes a list of
the various locations where it can be purchased, along with the total number of packages
that can be purchased and the lowest and highest prices at which the ingredient is being
sold at that location. */
-- -----------------------------------------------------------------------------
create or replace view display_ingredient_view as
select iname as Ingredient, hover as Location, sum(quantity) as Available, min(price) as Low, max(price) as High from ingredients
left join payload 
on ingredients.barcode = payload.barcode
left join drones
on payload.id = drones.id and payload.tag = drones.tag
group by iname, hover
having hover is not null
order by iname;

-- [29] display_service_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of a delivery
service.  It includes the identifier, name, home base location and manager for the
service, along with the total sales from the drones.  It must also include the number
of unique ingredients along with the total cost and weight of those ingredients being
carried by the drones. */
-- -----------------------------------------------------------------------------
create or replace view display_service_view as
select services.Identifier, services.serviceName, services.Location, services.Manager, services.Sales, payloads.Ingredients, payloads.TotalCost, payloads.TotalWeight from 
(select S.id as Identifier, S.long_name as serviceName, S.home_base as Location, S.manager as Manager, SUM(sales) as Sales
from delivery_services S
join drones D on S.id = D.id
group by S.id) as services join
(select P.id as Service, count(distinct P.barcode) as Ingredients, sum(price * quantity) as TotalCost, sum(weight * quantity) as TotalWeight
from payload P inner join ingredients I on P.barcode = I.barcode
group by P.id) as payloads 
on services.Identifier = payloads.Service;

