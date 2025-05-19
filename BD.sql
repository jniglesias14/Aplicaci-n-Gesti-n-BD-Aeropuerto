/*CREATE USER user3@localhost IDENTIFIED BY 'A12345a';*/
create database aeropuerto;
use aeropuerto;
grant all on aeropuerto.* to user2@localhost;


create table terminales(
    nombre char(2) check (nombre regexp '^T[1-9]$'),
    descripcion varchar(100),
    constraint terminales_pk primary key (nombre)
 );

create table puertas_embarques(
    nombre char(2) check ( nombre regexp '[A-Z0-9]'),
    nombre_terminales char(2) not null,
    constraint puertas_embarques_pk primary key (nombre,nombre_terminales),
    CONSTRAINT puertas_embarques_fk FOREIGN KEY (nombre_terminales) REFERENCES terminales(nombre) ON UPDATE CASCADE ON DELETE CASCADE
);

create table pistas(
    codigo char(7) check ( codigo regexp '^[0-3][0-9][LCR]/[0-3][0-9][LCR]$' ),
    superficie varchar(50) not null,
    estado varchar(50) check ( estado in ('operativa','mantenimiento','cerrada')) not null ,
    constraint pistas_pk primary key (codigo)
);

create table comercios(
                          id int auto_increment primary key,
    nombre varchar(50) not null ,
    web varchar(50),
    contacto char(9),
    estado varchar(50) check(estado in('abierto','cerrado')) not null ,
    nombre_terminales char(2) not null ,
    constraint comercios_fk1 foreign key (nombre_terminales) references terminales(nombre) ON UPDATE CASCADE ON DELETE CASCADE
);

create table salas_VIP(
                          id int auto_increment primary key,
                          servicios text not null ,
                          estado varchar(50) check(estado in('abierto','cerrado')) not null ,
                          nombre_terminales char(2) not null ,
                          constraint comercios_fk foreign key (nombre_terminales) references terminales(nombre) ON UPDATE CASCADE ON DELETE CASCADE
);

create table aduanas(
                        id int auto_increment primary key ,
                        nombre varchar(50) not null ,
                        tipo text not null ,
                        nombre_terminales char(2) not null ,
                        constraint aduanas_fk foreign key (nombre_terminales) references terminales(nombre) on update cascade on delete cascade

);

create table parkings(
                         id int auto_increment primary key ,
                         capacidad int not null ,
                         nombre_terminales char(2) not null ,
                         constraint parkings_fk foreign key (nombre_terminales) references terminales(nombre) on update cascade on delete cascade

);

create table estacionamientos(
                                 id varchar(20) check ( id regexp '^[A-Z][0-9]+$') primary key ,
    estado varchar(50) check ( estado in('disponible','ocupado','fuera de servicio') ) not null ,
    precio decimal not null ,
    fecha_inicio date,
    fecha_fin date,
    id_parkings int not null ,
    constraint estacionamientos_fk foreign key (id_parkings) references parkings(id) on update cascade on delete cascade

);

create table paises(
                       id_pais char(3) check ( id_pais regexp '[A-Z]{3}') primary key ,
    nombre varchar(50) not null,
    constraint paises_uk unique (nombre)
);

create table ciudades(
                         id_ciudad char(3) check ( id_ciudad regexp '[A-Z]{3}') primary key ,
   nombre varchar(50) not null,
    id_paises char(3),
   constraint ciudades_uk unique (nombre),
    constraint ciudades_fk foreign key (id_paises) references paises(id_pais)ON UPDATE CASCADE ON DELETE CASCADE
);

create table aerolineas(
                           id char(3) check ( id regexp '[A-Z]{3}') primary key ,
    nombre varchar(50) not null ,
    web varchar(100),
    id_paises char(3) not null,
    constraint aerolineas_fk foreign key (id_paises) references paises(id_pais)ON UPDATE CASCADE ON DELETE CASCADE
);

create table aviones(
                        id varchar(10) check ( id regexp '^[A-Z]{1,3}-[0-9A-Z]{1,5}$') primary key ,
    modelo varchar(50) not null ,
    longitud decimal not null ,
    fecha_fab date not null ,
    capacidad int not null ,
    numero_motores int not null ,
    id_aerolineas char(3) not null ,
    constraint aviones_fk foreign key (id_aerolineas) references aerolineas(id)ON UPDATE CASCADE ON DELETE CASCADE
);

create table asientos(
                         letra char(1) check ( letra regexp '[A-Z]'),
  numero varchar(3) check ( numero regexp '[0-9]{1,3}'),
  tipo varchar(50) not null,
  id_aviones varchar(10),
  constraint asientos_pk primary key (letra,numero,id_aviones),
  constraint asientos_fk foreign key (id_aviones) references aviones(id)ON UPDATE CASCADE ON DELETE CASCADE
);


create table vuelos_salidas(
                               id char(6) check( id regexp '[A-Z]{3}[0-9]{3}'),
  estado varchar(50) check(estado in ('programado','retrasado','cancelado','embarque')) not null ,
  fecha_salida datetime not null ,
  fecha_llegada datetime not null,
  nombre_puertas_embarques char(2) not null ,
  nombre_puertas_embarques_terminales char(2) not null,
  id_ciudades char(3) not null ,
  codigo_pistas char(7) not null ,
  id_aviones varchar(10) not null ,
    constraint vuelos_salidas_fk3 foreign key (id_aviones) references aviones(id) on delete  cascade on update cascade,
    constraint vuelos_salidas_fk4  foreign key (codigo_pistas) references pistas(codigo) on delete cascade on update cascade,
  constraint vuelos_salidas_fk1 foreign key (id_ciudades) references ciudades(id_ciudad) on delete cascade on update cascade,
  constraint vuelos_salidas_pk primary key (id,fecha_salida),
  constraint  vuelos_salidas_fk2 foreign key (nombre_puertas_embarques,nombre_puertas_embarques_terminales) references puertas_embarques(nombre, nombre_terminales) on delete cascade on update cascade
);

create table personas(
                         dni char(9) check ( dni regexp '[0-9]{8}[A-Z]') primary key ,
    nombre varchar(50) not null ,
    apellido1 varchar(50) not null ,
    apellido2 varchar(50),
    gmail varchar(50)
);

create table clientes(
                         dni_personas char(9)  primary key ,
                         tipo varchar(50) not null ,
                         constraint clientes_fk1 foreign key (dni_personas) references personas(dni) on delete cascade on update cascade
);

create table mantenimiento(
                              dni_personas char(9)  primary key ,
                              constraint mantenimiento_fk1 foreign key (dni_personas) references personas(dni) on delete cascade on update cascade
);

create table seguridad(
                          dni_personas char(9)  primary key ,
                          tipo varchar(50) not null ,
                          constraint seguridad_fk1 foreign key (dni_personas) references personas(dni) on delete cascade on update cascade
);

create table infraestructura(
                                dni_personas char(9)  primary key ,
                                constraint infraestructura_fk1 foreign key (dni_personas) references personas(dni) on delete cascade on update cascade
);

create table tripulacion(
                            dni_personas char(9)  primary key ,
                            constraint tripulacion_fk1 foreign key (dni_personas) references personas(dni) on delete cascade on update cascade
);

create table pilotos(
                        dni_tripulacion char(9)  primary key ,
                        constraint pilotos_fk1 foreign key (dni_tripulacion) references tripulacion(dni_personas) on delete cascade on update cascade
);

create table copilotos(
                          dni_tripulacion char(9)  primary key ,
                          constraint copilotos_fk1 foreign key (dni_tripulacion) references tripulacion(dni_personas) on delete cascade on update cascade
);

create table azafatas(
                         dni_tripulacion char(9)  primary key ,
                         constraint azafatas_fk1 foreign key (dni_tripulacion) references tripulacion(dni_personas) on delete cascade on update cascade
);

create table check_in(
                         id int auto_increment primary key ,
                         estado varchar(50) check ( estado in ('abierto','cerrado')),
                         nombre_terminales char(2) not null,
                         constraint check_in_fk1 foreign key (nombre_terminales) references terminales(nombre)ON UPDATE CASCADE ON DELETE CASCADE

);

create table trabajar_1(
                           dni_infraestructura  char(9),
                           id_check_in int,
                           constraint trabajar_1_pk primary key (dni_infraestructura,id_check_in),
                           constraint trabajar_1_fk1 foreign key (dni_infraestructura) references infraestructura(dni_personas)ON UPDATE CASCADE ON DELETE CASCADE,
                           constraint trabajar_1_fk2 foreign key (id_check_in) references check_in(id)ON UPDATE CASCADE ON DELETE CASCADE
);

create table trabajar_2(
                           dni_infraestructura  char(9),
                           id_comercios int,
                           constraint trabajar_2_pk primary key (dni_infraestructura,id_comercios),
                           constraint trabajar_2_fk1 foreign key (dni_infraestructura) references infraestructura(dni_personas)ON UPDATE CASCADE ON DELETE CASCADE,
                           constraint trabajar_2_fk2 foreign key (id_comercios) references comercios(id)ON UPDATE CASCADE ON DELETE CASCADE
);

create table trabajar_3(
                           dni_infraestructura  char(9),
                           id_salas_vip int,
                           constraint trabajar_3_pk primary key (dni_infraestructura,id_salas_vip),
                           constraint trabajar_3_fk1 foreign key (dni_infraestructura) references infraestructura(dni_personas)ON UPDATE CASCADE ON DELETE CASCADE,
                           constraint trabajar_3_fk2 foreign key (id_salas_vip) references salas_VIP(id)ON UPDATE CASCADE ON DELETE CASCADE
);

