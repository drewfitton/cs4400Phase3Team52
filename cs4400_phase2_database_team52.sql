-- CS4400: Introduction to Database Systems (Fall 2022)
-- Project Phase II: Create Table & Insert Statements [v0] Thursday, November 3, 2022

-- Team 52
-- Andrew Fitton (afitton3)
-- Aleksander Kaluza (akaluza3)

drop database if exists droneCompany;
create database if not exists droneCompany;
use droneCompany;

drop table if exists Users;
CREATE TABLE Users (
	username varchar(40),
    first_name varchar(100),
    last_name varchar(100),
    birthdate date,
    address varchar(500),
    primary key (username)
) engine = innodb;

insert into Users values
('agarcia7', 'Alejandro', 'Garcia', '1966-10-29', '710 Living Water Drive'),
('awilson5', 'Aaron', 'Wilson', '1963-11-11', '220 Peachtree Street'),
('bsummers4', 'Brie', 'Summers', '1976-02-09', '5105 Dragon Star Circle'),
('cjordan5', 'Clark', 'Jordan', '1966-06-05', '77 Infinite Stars Road'),
('ckann5', 'Carrot', 'Kann', '1972-09-01', '64 Knights Square Trail'),
('csoares8', 'Claire', 'Soares', '1965-09-03', '706 Living Stone Way'),
('echarles19', 'Ella', 'Charles', '1974-05-06', '22 Peachtree Street'),
('eross10', 'Erica', 'Ross', '1975-04-02', '22 Peachtree Street'),
('fprefontaine6', 'Ford', 'Prefontaine', '1961-01-28', '10 Hitch Hikers Lane'),
('hstark16', 'Harmon', 'Stark', '1971-10-27', '53 Tanker Top Lane'),
('jstone5', 'Jared', 'Stone', '1961-01-06', '101 Five Finger Way'),
('lrodriguez5', 'Lina', 'Rodriguez', '1975-04-02', '360 Corkscrew Circle'),
('mrobot1', 'Mister', 'Robot', '1988-11-02', '10 Autonomy Trace'),
('mrobot2', 'Mister', 'Robot', '1988-11-02', '10 Clone Me Circle'),
('rlopez6', 'Radish', 'Lopez', '1999-09-03', '8 Queens Route'),
('sprince6', 'Sarah', 'Prince', '1968-06-15', '22 Peachtree Street'),
('tmccall5', 'Trey', 'McCall', '1973-03-19', '360 Corkscrew Circle');


drop table if exists Employee;
CREATE TABLE Employee (
	username varchar(40),
    taxID char(11),
    experience integer,
    hired date,
    salary double,
    primary key (username),
    unique key (taxID),
    constraint fk1 foreign key (username) references Users (username)
) engine = innodb;

insert into Employee values
('agarcia7', '999-99-9999', '24', '2019-03-17', '41000'),
('awilson5', '111-11-1111', '9', '2020-03-15', '46000'),
('bsummers4', '000-00-0000', '17', '2018-12-06', '35000'),
('ckann5', '640-81-2357', '27', '2019-08-03', '46000'),
('csoares8', '888-88-8888', '26', '2019-02-25', '57000'),
('echarles19', '777-77-7777', '3', '2021-01-02', '27000'),
('eross10', '444-44-4444', '10', '2020-04-17', '61000'),
('fprefontaine6', '121-21-2121', '5', '2020-04-19', '20000'),
('hstark16', '555-55-5555', '20', '2018-07-23', '59000'),
('lrodriguez5', '222-22-2222', '20', '2019-04-15', '58000'),
('mrobot1', '101-01-0101', '8', '2015-05-27', '38000'),
('mrobot2', '010-10-1010', '8', '2015-05-27', '38000'),
('rlopez6', '123-58-1321', '51', '2017-02-05', '64000'),
('tmccall5', '333-33-3333', '29', '2018-10-17', '33000');