create table trabajar_4(
                           dni_infraestructura  char(9),
                           id_parkings int,
                           constraint trabajar_4_pk primary key (dni_infraestructura,id_parkings),
                           constraint trabajar_4_fk1 foreign key (dni_infraestructura) references infraestructura(dni_personas)ON UPDATE CASCADE ON DELETE CASCADE,
                           constraint trabajar_4_fk2 foreign key (id_parkings) references parkings(id)ON UPDATE CASCADE ON DELETE CASCADE
);

create table trabajar_5(
                           dni_seguridad  char(9),
                           id_aduanas int,
                           constraint trabajar_5_pk primary key (dni_seguridad,id_aduanas),
                           constraint trabajar_5_fk1 foreign key (dni_seguridad) references seguridad(dni_personas) ON UPDATE CASCADE ON DELETE CASCADE,
                           constraint trabajar_5_fk2 foreign key (id_aduanas) references aduanas(id)ON UPDATE CASCADE ON DELETE CASCADE
);

create table trabajar_6(
                           dni_mantenimiento  char(9),
                           codigo_pistas char(7) ,
                           constraint trabajar_6_pk primary key (dni_mantenimiento,codigo_pistas),
                           constraint trabajar_6_fk1 foreign key (dni_mantenimiento) references mantenimiento(dni_personas)ON UPDATE CASCADE ON DELETE CASCADE,
                           constraint trabajar_6_fk2 foreign key (codigo_pistas) references pistas(codigo)ON UPDATE CASCADE ON DELETE CASCADE
);

create table reservas(
                         id_reserva int auto_increment ,
                         fecha_r date not null ,
                         dni_clientes char(9) not null ,
                         id_vuelos_salidas char(6) not null,
                         fecha_vuelos_salidas datetime not null,
                         id_check_in int,
                         constraint  reservas_pk primary key (id_reserva,fecha_r),
                         constraint reservas_fk1 foreign key (dni_clientes) references clientes(dni_personas)ON UPDATE CASCADE ON DELETE CASCADE,
                         constraint  reservas_fk2 foreign key (id_vuelos_salidas,fecha_vuelos_salidas) references  vuelos_salidas(id,fecha_salida)ON UPDATE CASCADE ON DELETE CASCADE,
                         constraint reservas_fk3 foreign key (id_check_in) references check_in(id)ON UPDATE CASCADE ON DELETE CASCADE
);

create table asientos_vuelos(
                                letra_asientos char(1) ,
                                numero_asientos varchar(10) ,
                                id_aviones_asientos varchar(10),
                                precio decimal not null ,
                                id_vuelos_salidas char(6) not null ,
                                fecha_vuelos_salidas datetime not null ,
                                id_reservas int,
                                fecha_reservas date,
                                estado varchar(50) check ( estado in ('disponible','no disponible') ) not null,
                                constraint asientos_vuelos_pk primary key (letra_asientos,numero_asientos,id_aviones_asientos),
                                constraint asientos_vuelos_fk1 foreign key (letra_asientos,numero_asientos,id_aviones_asientos) references asientos(letra,numero,id_aviones)ON UPDATE CASCADE ON DELETE CASCADE,
                                constraint asientos_vuelos_fk2 foreign key (id_vuelos_salidas,fecha_vuelos_salidas) references  vuelos_salidas(id,fecha_salida)ON UPDATE CASCADE ON DELETE CASCADE,
                                constraint asientos_vuelos_fk3 foreign key (id_reservas,fecha_reservas) references reservas(id_reserva,fecha_r)ON UPDATE CASCADE ON DELETE CASCADE
);


create table billetes(
                         id_billete int auto_increment,
                         fecha date ,
                         id_vuelos_salidas char(6)not null ,
                         fecha_vuelos_salidas datetime not null ,
                         dni_clientes char(9) not null ,
                         id_reservas int  ,
                         fecha_reservas date  ,
                         tarjeta_embarque varchar(20) not null,
                         constraint billetes_pk primary key (id_billete,fecha),
                         constraint billetes_fk1 foreign key (id_vuelos_salidas,fecha_vuelos_salidas) references vuelos_salidas(id,fecha_salida)ON UPDATE CASCADE ON DELETE CASCADE,
                         constraint billetes_fk2 foreign key (dni_clientes) references clientes(dni_personas)ON UPDATE CASCADE ON DELETE CASCADE,
                         constraint billetes_fk3 foreign key (id_reservas,fecha_reservas) references reservas(id_reserva,fecha_r)ON UPDATE CASCADE ON DELETE CASCADE
);

create table equipaje(
                         id varchar(20) primary key ,
                         tipo varchar(50),
                         peso decimal not null ,
                         dni_clientes char(9)not null ,
                         id_vuelos_salidas char(6) not null ,
                         fecha_vuelos_salidas datetime not null ,
                         constraint equipaje_fk1 foreign key (dni_clientes) references clientes(dni_personas) ON UPDATE CASCADE ON DELETE CASCADE,
                         constraint equipaje_fk2 foreign key (id_vuelos_salidas,fecha_vuelos_salidas) references vuelos_salidas(id,fecha_salida)ON UPDATE CASCADE ON DELETE CASCADE
);

create table vuelos_llegadas(
                                codigo char(6) ,
                                fecha_salida datetime,
                                fecha_llegada datetime,
                                estado  varchar(50) check(estado in ('programado','retrasado','cancelado','embarque')) not null ,
                                salida_ciudades char(3) not null ,
                                puertas_embarques char(2),
                                nombre_terminales char(2),
                                codigo_pistas char(7) not null,
                                constraint vuelos_llegadas_pk primary key (codigo,fecha_salida),
                                constraint vuelos_llegadas_fk1 foreign key (puertas_embarques,nombre_terminales) references puertas_embarques(nombre,nombre_terminales)ON UPDATE CASCADE ON DELETE CASCADE,
                                constraint  vuelos_llegadas_fk2 foreign key (codigo_pistas) references pistas(codigo)ON UPDATE CASCADE ON DELETE CASCADE,
                                constraint vuelos_llegadas_fk3 foreign key (salida_ciudades) references ciudades(id_ciudad)ON UPDATE CASCADE ON DELETE CASCADE
);

create table trabajar_7(
                           dni_personas_tripulacion char(9),
                           id_vuelos_salidas char(6),
                           fecha_salida_vuelos_salidas datetime,
                           constraint trabajar_7_pk primary key (dni_personas_tripulacion,id_vuelos_salidas,fecha_salida_vuelos_salidas),
                           constraint trabajar_7_fk1 foreign key(dni_personas_tripulacion) references tripulacion(dni_personas)ON UPDATE CASCADE ON DELETE CASCADE,
                           constraint trabajar_7_fk2 foreign key (id_vuelos_salidas,fecha_salida_vuelos_salidas) references vuelos_salidas(id,fecha_salida)ON UPDATE CASCADE ON DELETE CASCADE
);
















select * from terminales;
insert into terminales values ('T1','Vuelos nacionales');
insert into terminales values ('T2','Vuelos nacionales');
insert into terminales values ('T3','Vuelos europeos');
insert into terminales values ('T4','Vuelos internacionales');

select * from puertas_embarques;
insert into puertas_embarques values ('A1','T1');
insert into puertas_embarques values ('A2','T1');
insert into puertas_embarques values ('A3','T1');
insert into puertas_embarques values ('B1','T1');
insert into puertas_embarques values ('B2','T1');
insert into puertas_embarques values ('B3','T1');
insert into puertas_embarques values ('C1','T1');
insert into puertas_embarques values ('C2','T1');
insert into puertas_embarques values ('C3','T1');

insert into puertas_embarques values ('D1','T2');
insert into puertas_embarques values ('D2','T2');
insert into puertas_embarques values ('D3','T2');
insert into puertas_embarques values ('E1','T2');
insert into puertas_embarques values ('E2','T2');
insert into puertas_embarques values ('E3','T2');
insert into puertas_embarques values ('F1','T2');
insert into puertas_embarques values ('F2','T2');
insert into puertas_embarques values ('F3','T2');

insert into puertas_embarques values ('G1','T3');
insert into puertas_embarques values ('G2','T3');
insert into puertas_embarques values ('G3','T3');
insert into puertas_embarques values ('H1','T3');
insert into puertas_embarques values ('H2','T3');
insert into puertas_embarques values ('H3','T3');
insert into puertas_embarques values ('I1','T3');
insert into puertas_embarques values ('I2','T3');
insert into puertas_embarques values ('I3','T3');

insert into puertas_embarques values ('J1','T4');
insert into puertas_embarques values ('J2','T4');
insert into puertas_embarques values ('J3','T4');
insert into puertas_embarques values ('K1','T4');
insert into puertas_embarques values ('K2','T4');
insert into puertas_embarques values ('K3','T4');
insert into puertas_embarques values ('L1','T4');
insert into puertas_embarques values ('L2','T4');
insert into puertas_embarques values ('L3','T4');

select * from pistas;
INSERT INTO pistas VALUES
                       ('09L/27R', 'asfalto', 'operativa'),
                       ('18L/36R', 'asfalto', 'mantenimiento'),
                       ('10L/28R', 'asfalto', 'cerrada'),
                       ('11R/29L', 'asfalto', 'operativa'),
                       ('12L/30R', 'asfalto', 'mantenimiento'),
                       ('13R/31L', 'asfalto', 'cerrada'),
                       ('14L/32R', 'asfalto', 'operativa'),
                       ('15R/33L', 'asfalto', 'mantenimiento'),
                       ('16L/34R', 'asfalto', 'cerrada'),
                       ('17R/35L', 'asfalto', 'operativa'),
                       ('09R/27L', 'asfalto', 'mantenimiento'),
                       ('18R/36L', 'asfalto', 'cerrada'),
                       ('10R/28L', 'asfalto', 'operativa'),
                       ('11L/29R', 'asfalto', 'mantenimiento'),
                       ('12R/30L', 'asfalto', 'cerrada'),
                       ('13L/31R', 'asfalto', 'operativa'),
                       ('14R/32L', 'asfalto', 'mantenimiento'),
                       ('15L/33R', 'asfalto', 'cerrada'),
                       ('16R/34L', 'asfalto', 'operativa'),
                       ('17L/35R', 'asfalto', 'mantenimiento'),
                       ('08L/26R', 'asfalto', 'cerrada'),
                       ('08R/26L', 'asfalto', 'operativa'),
                       ('07L/25R', 'asfalto', 'mantenimiento'),
                       ('07R/25L', 'asfalto', 'cerrada'),
                       ('06L/24R', 'asfalto', 'operativa'),
                       ('06R/24L', 'asfalto', 'mantenimiento'),
                       ('05L/23R', 'asfalto', 'cerrada'),
                       ('05R/23L', 'asfalto', 'operativa'),
                       ('04L/22R', 'asfalto', 'mantenimiento'),
                       ('04R/22L', 'asfalto', 'cerrada');

select * from parkings;
insert into parkings values('1','300','T1'),('2','300','T2'),('3','1000','T3'),('4','2000','T4');

select * from estacionamientos;
-- Inserts para parking con id 1
INSERT INTO estacionamientos VALUES ('A1', 'disponible', 10.50, NULL, NULL, 1);
INSERT INTO estacionamientos VALUES ('A2', 'ocupado', 15.00, '2024-07-01', '2024-07-05', 1);
INSERT INTO estacionamientos VALUES ('A3', 'disponible', 10.50, NULL, NULL, 1);
INSERT INTO estacionamientos VALUES ('A4', 'ocupado', 20.00, '2024-07-03', '2024-07-10', 1);
INSERT INTO estacionamientos VALUES ('A5', 'disponible', 10.50, NULL, NULL, 1);
INSERT INTO estacionamientos VALUES ('A6', 'fuera de servicio', 12.00, NULL, NULL, 1);
INSERT INTO estacionamientos VALUES ('A7', 'disponible', 10.50, NULL, NULL, 1);
INSERT INTO estacionamientos VALUES ('A8', 'ocupado', 18.00, '2024-07-02', '2024-07-07', 1);
INSERT INTO estacionamientos VALUES ('A9', 'disponible', 10.50, NULL, NULL, 1);
INSERT INTO estacionamientos VALUES ('A10', 'disponible', 10.50, NULL, NULL, 1);

-- Inserts para parking con id 2
INSERT INTO estacionamientos VALUES ('B1', 'disponible', 12.00, NULL, NULL, 2);
INSERT INTO estacionamientos VALUES ('B2', 'ocupado', 14.00, '2024-07-01', '2024-07-04', 2);
INSERT INTO estacionamientos VALUES ('B3', 'disponible', 12.00, NULL, NULL, 2);
INSERT INTO estacionamientos VALUES ('B4', 'fuera de servicio', 13.00, NULL, NULL, 2);
INSERT INTO estacionamientos VALUES ('B5', 'disponible', 12.00, NULL, NULL, 2);
INSERT INTO estacionamientos VALUES ('B6', 'ocupado', 17.00, '2024-07-02', '2024-07-08', 2);
INSERT INTO estacionamientos VALUES ('B7', 'disponible', 12.00, NULL, NULL, 2);
INSERT INTO estacionamientos VALUES ('B8', 'ocupado', 19.00, '2024-07-03', '2024-07-06', 2);
INSERT INTO estacionamientos VALUES ('B9', 'disponible', 12.00, NULL, NULL, 2);
INSERT INTO estacionamientos VALUES ('B10', 'disponible', 12.00, NULL, NULL, 2);

-- Inserts para parking con id 3
INSERT INTO estacionamientos VALUES ('C1', 'disponible', 11.00, NULL, NULL, 3);
INSERT INTO estacionamientos VALUES ('C2', 'ocupado', 16.00, '2024-07-01', '2024-07-05', 3);
INSERT INTO estacionamientos VALUES ('C3', 'disponible', 11.00, NULL, NULL, 3);
INSERT INTO estacionamientos VALUES ('C4', 'fuera de servicio', 14.00, NULL, NULL, 3);
INSERT INTO estacionamientos VALUES ('C5', 'disponible', 11.00, NULL, NULL, 3);
INSERT INTO estacionamientos VALUES ('C6', 'ocupado', 18.00, '2024-07-03', '2024-07-07', 3);
INSERT INTO estacionamientos VALUES ('C7', 'disponible', 11.00, NULL, NULL, 3);
INSERT INTO estacionamientos VALUES ('C8', 'ocupado', 20.00, '2024-07-04', '2024-07-09', 3);
INSERT INTO estacionamientos VALUES ('C9', 'disponible', 11.00, NULL, NULL, 3);
INSERT INTO estacionamientos VALUES ('C10', 'disponible', 11.00, NULL, NULL, 3);

-- Inserts para parking con id 4
INSERT INTO estacionamientos VALUES ('D1', 'disponible', 13.00, NULL, NULL, 4);
INSERT INTO estacionamientos VALUES ('D2', 'ocupado', 15.00, '2024-07-01', '2024-07-04', 4);
INSERT INTO estacionamientos VALUES ('D3', 'disponible', 13.00, NULL, NULL, 4);
INSERT INTO estacionamientos VALUES ('D4', 'fuera de servicio', 16.00, NULL, NULL, 4);
INSERT INTO estacionamientos VALUES ('D5', 'disponible', 13.00, NULL, NULL, 4);
INSERT INTO estacionamientos VALUES ('D6', 'ocupado', 19.00, '2024-07-03', '2024-07-06', 4);
INSERT INTO estacionamientos VALUES ('D7', 'disponible', 13.00, NULL, NULL, 4);
INSERT INTO estacionamientos VALUES ('D8', 'ocupado', 21.00, '2024-07-05', '2024-07-08', 4);
INSERT INTO estacionamientos VALUES ('D9', 'disponible', 13.00, NULL, NULL, 4);
INSERT INTO estacionamientos VALUES ('D10', 'disponible', 13.00, NULL, NULL, 4);

select * from paises;
INSERT INTO paises VALUES ('USA', 'United States');
INSERT INTO paises VALUES ('CAN', 'Canada');
INSERT INTO paises VALUES ('MEX', 'Mexico');
INSERT INTO paises VALUES ('BRA', 'Brazil');
INSERT INTO paises VALUES ('ARG', 'Argentina');
INSERT INTO paises VALUES ('GBR', 'United Kingdom');
INSERT INTO paises VALUES ('FRA', 'France');
INSERT INTO paises VALUES ('DEU', 'Germany');
INSERT INTO paises VALUES ('ITA', 'Italy');
INSERT INTO paises VALUES ('ESP', 'Spain');
INSERT INTO paises VALUES ('RUS', 'Russia');
INSERT INTO paises VALUES ('CHN', 'China');
INSERT INTO paises VALUES ('JPN', 'Japan');
INSERT INTO paises VALUES ('AUS', 'Australia');
INSERT INTO paises VALUES ('IND', 'India');
INSERT INTO paises VALUES ('ZAF', 'South Africa');
INSERT INTO paises VALUES ('EGY', 'Egypt');
INSERT INTO paises VALUES ('TUR', 'Turkey');
INSERT INTO paises VALUES ('SAU', 'Saudi Arabia');
INSERT INTO paises VALUES ('IRN', 'Iran');

select * from ciudades;
INSERT INTO ciudades VALUES ('NYC', 'New York', 'USA');
INSERT INTO ciudades VALUES ('LAX', 'Los Angeles', 'USA');
INSERT INTO ciudades VALUES ('CHI', 'Chicago', 'USA');
INSERT INTO ciudades VALUES ('TOR', 'Toronto', 'CAN');
INSERT INTO ciudades VALUES ('VAN', 'Vancouver', 'CAN');
INSERT INTO ciudades VALUES ('MTL', 'Montreal', 'CAN');
INSERT INTO ciudades VALUES ('MEX', 'Mexico City', 'MEX');
INSERT INTO ciudades VALUES ('GDL', 'Guadalajara', 'MEX');
INSERT INTO ciudades VALUES ('CUN', 'Cancun', 'MEX');
INSERT INTO ciudades VALUES ('RIO', 'Rio de Janeiro', 'BRA');
INSERT INTO ciudades VALUES ('SAO', 'Sao Paulo', 'BRA');
INSERT INTO ciudades VALUES ('BUE', 'Buenos Aires', 'ARG');
INSERT INTO ciudades VALUES ('LON', 'London', 'GBR');
INSERT INTO ciudades VALUES ('PAR', 'Paris', 'FRA');
INSERT INTO ciudades VALUES ('BER', 'Berlin', 'DEU');
INSERT INTO ciudades VALUES ('ROM', 'Rome', 'ITA');
INSERT INTO ciudades VALUES ('BCN', 'Barcelona', 'ESP');
INSERT INTO ciudades VALUES ('MOS', 'Moscow', 'RUS');
INSERT INTO ciudades VALUES ('PEK', 'Beijing', 'CHN');
INSERT INTO ciudades VALUES ('TYO', 'Tokyo', 'JPN');
INSERT INTO ciudades VALUES ('SYD', 'Sydney', 'AUS');
INSERT INTO ciudades VALUES ('DEL', 'Delhi', 'IND');
INSERT INTO ciudades VALUES ('JNB', 'Johannesburg', 'ZAF');
INSERT INTO ciudades VALUES ('CAI', 'Cairo', 'EGY');
INSERT INTO ciudades VALUES ('IST', 'Istanbul', 'TUR');
INSERT INTO ciudades VALUES ('RUH', 'Riyadh', 'SAU');
INSERT INTO ciudades VALUES ('THR', 'Tehran', 'IRN');