drop table if exists Owners;
CREATE TABLE Owners (
	username varchar(40),
    primary key (username),
    constraint fk2 foreign key (username) references Users (username)
) engine = innodb;

insert into Owners values ('cjordan5'), ('jstone5'), ('sprince6');


drop table if exists Pilot;
CREATE TABLE Pilot (
	username varchar(40),
	license_type char(6),
    experience integer,
    primary key (username),
    constraint fk3 foreign key (username) references Employee (username)
) engine = innodb;

insert into pilot values
('agarcia7', '610623', '38'),
('awilson5', '314159', '41'),
('bsummers4', '411911', '35'),
('csoares8', '343563', '7'),
('echarles19', '236001', '10'),
('fprefontaine6', '657483', '2'),
('lrodriguez5', '287182', '67'),
('mrobot1', '101010', '18'),
('rlopez6', '235711', '58'),
('tmccall5', '181633', '10');


drop table if exists Worker;
CREATE TABLE Worker (
	username varchar(40),
    primary key (username),
    constraint fk4 foreign key (username) references Employee (username)
) engine = innodb;

insert into worker values
('ckann5'),
('csoares8'),
('echarles19'),
('eross10'),
('hstark16'),
('mrobot2'),
('tmccall5');


drop table if exists Location;
CREATE TABLE Location (
	label varchar(40),
    x_coord integer,
    y_coord integer,
    space integer,
    primary key (label)
) engine = innodb;

insert into location values
('plaza', '-4', '-3', '10'),
('buckhead', '7', '10', '8'),
('avalon', '2', '15', NULL),
('mercedes', '-8', '5', NULL),
('midtown', '2', '1', '7'),
('airport', '5', '-6', '15'),
('highpoint', '11', '3', '4'),
('southside', '1', '-16', '5');


drop table if exists Restaurant;
CREATE TABLE Restaurant (
	rname varchar(40),
    rating integer,
    spent double,
    location varchar(40) not null,
    primary key (rname),
    constraint fk5 foreign key (location) references Location (label)
) engine = innodb;

insert into Restaurant values
('Bishoku', '5', '10', 'plaza'),
('Casi Cielo', '5', '30', 'plaza'),
('Ecco', '3', '0', 'buckhead'),
('Fogo de Chao', '4', '30', 'buckhead'),
('Hearth', '4', '0', 'avalon'),
('Il Giallo', '4', '10', 'mercedes'),
('Lure', '5', '20', 'midtown'),
('Micks', '2', '0', 'southside'),
('South City Kitchen', '5', '30', 'midtown'),
('Tre Vele', '4', '10', 'plaza');


drop table if exists Service;
CREATE TABLE Service (
	ID varchar(40),
    sname varchar (100),
    manager varchar(40),
    location varchar(40) not null,
    primary key (ID),
    constraint fk6 foreign key (location) references Location (label),
    constraint fk7 foreign key (manager) references Worker (username)
) engine = innodb;

insert into Service values
('hf', 'Herban Feast', 'hstark16', 'southside'),
('osf', 'On Safari Foods', 'eross10', 'southside'),
('rr', 'Ravishing Radish', 'echarles19', 'avalon');

drop table if exists Ingredient;
CREATE TABLE Ingredient (
	barcode varchar(40),
    iname varchar(100),
    weight integer,
    primary key (barcode)
) engine = innodb;

insert into ingredient values
('bv_4U5L7M', 'balsamic vinegar', '4'),
('clc_4T9U25X', 'caviar', '5'),
('ap_9T25E36L', 'foie gras', '4'),
('pr_3C6A9R', 'prosciutto', '6'),
('ss_2D4E6L', 'saffron', '3'),
('hs_5E7L23M', 'truffles', '3');