select * from aerolineas;
INSERT INTO aerolineas VALUES ('AAL', 'American Airlines',  'https://www.aa.com', 'USA');
INSERT INTO aerolineas VALUES ('ACA', 'Air Canada',  'https://www.aircanada.com', 'CAN');
INSERT INTO aerolineas VALUES ('AMX', 'Aeromexico',  'https://www.aeromexico.com', 'MEX');
INSERT INTO aerolineas VALUES ('GLO', 'Gol Linhas Aéreas',  'https://www.voegol.com.br', 'BRA');
INSERT INTO aerolineas VALUES ('ARG', 'Aerolineas Argentinas',  'https://www.aerolineas.com.ar', 'ARG');
INSERT INTO aerolineas VALUES ('BAW', 'British Airways',  'https://www.britishairways.com', 'GBR');
INSERT INTO aerolineas VALUES ('AFR', 'Air France',  'https://www.airfrance.com', 'FRA');
INSERT INTO aerolineas VALUES ('DLH', 'Lufthansa', 'https://www.lufthansa.com', 'DEU');
INSERT INTO aerolineas VALUES ('AZA', 'Alitalia', 'https://www.alitalia.com', 'ITA');
INSERT INTO aerolineas VALUES ('IBE', 'Iberia', 'https://www.iberia.com', 'ESP');

select * from aviones;
INSERT INTO aviones VALUES ('AA-001', 'Boeing 737-800', 39.5, '2023-01-15', 160, 2, 'AAL');
INSERT INTO aviones VALUES ('AA-002', 'Boeing 787-9 Dreamliner', 63.0, '2022-05-20', 250, 2, 'AAL');
INSERT INTO aviones VALUES ('ACA-001', 'Airbus A320', 37.8, '2021-08-10', 180, 2, 'ACA');
INSERT INTO aviones VALUES ('ACA-002', 'Boeing 767-300ER', 54.9, '2020-12-05', 250, 2, 'ACA');
INSERT INTO aviones VALUES ('AMX-001', 'Boeing 737-700', 33.6, '2020-03-25', 149, 2, 'AMX');
INSERT INTO aviones VALUES ('AMX-002', 'Boeing 787-8 Dreamliner', 56.7, '2023-11-30', 242, 2, 'AMX');
INSERT INTO aviones VALUES ('GLO-001', 'Boeing 737 MAX 8', 39.5, '2022-09-15', 186, 2, 'GLO');
INSERT INTO aviones VALUES ('GLO-002', 'Boeing 737-800', 39.5, '2021-04-18', 160, 2, 'GLO');
INSERT INTO aviones VALUES ('ARG-001', 'Airbus A330-200', 58.8, '2020-02-10', 277, 2, 'ARG');
INSERT INTO aviones VALUES ('ARG-002', 'Boeing 737-800', 39.5, '2019-07-05', 160, 2, 'ARG');
INSERT INTO aviones VALUES ('BAW-001', 'Airbus A380-800', 72.7, '2018-11-20', 555, 4, 'BAW');
INSERT INTO aviones VALUES ('BAW-002', 'Boeing 777-300ER', 73.9, '2021-10-15', 386, 2, 'BAW');
INSERT INTO aviones VALUES ('AFR-001', 'Airbus A350-900', 66.9, '2019-06-25', 325, 2, 'AFR');
INSERT INTO aviones VALUES ('AFR-002', 'Boeing 737-800', 39.5, '2022-02-28', 160, 2, 'AFR');
INSERT INTO aviones VALUES ('DLH-001', 'Airbus A320neo', 37.6, '2021-07-08', 180, 2, 'DLH');
INSERT INTO aviones VALUES ('DLH-002', 'Boeing 747-8', 76.3, '2020-10-10', 467, 4, 'DLH');
INSERT INTO aviones VALUES ('AZA-001', 'Boeing 737 MAX 8', 39.5, '2019-11-15', 186, 2, 'AZA');
INSERT INTO aviones VALUES ('AZA-002', 'Airbus A321neo', 44.5, '2021-03-02', 240, 2, 'AZA');
INSERT INTO aviones VALUES ('IBE-001', 'Airbus A350-1000', 73.8, '2023-08-12', 370, 2, 'IBE');
INSERT INTO aviones VALUES ('IBE-002', 'Boeing 787-9 Dreamliner', 63.0, '2022-01-28', 290, 2, 'IBE');
INSERT INTO aviones VALUES ('AA-003', 'Boeing 737-700', 33.6, '2023-05-25', 149, 2, 'AAL');
INSERT INTO aviones VALUES ('AA-004', 'Boeing 787-10 Dreamliner', 68.3, '2021-09-20', 318, 2, 'AAL');
INSERT INTO aviones VALUES ('ACA-003', 'Airbus A319', 33.8, '2020-04-10', 124, 2, 'ACA');
INSERT INTO aviones VALUES ('ACA-004', 'Boeing 777-200LR', 64.8, '2019-08-15', 314, 2, 'ACA');
INSERT INTO aviones VALUES ('AMX-003', 'Boeing 737 MAX 9', 42.2, '2020-01-12', 192, 2, 'AMX');
INSERT INTO aviones VALUES ('AMX-004', 'Boeing 787-9 Dreamliner', 63.0, '2023-04-30', 290, 2, 'AMX');
INSERT INTO aviones VALUES ('GLO-003', 'Boeing 737-800', 39.5, '2021-11-22', 160, 2, 'GLO');
INSERT INTO aviones VALUES ('GLO-004', 'Boeing 737 MAX 8', 39.5, '2020-06-18', 186, 2, 'GLO');
INSERT INTO aviones VALUES ('ARG-003', 'Airbus A340-300', 63.7, '2019-03-12', 295, 4, 'ARG');
INSERT INTO aviones VALUES ('ARG-004', 'Boeing 737-800', 39.5, '2018-08-05', 160, 2, 'ARG');
INSERT INTO aviones VALUES ('BAW-003', 'Airbus A321neo', 44.5, '2020-02-20', 240, 2, 'BAW');
INSERT INTO aviones VALUES ('BAW-004', 'Boeing 777-200ER', 63.7, '2021-12-15', 280, 2, 'BAW');
INSERT INTO aviones VALUES ('AFR-003', 'Airbus A330-200', 58.8, '2018-09-25', 277, 2, 'AFR');
INSERT INTO aviones VALUES ('AFR-004', 'Boeing 737-700', 33.6, '2021-04-30', 149, 2, 'AFR');
INSERT INTO aviones VALUES ('DLH-003', 'Airbus A350-900', 66.9, '2021-07-08', 325, 2, 'DLH');
INSERT INTO aviones VALUES ('DLH-004', 'Boeing 747-400', 68.6, '2020-10-10', 416, 4, 'DLH');
INSERT INTO aviones VALUES ('AZA-003', 'Boeing 737-800', 39.5, '2019-11-15', 160, 2, 'AZA');
INSERT INTO aviones VALUES ('AZA-004', 'Airbus A320neo', 37.6, '2021-05-02', 180, 2, 'AZA');
INSERT INTO aviones VALUES ('IBE-003', 'Airbus A330-300', 63.7, '2023-02-12', 277, 2, 'IBE');
INSERT INTO aviones VALUES ('IBE-004', 'Boeing 787-8 Dreamliner', 56.7, '2022-06-28', 242, 2, 'IBE');

select * from asientos;
-- Inserciones para el avión AA-001
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'AA-001');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'AA-001');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'AA-001');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'AA-001');
INSERT INTO asientos VALUES ('F', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('F', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('G', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('G', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('H', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('H', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('I', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('I', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('J', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('J', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('K', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('K', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('L', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('L', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('M', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('M', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('N', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('N', '002', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('O', '001', 'Económico', 'AA-001');
INSERT INTO asientos VALUES ('O', '002', 'Económico', 'AA-001');

-- Inserciones para el avión AA-002
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'AA-002');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'AA-002');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'AA-002');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'AA-002');
INSERT INTO asientos VALUES ('F', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('F', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('G', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('G', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('H', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('H', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('I', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('I', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('J', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('J', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('K', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('K', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('L', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('L', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('M', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('M', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('N', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('N', '002', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('O', '001', 'Económico', 'AA-002');
INSERT INTO asientos VALUES ('O', '002', 'Económico', 'AA-002');
-- Inserciones para el avión AA-001
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'ACA-001');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'ACA-001');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'ACA-001');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'ACA-001');
INSERT INTO asientos VALUES ('F', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('F', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('G', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('G', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('H', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('H', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('I', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('I', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('J', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('J', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('K', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('K', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('L', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('L', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('M', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('M', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('N', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('N', '002', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('O', '001', 'Económico', 'ACA-001');
INSERT INTO asientos VALUES ('O', '002', 'Económico', 'ACA-001');

-- Inserciones para el avión ACA-002
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'ACA-002');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'ACA-002');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'ACA-002');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'ACA-002');
INSERT INTO asientos VALUES ('F', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('F', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('G', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('G', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('H', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('H', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('I', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('I', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('J', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('J', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('K', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('K', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('L', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('L', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('M', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('M', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('N', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('N', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('O', '001', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('O', '002', 'Económico', 'ACA-002');
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'AMX-001');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'AMX-001');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'AMX-001');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'AMX-001');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'AMX-001');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'AMX-001');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'AMX-001');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'AMX-001');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'AMX-001');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'AMX-001');
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'AMX-002');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'AMX-002');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'AMX-002');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'AMX-002');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'AMX-002');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'AMX-002');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'AMX-002');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'AMX-002');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'AMX-002');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'AMX-002');
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'GLO-001');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'GLO-001');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'GLO-001');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'GLO-001');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'GLO-001');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'GLO-001');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'GLO-001');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'GLO-001');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'GLO-001');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'GLO-001');
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'GLO-002');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'GLO-002');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'GLO-002');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'GLO-002');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'GLO-002');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'GLO-002');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'GLO-002');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'GLO-002');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'GLO-002');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'GLO-002');
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'ARG-001');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'ARG-001');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'ARG-001');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'ARG-001');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'ARG-001');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'ARG-001');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'ARG-001');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'ARG-001');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'ARG-001');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'ARG-001');
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'ARG-002');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'ARG-002');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'ARG-002');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'ARG-002');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'ARG-002');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'ARG-002');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'ARG-002');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'ARG-002');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'ARG-002');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'ARG-002');
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'BAW-001');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'BAW-001');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'BAW-001');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'BAW-001');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'BAW-001');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'BAW-001');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'BAW-001');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'BAW-001');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'BAW-001');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'BAW-001');
INSERT INTO asientos VALUES ('A', '001', 'Económico', 'BAW-002');
INSERT INTO asientos VALUES ('A', '002', 'Económico', 'BAW-002');
INSERT INTO asientos VALUES ('B', '001', 'Económico', 'BAW-002');
INSERT INTO asientos VALUES ('B', '002', 'Económico', 'BAW-002');
INSERT INTO asientos VALUES ('C', '001', 'Económico', 'BAW-002');
INSERT INTO asientos VALUES ('C', '002', 'Económico', 'BAW-002');
INSERT INTO asientos VALUES ('D', '001', 'Primera Clase', 'BAW-002');
INSERT INTO asientos VALUES ('D', '002', 'Primera Clase', 'BAW-002');
INSERT INTO asientos VALUES ('E', '001', 'Primera Clase', 'BAW-002');
INSERT INTO asientos VALUES ('E', '002', 'Primera Clase', 'BAW-002');

select  * from vuelos_salidas;
INSERT INTO vuelos_salidas VALUES
                               ('NYC001', 'programado', '2024-07-12 08:00:00', '2024-07-12 11:00:00', 'J1', 'T4', 'NYC', '09L/27R', 'AA-001'),
                               ('LAX002', 'retrasado', '2024-07-12 09:00:00', '2024-07-12 17:00:00', 'J2', 'T4', 'LAX', '18L/36R', 'AA-002'),
                               ('CHI003', 'cancelado', '2024-07-12 10:00:00', '2024-07-12 14:00:00', 'J3', 'T4', 'CHI', '10L/28R', 'ACA-001'),
                               ('TOR004', 'embarque', '2024-07-12 11:00:00', '2024-07-12 14:00:00', 'J1', 'T4', 'TOR', '11R/29L', 'ACA-002'),
                               ('VAN005', 'programado', '2024-07-12 12:00:00', '2024-07-12 20:00:00', 'J2', 'T4', 'VAN', '12L/30R', 'AMX-001'),
                               ('MTL006', 'retrasado', '2024-07-12 13:00:00', '2024-07-12 16:00:00', 'J3', 'T4', 'MTL', '13R/31L', 'AMX-002'),
                               ('MEX007', 'cancelado', '2024-07-12 14:00:00', '2024-07-12 22:00:00', 'J1', 'T4', 'MEX', '14L/32R', 'GLO-001'),
                               ('GDL008', 'embarque', '2024-07-12 15:00:00', '2024-07-12 23:00:00', 'J2', 'T4', 'GDL', '15R/33L', 'GLO-002'),
                               ('CUN009', 'programado', '2024-07-12 16:00:00', '2024-07-12 21:00:00', 'J3', 'T4', 'CUN', '16L/34R', 'ARG-001'),
                               ('RIO010', 'retrasado', '2024-07-12 17:00:00', '2024-07-13 02:00:00', 'J1', 'T4', 'RIO', '17R/35L', 'ARG-002'),
                               ('SAO011', 'cancelado', '2024-07-12 18:00:00', '2024-07-13 03:00:00', 'J2', 'T4', 'SAO', '09R/27L', 'BAW-001'),
                               ('BUE012', 'embarque', '2024-07-12 19:00:00', '2024-07-13 04:00:00', 'J3', 'T4', 'BUE', '18R/36L', 'BAW-002'),
                               ('LON013', 'programado', '2024-07-12 20:00:00', '2024-07-12 22:30:00', 'G1', 'T3', 'LON', '10R/28L', 'AFR-001'),
                               ('PAR014', 'retrasado', '2024-07-12 21:00:00', '2024-07-12 23:30:00', 'G2', 'T3', 'PAR', '11L/29R', 'AFR-002'),
                               ('BER015', 'cancelado', '2024-07-12 22:00:00', '2024-07-13 00:30:00', 'G3', 'T3', 'BER', '12R/30L', 'DLH-001'),
                               ('ROM016', 'embarque', '2024-07-12 23:00:00', '2024-07-13 01:30:00', 'H1', 'T3', 'ROM', '13L/31R', 'DLH-002'),
                               ('BCN017', 'programado', '2024-07-13 00:00:00', '2024-07-13 01:45:00', 'H2', 'T3', 'BCN', '14R/32L', 'AZA-001'),
                               ('MOS018', 'retrasado', '2024-07-13 01:00:00', '2024-07-13 05:00:00', 'H3', 'T3', 'MOS', '15L/33R', 'AZA-002'),
                               ('PEK019', 'cancelado', '2024-07-13 02:00:00', '2024-07-13 12:00:00', 'J1', 'T4', 'PEK', '16R/34L', 'IBE-001'),
                               ('TYO020', 'embarque', '2024-07-13 03:00:00', '2024-07-13 14:00:00', 'J2', 'T4', 'TYO', '17L/35R', 'IBE-002'),
                               ('SYD021', 'programado', '2024-07-13 04:00:00', '2024-07-13 17:00:00', 'J3', 'T4', 'SYD', '08L/26R', 'AA-003'),
                               ('DEL022', 'retrasado', '2024-07-13 05:00:00', '2024-07-13 13:00:00', 'J1', 'T4', 'DEL', '08R/26L', 'AA-004'),
                               ('JNB023', 'cancelado', '2024-07-13 06:00:00', '2024-07-13 16:00:00', 'J2', 'T4', 'JNB', '07L/25R', 'ACA-003'),
                               ('CAI024', 'embarque', '2024-07-13 07:00:00', '2024-07-13 12:00:00', 'J3', 'T4', 'CAI', '07R/25L', 'ACA-004'),
                               ('IST025', 'programado', '2024-07-13 08:00:00', '2024-07-13 13:00:00', 'J1', 'T4', 'IST', '06L/24R', 'AMX-003'),
                               ('RUH026', 'retrasado', '2024-07-13 09:00:00', '2024-07-13 14:00:00', 'J2', 'T4', 'RUH', '06R/24L', 'AMX-004'),
                               ('THR027', 'cancelado', '2024-07-13 10:00:00', '2024-07-13 16:00:00', 'J3', 'T4', 'THR', '05L/23R', 'GLO-003'),
                               ('NYC028', 'embarque', '2024-07-13 11:00:00', '2024-07-13 14:00:00', 'J1', 'T4', 'NYC', '05R/23L', 'GLO-004'),
                               ('LAX029', 'programado', '2024-07-13 12:00:00', '2024-07-13 20:00:00', 'J2', 'T4', 'LAX', '04L/22R', 'ARG-003'),
                               ('CHI030', 'retrasado', '2024-07-13 13:00:00', '2024-07-13 17:00:00', 'J3', 'T4', 'CHI', '04R/22L', 'ARG-004');