drop table if exists Drone;
CREATE TABLE Drone (
	serviceID varchar(40),
    tag varchar(40),
    fuel integer,
    capacity integer,
    sales integer,
    controlled_by varchar(40),
    hover_over varchar(40) not null,
    leaderID varchar(40),
    leaderTag varchar(40),
    primary key (serviceID, tag),
    -- unique key (tag),
    constraint fk8 foreign key (serviceID) references Service (ID),
    constraint fk9 foreign key (controlled_by) references Pilot (username),
    constraint fk10 foreign key (hover_over) references Location (label),
    constraint fk11 foreign key (leaderID, leaderTag) references Drone (serviceID, tag)
) engine = innodb;

insert into drone values
('hf', '1', '100', '6', '0', 'fprefontaine6', 'southside', NULL, NULL),
('hf', '5', '27', '7', '100', 'fprefontaine6', 'buckhead', NULL, NULL),
('hf', '8', '100', '8', '0', 'bsummers4', 'southside', NULL, NULL),
('hf', '11', '25', '10', '0', NULL, 'buckhead', 'hf', '5'),
('hf', '16', '17', '5', '40', 'fprefontaine6', 'buckhead', NULL, NULL),
('osf', '1', '100', '9', '0', 'awilson5', 'airport', NULL, NULL),
('osf', '2', '75', '7', '0', NULL, 'airport', 'osf', '1'),
('rr', '3', '100', '5', '50', 'agarcia7', 'avalon', NULL, NULL),
('rr', '7', '53', '5', '100', 'agarcia7', 'avalon', NULL, NULL),
('rr', '8', '100', '6', '0', 'agarcia7', 'highpoint', NULL, NULL),
('rr', '11', '90', '6', '0', NULL, 'highpoint', 'rr', '8');


drop table if exists Contain;
CREATE TABLE Contain (
	barcode varchar(40),
    serviceID varchar(40),
    tag varchar(40),
    price integer,
    quantity integer,
    primary key (barcode, serviceID, tag),
    constraint fk12 foreign key (barcode) references Ingredient (barcode),
    constraint fk13 foreign key (serviceID, tag) references Drone (serviceID, tag)
) engine = innodb;

insert into Contain values
('clc_4T9U25X', 'rr', '3', '28', '2'),
('clc_4T9U25X', 'hf', '5', '30', '1'),
('pr_3C6A9R', 'osf', '1', '20', '5'),
('pr_3C6A9R', 'hf', '8', '18', '4'),
('ss_2D4E6L', 'osf', '1', '23', '3'),
('ss_2D4E6L', 'hf', '11', '19', '3'),
('ss_2D4E6L', 'hf', '1', '27', '6'),
('hs_5E7L23M', 'osf', '2', '14', '7'),
('hs_5E7L23M', 'rr', '3', '15', '2'),
('hs_5E7L23M', 'hf', '5', '17', '4');



drop table if exists Work_For;
CREATE TABLE Work_For (
	username varchar(40),
    ID varchar(40),
    primary key (username, ID),
    constraint fk14 foreign key (username) references Employee (username),
    constraint fk15 foreign key (ID) references Service (ID)
) engine = innodb;

insert into Work_For values
('agarcia7', 'rr'),
('awilson5', 'osf'),
('bsummers4', 'hf'),
('ckann5', 'osf'),
('echarles19', 'rr'),
('eross10', 'osf'),
('fprefontaine6', 'hf'),
('hstark16', 'hf'),
('mrobot1', 'osf'),
('mrobot1', 'rr'),
('rlopez6', 'rr'),
('tmccall5', 'hf');


drop table if exists Fund;
CREATE TABLE Fund (
	username varchar(40),
    restName varchar(40),
    invested integer,
    date_invested date,
    primary key (username, restName),
    constraint fk16 foreign key (username) references Owners (username),
    constraint fk17 foreign key (restName) references Restaurant (rname)
) engine = innodb;

insert into Fund values
('jstone5', 'Ecco', '20', '2022-10-25'),
('sprince6', 'Il Giallo', '10', '2022-03-06'),
('jstone5', 'Lure', '30', '2022-09-08'),
('jstone5', 'South City Kitchen', '5', '2022-07-25');