-- T1 y T2 para vuelos nacionales a Barcelona (BCN)
INSERT INTO vuelos_salidas VALUES
                               ('BCN002', 'retrasado', '2024-07-12 09:00:00', '2024-07-12 10:30:00', 'A2', 'T1', 'BCN', '18L/36R', 'AA-002'),
                               ('BCN003', 'cancelado', '2024-07-12 10:00:00', '2024-07-12 11:30:00', 'A3', 'T1', 'BCN', '10L/28R', 'ACA-001'),
                               ('BCN004', 'embarque', '2024-07-12 11:00:00', '2024-07-12 12:30:00', 'B1', 'T1', 'BCN', '11R/29L', 'ACA-002'),
                               ('BCN005', 'programado', '2024-07-12 12:00:00', '2024-07-12 13:30:00', 'B2', 'T1', 'BCN', '12L/30R', 'AMX-001'),
                               ('BCN006', 'retrasado', '2024-07-12 13:00:00', '2024-07-12 14:30:00', 'B3', 'T1', 'BCN', '13R/31L', 'AMX-002'),
                               ('BCN007', 'cancelado', '2024-07-12 14:00:00', '2024-07-12 15:30:00', 'C1', 'T1', 'BCN', '14L/32R', 'GLO-001'),
                               ('BCN008', 'embarque', '2024-07-12 15:00:00', '2024-07-12 16:30:00', 'C2', 'T1', 'BCN', '15R/33L', 'GLO-002'),
                               ('BCN009', 'programado', '2024-07-12 16:00:00', '2024-07-12 17:30:00', 'C3', 'T1', 'BCN', '16L/34R', 'ARG-001');

INSERT INTO personas (dni, nombre, apellido1, apellido2, gmail) VALUES
                                                                    ('12345678A', 'Juan', 'Perez', 'Lopez', 'juan.perez@gmail.com'),
                                                                    ('87654321B', 'Maria', 'Gomez', 'Martinez', 'maria.gomez@gmail.com'),
                                                                    ('11223344C', 'Carlos', 'Garcia', 'Fernandez', 'carlos.garcia@gmail.com'),
                                                                    ('44332211D', 'Ana', 'Lopez', 'Sanchez', 'ana.lopez@gmail.com'),
                                                                    ('55667788E', 'Luis', 'Martinez', 'Gomez', 'luis.martinez@gmail.com'),
                                                                    ('99887766F', 'Laura', 'Sanchez', 'Perez', 'laura.sanchez@gmail.com'),
                                                                    ('66554433G', 'Pedro', 'Fernandez', 'Garcia', 'pedro.fernandez@gmail.com'),
                                                                    ('33445566H', 'Carmen', 'Martinez', 'Lopez', 'carmen.martinez@gmail.com'),
                                                                    ('22334455I', 'Jose', 'Gomez', 'Fernandez', 'jose.gomez@gmail.com'),
                                                                    ('77889900J', 'Lucia', 'Perez', 'Sanchez', 'lucia.perez@gmail.com'),
                                                                    ('11122233K', 'Manuel', 'Diaz', 'Ruiz', 'manuel.diaz@gmail.com'),
                                                                    ('22233344L', 'Rosa', 'Alvarez', 'Torres', 'rosa.alvarez@gmail.com'),
                                                                    ('33344455M', 'Miguel', 'Romero', 'Ortega', 'miguel.romero@gmail.com'),
                                                                    ('44455566N', 'Sofia', 'Molina', 'Cruz', 'sofia.molina@gmail.com'),
                                                                    ('55566677O', 'Fernando', 'Herrera', 'Jimenez', 'fernando.herrera@gmail.com'),
                                                                    ('66677788P', 'Elena', 'Navarro', 'Flores', 'elena.navarro@gmail.com'),
                                                                    ('77788899Q', 'Jorge', 'Ramos', 'Castro', 'jorge.ramos@gmail.com'),
                                                                    ('88899900R', 'Adriana', 'Santos', 'Vega', 'adriana.santos@gmail.com'),
                                                                    ('99900011S', 'Alberto', 'Iglesias', 'Mendez', 'alberto.iglesias@gmail.com'),
                                                                    ('00011122T', 'Patricia', 'Silva', 'Romero', 'patricia.silva@gmail.com');

INSERT INTO clientes  VALUES
                                     ('12345678A', 'frecuente'),
                                     ('87654321B', 'ocasional'),
                                     ('11223344C', 'frecuente'),
                                     ('44332211D', 'ocasional'),
                                     ('55667788E', 'frecuente'),
                                     ('99887766F', 'ocasional'),
                                     ('66554433G', 'frecuente'),
                                     ('33445566H', 'ocasional'),
                                     ('22334455I', 'frecuente'),
                                     ('77889900J', 'ocasional');

INSERT INTO mantenimiento  VALUES
                                    ('11122233K'),
                                    ('22233344L'),
                                    ('33344455M'),
                                    ('44455566N'),
                                    ('55566677O'),
                                    ('66677788P'),
                                    ('77788899Q'),
                                    ('88899900R'),
                                    ('99900011S'),
                                    ('00011122T');

INSERT INTO seguridad  VALUES
                                      ('12345678A', 'guardia'),
                                      ('87654321B', 'supervisor'),
                                      ('11223344C', 'guardia'),
                                      ('44332211D', 'supervisor'),
                                      ('55667788E', 'guardia'),
                                      ('99887766F', 'supervisor'),
                                      ('66554433G', 'guardia'),
                                      ('33445566H', 'supervisor'),
                                      ('22334455I', 'guardia'),
                                      ('77889900J', 'supervisor');

INSERT INTO infraestructura  VALUES
                                      ('11122233K'),
                                      ('22233344L'),
                                      ('33344455M'),
                                      ('44455566N'),
                                      ('55566677O'),
                                      ('66677788P'),
                                      ('77788899Q'),
                                      ('88899900R'),
                                      ('99900011S'),
                                      ('00011122T');

INSERT INTO tripulacion  VALUES
                                  ('99900011S'),
                                  ('00011122T'),
                                  ('11122233K'),
                                  ('22233344L'),
                                  ('33344455M'),
                                  ('44455566N'),
                                  ('55566677O'),
                                  ('66677788P'),
                                  ('77788899Q'),
                                  ('88899900R');

INSERT INTO pilotos  VALUES
                              ('99900011S'),
                              ('00011122T'),
                              ('11122233K'),
                              ('22233344L'),
                              ('33344455M'),
                              ('44455566N'),
                              ('55566677O'),
                              ('66677788P'),
                              ('77788899Q'),
                              ('88899900R');

INSERT INTO copilotos  VALUES
                                ('99900011S'),
                                ('00011122T'),
                                ('11122233K'),
                                ('22233344L'),
                                ('33344455M'),
                                ('44455566N'),
                                ('55566677O'),
                                ('66677788P'),
                                ('77788899Q'),
                                ('88899900R');

INSERT INTO azafatas  VALUES
                               ('99900011S'),
                               ('00011122T'),
                               ('11122233K'),
                               ('22233344L'),
                               ('33344455M'),
                               ('44455566N'),
                               ('55566677O'),
                               ('66677788P'),
                               ('77788899Q'),
                               ('88899900R');

select * from personas;

INSERT INTO comercios (id, nombre, web, contacto, estado, nombre_terminales) VALUES
                                                                           (1,'Comercio T1-1', 'www.comerciot1-1.com', '912345678', 'abierto', 'T1'),
                                                                           (2,'Comercio T1-2', 'www.comerciot1-2.com', '912345679', 'cerrado', 'T1'),
                                                                           (3,'Comercio T2-1', 'www.comerciot2-1.com', '912345680', 'abierto', 'T2'),
                                                                           (4,'Comercio T2-2', 'www.comerciot2-2.com', '912345681', 'cerrado', 'T2'),
                                                                           (5,'Comercio T3-1', 'www.comerciot3-1.com', '912345682', 'abierto', 'T3'),
                                                                           (6,'Comercio T3-2', 'www.comerciot3-2.com', '912345683', 'cerrado', 'T3'),
                                                                           (7,'Comercio T4-1', 'www.comerciot4-1.com', '912345684', 'abierto', 'T4'),
                                                                           (8,'Comercio T4-2', 'www.comerciot4-2.com', '912345685', 'cerrado', 'T4'),
                                                                           (9,'Comercio T1-3', 'www.comerciot1-3.com', '912345686', 'abierto', 'T1'),
                                                                           (10,'Comercio T2-3', 'www.comerciot2-3.com', '912345687', 'cerrado', 'T2');

INSERT INTO salas_VIP (id, servicios, estado, nombre_terminales) VALUES
                                                      (1,'WiFi, Bebidas, Comida', 'abierto', 'T1'),
                                                      (2,'WiFi, Duchas, Bebidas', 'cerrado', 'T1'),
                                                      (3,'WiFi, Bebidas, Comida, Prensa', 'abierto', 'T2'),
                                                      (4,'WiFi, Duchas, Bebidas, TV', 'cerrado', 'T2'),
                                                      (5,'WiFi, Bebidas, Comida, Juegos', 'abierto', 'T3'),
                                                      (6,'WiFi, Duchas, Bebidas, Lectura', 'cerrado', 'T3'),
                                                      (7,'WiFi, Bebidas, Comida, Relax', 'abierto', 'T4'),
                                                      (8,'WiFi, Duchas, Bebidas, Spa', 'cerrado', 'T4'),
                                                      (9,'WiFi, Bebidas, Comida, Música', 'abierto', 'T1'),
                                                      (10,'WiFi, Duchas, Bebidas, Películas', 'cerrado', 'T2');


INSERT INTO aduanas (id, nombre, tipo, nombre_terminales) VALUES
                                                        (1,'Aduana T1-1', 'Control de Pasaportes', 'T1'),
                                                        (2,'Aduana T1-2', 'Control de Equipajes', 'T1'),
                                                        (3,'Aduana T2-1', 'Control de Pasaportes', 'T2'),
                                                        (4,'Aduana T2-2', 'Control de Equipajes', 'T2'),
                                                        (5,'Aduana T3-1', 'Control de Pasaportes', 'T3'),
                                                        (6,'Aduana T3-2', 'Control de Equipajes', 'T3'),
                                                        (7,'Aduana T4-1', 'Control de Pasaportes', 'T4'),
                                                        (8,'Aduana T4-2', 'Control de Equipajes', 'T4'),
                                                        (9,'Aduana T1-3', 'Control de Mercancías', 'T1'),
                                                        (10,'Aduana T2-3', 'Control de Mercancías', 'T2');

INSERT INTO check_in (id, estado, nombre_terminales) VALUES
                                                   (1,'abierto', 'T1'),
                                                   (2,'cerrado', 'T1'),
                                                   (3,'abierto', 'T2'),
                                                   (4,'cerrado', 'T2'),
                                                   (5,'abierto', 'T3'),
                                                   (6,'cerrado', 'T3'),
                                                   (7,'abierto', 'T4'),
                                                   (8,'cerrado', 'T4'),
                                                   (9,'abierto', 'T1'),
                                                   (10,'cerrado', 'T2'),
                                                   (11,'abierto', 'T3'),
                                                   (12,'cerrado', 'T4'),
                                                   (13,'abierto', 'T1'),
                                                   (14,'cerrado', 'T2'),
                                                   (15,'abierto', 'T3');

INSERT INTO trabajar_1  VALUES
                                                              ('11122233K', 1),
                                                              ('22233344L', 2),
                                                              ('33344455M', 3),
                                                              ('44455566N', 4),
                                                              ('55566677O', 5),
                                                              ('66677788P', 6),
                                                              ('77788899Q', 7),
                                                              ('88899900R', 8),
                                                              ('99900011S', 9),
                                                              ('00011122T', 10);

INSERT INTO trabajar_2  VALUES
                                                              ('11122233K', 1),
                                                              ('22233344L', 2),
                                                              ('33344455M', 3),
                                                              ('44455566N', 4),
                                                              ('55566677O', 5),
                                                              ('66677788P', 6),
                                                              ('77788899Q', 7),
                                                              ('88899900R', 8),
                                                              ('99900011S', 9),
                                                              ('00011122T', 10);

INSERT INTO trabajar_3  VALUES
                                                               ('11122233K', 1),
                                                               ('22233344L', 2),
                                                               ('33344455M', 3),
                                                               ('44455566N', 4),
                                                               ('55566677O', 5),
                                                               ('66677788P', 6),
                                                               ('77788899Q', 7),
                                                               ('88899900R', 8),
                                                               ('99900011S', 9),
                                                               ('00011122T', 10);

INSERT INTO trabajar_4  VALUES
                                                             ('11122233K', 1),
                                                             ('22233344L', 2),
                                                             ('33344455M', 3),
                                                             ('44455566N', 4),
                                                             ('55566677O', 1),
                                                             ('66677788P', 2),
                                                             ('77788899Q', 3),
                                                             ('88899900R', 4),
                                                             ('99900011S', 1),
                                                             ('00011122T', 2);

INSERT INTO trabajar_5  VALUES
                                                       ('12345678A', 1),
                                                       ('87654321B', 2),
                                                       ('11223344C', 3),
                                                       ('44332211D', 4),
                                                       ('55667788E', 5),
                                                       ('99887766F', 6),
                                                       ('66554433G', 7),
                                                       ('33445566H', 8),
                                                       ('22334455I', 9),
                                                       ('77889900J', 10);

INSERT INTO trabajar_6  VALUES
                                                             ('11122233K', '18L/36R'),
                                                             ('22233344L', '12L/30R'),
                                                             ('33344455M', '13R/31L'),
                                                             ('44455566N', '15R/33L'),
                                                             ('55566677O', '17R/35L'),
                                                             ('66677788P', '09R/27L'),
                                                             ('77788899Q', '18R/36L'),
                                                             ('88899900R', '12R/30L'),
                                                             ('99900011S', '14R/32L'),
                                                             ('00011122T', '16L/34R');

INSERT INTO reservas (id_reserva, fecha_r, dni_clientes, id_vuelos_salidas, fecha_vuelos_salidas, id_check_in) VALUES
                                                                              (1,'2024-07-10', '12345678A', 'NYC001', '2024-07-12 08:00:00', 1),
                                                                              (2,'2024-07-10', '87654321B', 'LAX002', '2024-07-12 09:00:00', 2),
                                                                              (3,'2024-07-10', '11223344C', 'CHI003', '2024-07-12 10:00:00', 3),
                                                                              (4,'2024-07-11', '44332211D', 'TOR004', '2024-07-12 11:00:00', 4),
                                                                              (5,'2024-07-11', '55667788E', 'VAN005', '2024-07-12 12:00:00', 5),
                                                                              (6,'2024-07-11', '99887766F', 'MTL006', '2024-07-12 13:00:00', 6),
                                                                              (7,'2024-07-12', '66554433G', 'MEX007', '2024-07-12 14:00:00', 7),
                                                                              (8,'2024-07-12', '33445566H', 'GDL008', '2024-07-12 15:00:00', 8),
                                                                              (9,'2024-07-12', '22334455I', 'CUN009', '2024-07-12 16:00:00', 9),
                                                                              (10,'2024-07-13', '77889900J', 'RIO010', '2024-07-12 17:00:00', 10),
                                                                              (11,'2024-07-13', '12345678A', 'SAO011', '2024-07-12 18:00:00', 11),
                                                                              (12,'2024-07-13', '87654321B', 'BUE012', '2024-07-12 19:00:00', 12),
                                                                              (13,'2024-07-14', '11223344C', 'LON013', '2024-07-12 20:00:00', 13),
                                                                              (14,'2024-07-14', '44332211D', 'PAR014', '2024-07-12 21:00:00', 14),
                                                                              (15,'2024-07-14', '55667788E', 'BER015', '2024-07-12 22:00:00', 15);

select * from asientos_vuelos;
insert into asientos_vuelos values ('A','001','AA-001','300','NYC001','2024-07-12 08:00:00',1,'2024-07-10','no disponible');
insert into asientos_vuelos values ('A','002','AA-001','300','NYC001','2024-07-12 08:00:00',null,null,'no disponible');
INSERT INTO asientos_vuelos VALUES ('B', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'no disponible');
INSERT INTO asientos_vuelos VALUES ('C', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'no disponible');
INSERT INTO asientos_vuelos VALUES ('F', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('G', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('H', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('I', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('J', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('K', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('L', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('M', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('N', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('O', '002', 'AA-001', 300, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');

-- Asientos de Primera Clase
INSERT INTO asientos_vuelos VALUES ('D', '002', 'AA-001', 700, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');
INSERT INTO asientos_vuelos VALUES ('E', '002', 'AA-001', 700, 'NYC001', '2024-07-12 08:00:00', null, null, 'disponible');


-- Asiento A001, Económico
INSERT INTO asientos_vuelos VALUES ('A', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', 2, '2024-07-10', 'disponible');

-- Asiento A002, Económico
INSERT INTO asientos_vuelos VALUES ('A', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento B001, Económico
INSERT INTO asientos_vuelos VALUES ('B', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento B002, Económico
INSERT INTO asientos_vuelos VALUES ('B', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento C001, Económico
INSERT INTO asientos_vuelos VALUES ('C', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento C002, Económico
INSERT INTO asientos_vuelos VALUES ('C', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento D001, Primera Clase
INSERT INTO asientos_vuelos VALUES ('D', '001', 'AA-002', 1200, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento D002, Primera Clase
INSERT INTO asientos_vuelos VALUES ('D', '002', 'AA-002', 1200, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento E001, Primera Clase
INSERT INTO asientos_vuelos VALUES ('E', '001', 'AA-002', 1200, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento E002, Primera Clase
INSERT INTO asientos_vuelos VALUES ('E', '002', 'AA-002', 1200, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento F001, Económico
INSERT INTO asientos_vuelos VALUES ('F', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento F002, Económico
INSERT INTO asientos_vuelos VALUES ('F', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento G001, Económico
INSERT INTO asientos_vuelos VALUES ('G', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento G002, Económico
INSERT INTO asientos_vuelos VALUES ('G', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento H001, Económico
INSERT INTO asientos_vuelos VALUES ('H', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento H002, Económico
INSERT INTO asientos_vuelos VALUES ('H', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento I001, Económico
INSERT INTO asientos_vuelos VALUES ('I', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento I002, Económico
INSERT INTO asientos_vuelos VALUES ('I', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento J001, Económico
INSERT INTO asientos_vuelos VALUES ('J', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento J002, Económico
INSERT INTO asientos_vuelos VALUES ('J', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento K001, Económico
INSERT INTO asientos_vuelos VALUES ('K', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento K002, Económico
INSERT INTO asientos_vuelos VALUES ('K', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento L001, Económico
INSERT INTO asientos_vuelos VALUES ('L', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento L002, Económico
INSERT INTO asientos_vuelos VALUES ('L', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento M001, Económico
INSERT INTO asientos_vuelos VALUES ('M', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'disponible');

-- Asiento M002, Económico
INSERT INTO asientos_vuelos VALUES ('M', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'no disponible');

-- Asiento N001, Económico
INSERT INTO asientos_vuelos VALUES ('N', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'no disponible');

-- Asiento N002, Económico
INSERT INTO asientos_vuelos VALUES ('N', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'no disponible');

-- Asiento O001, Económico
INSERT INTO asientos_vuelos VALUES ('O', '001', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'no disponible');

-- Asiento O002, Económico
INSERT INTO asientos_vuelos VALUES ('O', '002', 'AA-002', 700, 'LAX002', '2024-07-12 09:00:00', null, null, 'no disponible');

select  * from billetes;
insert into billetes values (1,'2024-7-10','NYC001','2024-07-12 08:00:00','12345678A',1,'2024-07-10','AA-001-NYC001-A-001');
insert into billetes values (2,'2024-7-12','NYC001','2024-07-12 08:00:00','87654321B',null,null,'AA-001-NYC001-A-002');
insert into billetes values (3,'2024-7-9','NYC001','2024-07-12 08:00:00','11223344C',null,null,'AA-001-NYC001-B-002');
insert into billetes values (4,'2024-7-8','NYC001','2024-07-12 08:00:00','44332211D',null,null,'AA-001-NYC001-C-002');
insert into billetes values (5,'2024-7-6','LAX002','2024-07-12 09:00:00','55667788E',2,'2024-07-10','AA-002-LAX002-M-002');
insert into billetes values (6,'2024-7-6','LAX002','2024-07-12 09:00:00','99887766F',NULL,NULL,'AA-002-LAX002-N-001');
insert into billetes values (7,'2024-7-8','LAX002','2024-07-12 09:00:00','66554433G',NULL,NULL,'AA-002-LAX002-N-002');
insert into billetes values (8,'2024-7-9','LAX002','2024-07-12 09:00:00','33445566H',NULL,NULL,'AA-002-LAX002-O-001');
insert into billetes values (9,'2024-7-9','LAX002','2024-07-12 09:00:00','22334455I',NULL,NULL,'AA-002-LAX002-O-002');

select * from equipaje;
INSERT INTO equipaje  VALUES ('AA-001-NYC001-A-001', 'Maleta', 23.5, '12345678A', 'NYC001', '2024-07-12 08:00:00');
INSERT INTO equipaje  VALUES ('AA-001-NYC001-A-002', 'Maleta', 20.0, '87654321B', 'NYC001', '2024-07-12 08:00:00');
INSERT INTO equipaje  VALUES ('AA-001-NYC001-B-002', 'Maleta', 22.0, '11223344C', 'NYC001', '2024-07-12 08:00:00');
INSERT INTO equipaje  VALUES ('AA-001-NYC001-C-002', 'Maleta', 18.0, '44332211D', 'NYC001', '2024-07-12 08:00:00');
INSERT INTO equipaje  VALUES ('AA-002-LAX002-M-002', 'Maleta', 24.0, '55667788E', 'LAX002', '2024-07-12 09:00:00');
INSERT INTO equipaje  VALUES ('AA-002-LAX002-N-001', 'Maleta', 19.0, '99887766F', 'LAX002', '2024-07-12 09:00:00');
INSERT INTO equipaje  VALUES ('AA-002-LAX002-N-002', 'Maleta', 21.0, '66554433G', 'LAX002', '2024-07-12 09:00:00');
INSERT INTO equipaje  VALUES ('AA-002-LAX002-O-001', 'Maleta', 23.0, '33445566H', 'LAX002', '2024-07-12 09:00:00');
INSERT INTO equipaje  VALUES ('AA-002-LAX002-O-002', 'Maleta', 22.5, '22334455I', 'LAX002', '2024-07-12 09:00:00');

select * from vuelos_llegadas;
INSERT INTO vuelos_llegadas  VALUES
                                                                                                                                             ('NYC001', '2024-07-11 10:00:00', '2024-07-12 08:00:00', 'programado', 'NYC', 'J1', 'T4', '09L/27R'),
                                                                                                                                             ('LAX002', '2024-07-11 20:00:00', '2024-07-12 09:00:00', 'programado', 'LAX', 'K1', 'T4', '18L/36R'),
                                                                                                                                             ('CHI003', '2024-07-10 15:00:00', '2024-07-11 13:00:00', 'retrasado', 'CHI', 'L1', 'T4', '10L/28R'),
                                                                                                                                             ('TOR004', '2024-07-10 12:00:00', '2024-07-11 10:00:00', 'cancelado', 'TOR', 'J2', 'T4', '11R/29L'),
                                                                                                                                             ('VAN005', '2024-07-09 09:00:00', '2024-07-10 08:00:00', 'programado', 'VAN', 'K2', 'T4', '12L/30R'),
                                                                                                                                             ('MTL006', '2024-07-11 14:00:00', '2024-07-12 12:00:00', 'embarque', 'MTL', 'L2', 'T4', '13R/31L'),
                                                                                                                                             ('MEX007', '2024-07-11 08:00:00', '2024-07-12 06:00:00', 'programado', 'MEX', 'J3', 'T4', '14L/32R'),
                                                                                                                                             ('GDL008', '2024-07-10 18:00:00', '2024-07-11 16:00:00', 'programado', 'GDL', 'K3', 'T4', '15R/33L'),
                                                                                                                                             ('CUN009', '2024-07-11 22:00:00', '2024-07-12 20:00:00', 'programado', 'CUN', 'L3', 'T4', '16L/34R'),
                                                                                                                                             ('RIO010', '2024-07-09 05:00:00', '2024-07-10 03:00:00', 'programado', 'RIO', 'J1', 'T4', '17R/35L'),
                                                                                                                                             ('SAO011', '2024-07-10 07:00:00', '2024-07-11 05:00:00', 'programado', 'SAO', 'K1', 'T4', '09R/27L'),
                                                                                                                                             ('BUE012', '2024-07-08 06:00:00', '2024-07-09 04:00:00', 'cancelado', 'BUE', 'L1', 'T4', '18R/36L'),
                                                                                                                                             ('LON013', '2024-07-09 19:00:00', '2024-07-10 17:00:00', 'programado', 'LON', 'G1', 'T3', '10R/28L'),
                                                                                                                                             ('PAR014', '2024-07-10 08:00:00', '2024-07-11 06:00:00', 'programado', 'PAR', 'G2', 'T3', '11L/29R'),
                                                                                                                                             ('BER015', '2024-07-11 09:00:00', '2024-07-12 07:00:00', 'retrasado', 'BER', 'G3', 'T3', '12R/30L'),
                                                                                                                                             ('ROM016', '2024-07-10 12:00:00', '2024-07-11 10:00:00', 'programado', 'ROM', 'H1', 'T3', '13L/31R'),
                                                                                                                                             ('BCN017', '2024-07-11 16:00:00', '2024-07-12 14:00:00', 'retrasado', 'BCN', 'H2', 'T3', '14R/32L'),
                                                                                                                                             ('MOS018', '2024-07-09 10:00:00', '2024-07-10 08:00:00', 'cancelado', 'MOS', 'H3', 'T3', '15L/33R'),
                                                                                                                                             ('PEK019', '2024-07-11 22:00:00', '2024-07-12 20:00:00', 'programado', 'PEK', 'J2', 'T4', '16R/34L'),
                                                                                                                                             ('TYO020', '2024-07-09 12:00:00', '2024-07-10 10:00:00', 'retrasado', 'TYO', 'J3', 'T4', '17L/35R'),
                                                                                                                                             ('SYD021', '2024-07-10 14:00:00', '2024-07-11 12:00:00', 'programado', 'SYD', 'K2', 'T4', '08L/26R'),
                                                                                                                                             ('DEL022', '2024-07-08 11:00:00', '2024-07-09 09:00:00', 'programado', 'DEL', 'K3', 'T4', '08R/26L'),
                                                                                                                                             ('JNB023', '2024-07-10 09:00:00', '2024-07-11 07:00:00', 'retrasado', 'JNB', 'L1', 'T4', '07L/25R'),
                                                                                                                                             ('CAI024', '2024-07-11 10:00:00', '2024-07-12 08:00:00', 'cancelado', 'CAI', 'L2', 'T4', '07R/25L');
select * from trabajar_7;
INSERT INTO trabajar_7  VALUES
                                                         ('99900011S', 'NYC001', '2024-07-12 08:00:00'),
                                                         ('00011122T', 'LAX002', '2024-07-12 09:00:00'),
                                                         ('11122233K', 'CHI003', '2024-07-12 10:00:00'),
                                                         ('22233344L', 'TOR004', '2024-07-12 11:00:00'),
                                                         ('33344455M', 'VAN005', '2024-07-12 12:00:00'),
                                                         ('44455566N', 'MTL006', '2024-07-12 13:00:00'),
                                                         ('55566677O', 'MEX007', '2024-07-12 14:00:00'),
                                                         ('66677788P', 'GDL008', '2024-07-12 15:00:00'),
                                                         ('77788899Q', 'CUN009', '2024-07-12 16:00:00'),
                                                         ('88899900R', 'RIO010', '2024-07-12 17:00:00');





select tripulacion.dni_personas,vuelos_salidas.id
from tripulacion tripulacion
join trabajar_7 trabajar_7 on(tripulacion.dni_personas=trabajar_7.dni_personas_tripulacion)
join vuelos_salidas vuelos_salidas on(trabajar_7.id_vuelos_salidas=vuelos_salidas.id);





