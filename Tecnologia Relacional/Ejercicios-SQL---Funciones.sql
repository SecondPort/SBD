drop table examenes
drop table cursados
drop table matriculas
drop table alumnos
drop table materias
drop table carreras
go

create table carreras
(
 cod_carrera		smallint		not null,
 nom_carrera		varchar(100)	not null,
 nota_aprobacion	tinyint			not null,
 cant_max_aplazos	tinyint			not null,
 años_regularidad	tinyint			not null,
 duracion_carrera	tinyint			not null,
 primary key (cod_carrera)
)
go

create table materias
(
 cod_carrera		smallint		not null,
 cod_materia		char(4)			not null,
 nom_materia		varchar(100)	not null,
 año_materia		smallint		not null,
 obligatoria		char(1)			not null,
 trabajo_final		char(1)			not null,
 primary key (cod_carrera, cod_materia),
 foreign key (cod_carrera) references carreras,
 check (obligatoria in ('S','N')),
 check (trabajo_final in ('S','N'))
)
go

create table alumnos 
(
 nro_alumno			integer			not null,
 nom_alumno			varchar(40)		not null,
 tipo_doc_alumno	varchar(3)		not null,
 nro_doc_alumno		integer			not null,
 primary key (nro_alumno)
)
go

create table matriculas
(
 nro_alumno			integer			not null, 
 cod_carrera		smallint		not null,
 año_ingreso		smallint		not null,
 primary key (nro_alumno, cod_carrera),
 foreign key (nro_alumno) references alumnos,
 foreign key (cod_carrera) references carreras
)
go

create table cursados
(
 cod_carrera		smallint		not null,
 cod_materia		char(4)			not null,
 año_cursado		smallint		not null,
 nro_alumno			integer			not null,
 regular			char(1)			not null,
 primary key (cod_carrera, cod_materia, año_cursado, nro_alumno),
 foreign key (nro_alumno, cod_carrera) references matriculas,
 foreign key (cod_carrera, cod_materia) references materias, 
 check (regular in ('S','N'))
)
go

create table examenes
(
 fecha_examen		smalldatetime	not null,
 cod_carrera		smallint		not null,
 cod_materia		char(4)			not null,
 año_cursado		smallint		not null,
 nro_alumno			integer			not null,
 nro_libro			smallint		not null,
 nro_acta			smallint		not null,
 nota_examen		tinyint			null,
 primary key (nro_alumno, cod_carrera, cod_materia, fecha_examen),
 foreign key (cod_carrera, cod_materia, año_cursado, nro_alumno) references cursados
)
go


-- CARRERAS

insert into carreras
values (1,'CARRERA 1',4,3,2,4)
insert into carreras
values (2,'CARRERA 2',5,2,3,5)
insert into carreras
values (3,'CARRERA 3',4,3,2,6)
insert into carreras
values (4,'CARRERA 4',5,2,3,4)
insert into carreras
values (5,'CARRERA 5',4,3,2,5)
go

-- MATERIAS

insert into materias
values (1,'0101','MATERIA 1-0101',1,'S','N')
insert into materias
values (1,'0102','MATERIA 1-0102',1,'S','N')
insert into materias
values (1,'0201','MATERIA 1-0201',2,'S','N')
insert into materias
values (1,'0202','MATERIA 1-0202',2,'N','N')
insert into materias
values (1,'0301','MATERIA 1-0301',3,'S','N')
insert into materias
values (1,'0302','MATERIA 1-0302',3,'S','N')
insert into materias
values (1,'0401','MATERIA 1-0401',4,'S','N')
insert into materias
values (1,'0402','MATERIA 1-0402',4,'S','S')
go

insert into materias
values (2,'0101','MATERIA 2-0101',1,'S','N')
insert into materias
values (2,'0102','MATERIA 2-0102',1,'S','N')
insert into materias
values (2,'0201','MATERIA 2-0201',2,'S','N')
insert into materias
values (2,'0202','MATERIA 2-0202',2,'N','N')
insert into materias
values (2,'0301','MATERIA 2-0301',3,'S','N')
insert into materias
values (2,'0302','MATERIA 2-0302',3,'S','N')
insert into materias
values (2,'0401','MATERIA 2-0401',4,'S','N')
insert into materias
values (2,'0402','MATERIA 2-0402',4,'S','N')
insert into materias
values (2,'0403','MATERIA 2-0403',4,'S','N')
insert into materias
values (2,'0404','MATERIA 2-0404',4,'S','N')
insert into materias
values (2,'0501','MATERIA 2-0501',5,'N','N')
insert into materias
values (2,'0502','MATERIA 2-0502',5,'S','N')
insert into materias
values (2,'0503','MATERIA 2-0503',5,'N','N')
insert into materias
values (2,'0504','MATERIA 2-0504',5,'S','N')
go

insert into materias
values (3,'0101','MATERIA 3-0101',1,'S','N')
insert into materias
values (3,'0102','MATERIA 3-0102',1,'S','N')
insert into materias
values (3,'0201','MATERIA 3-0201',2,'S','N')
insert into materias
values (3,'0202','MATERIA 3-0202',2,'N','N')
insert into materias
values (3,'0301','MATERIA 3-0301',3,'S','N')
insert into materias
values (3,'0302','MATERIA 3-0302',3,'S','N')
insert into materias
values (3,'0401','MATERIA 3-0401',4,'S','N')
insert into materias
values (3,'0402','MATERIA 3-0402',4,'S','N')
insert into materias
values (3,'0501','MATERIA 3-0501',5,'S','N')
insert into materias
values (3,'0502','MATERIA 3-0502',5,'S','N')
insert into materias
values (3,'0601','MATERIA 3-0601',6,'N','N')
insert into materias
values (3,'0602','MATERIA 3-0602',6,'S','N')
go

insert into materias
values (4,'0101','MATERIA 4-0101',1,'S','N')
insert into materias
values (4,'0102','MATERIA 4-0102',1,'S','N')
insert into materias
values (4,'0201','MATERIA 4-0201',2,'S','N')
insert into materias
values (4,'0202','MATERIA 4-0202',2,'N','N')
insert into materias
values (4,'0301','MATERIA 4-0301',3,'S','N')
insert into materias
values (4,'0302','MATERIA 4-0302',3,'S','N')
insert into materias
values (4,'0401','MATERIA 4-0401',4,'S','N')
insert into materias
values (4,'0402','MATERIA 4-0402',4,'S','S')
insert into materias
values (4,'0403','MATERIA 2-0403',4,'S','N')
insert into materias
values (4,'0404','MATERIA 2-0404',4,'S','S')
insert into materias
values (4,'0405','MATERIA 2-0405',5,'S','N')
insert into materias
values (4,'0406','MATERIA 2-0406',5,'S','S')
go

insert into materias
values (5,'0101','MATERIA 5-0101',1,'S','N')
insert into materias
values (5,'0102','MATERIA 5-0102',1,'S','N')
insert into materias
values (5,'0201','MATERIA 5-0201',2,'S','N')
insert into materias
values (5,'0202','MATERIA 5-0202',2,'N','N')
insert into materias
values (5,'0301','MATERIA 5-0301',3,'S','N')
insert into materias
values (5,'0302','MATERIA 5-0302',3,'S','N')
insert into materias
values (5,'0401','MATERIA 5-0401',4,'S','N')
insert into materias
values (5,'0402','MATERIA 5-0402',4,'S','N')
insert into materias
values (5,'0501','MATERIA 5-0501',5,'N','N')
insert into materias
values (5,'0502','MATERIA 5-0502',5,'S','N')
go

-- ALUMNOS

insert into alumnos
values (1,'ALUMNO 1','DNI',1)
insert into alumnos
values (2,'ALUMNO 2','DNI',2)
insert into alumnos
values (3,'ALUMNO 3','DNI',3)
insert into alumnos
values (4,'ALUMNO 4','DNI',4)
insert into alumnos
values (5,'ALUMNO 5','DNI',5)
insert into alumnos
values (6,'ALUMNO 6','DNI',6)
insert into alumnos
values (7,'ALUMNO 7','DNI',7)
insert into alumnos
values (8,'ALUMNO 8','DNI',8)
insert into alumnos
values (9,'ALUMNO 9','DNI',9)
insert into alumnos
values (10,'ALUMNO 10','DNI',10)
go

-- MATRICULAS

insert into matriculas
values (1,1,1996)
insert into matriculas
values (2,1,1998)
insert into matriculas
values (3,2,1995)
insert into matriculas
values (4,2,1997)
insert into matriculas
values (5,3,1999)
insert into matriculas
values (6,3,1996)
insert into matriculas
values (7,4,2000)
insert into matriculas
values (8,4,1998)
insert into matriculas
values (9,5,2000)
insert into matriculas
values (10,5,2001)
go

-- CURSADOS

insert into cursados
values (1,'0101',1996,1,'S')
insert into cursados
values (1,'0102',1996,1,'S')
insert into cursados
values (1,'0201',1997,1,'S')
insert into cursados
values (1,'0301',1998,1,'S')
insert into cursados
values (1,'0302',1998,1,'S')
insert into cursados
values (1,'0401',1999,1,'S')
go

insert into cursados
values (1,'0101',1998,2,'S')
insert into cursados
values (1,'0102',1998,2,'N')
insert into cursados
values (1,'0102',1999,2,'S')
insert into cursados
values (1,'0201',1999,2,'S')
insert into cursados
values (1,'0301',2000,2,'S')
insert into cursados
values (1,'0302',2000,2,'S')
insert into cursados
values (1,'0401',2001,2,'S')
go

insert into cursados
values (2,'0101',1995,3,'S')
insert into cursados
values (2,'0102',1995,3,'S')
insert into cursados
values (2,'0201',1996,3,'S')
insert into cursados
values (2,'0202',1996,3,'S')
go

insert into cursados
values (2,'0101',1997,4,'S')
insert into cursados
values (2,'0102',1997,4,'S')
insert into cursados
values (2,'0201',1998,4,'S')
insert into cursados
values (2,'0202',1998,4,'S')
insert into cursados
values (2,'0301',1999,4,'S')
insert into cursados
values (2,'0302',1999,4,'S')
insert into cursados
values (2,'0403',2000,4,'S')
insert into cursados
values (2,'0404',2000,4,'N')
insert into cursados
values (2,'0404',2001,4,'S')
insert into cursados
values (2,'0503',2001,4,'S')
go

insert into cursados
values (3,'0101',1999,5,'S')
insert into cursados
values (3,'0102',1999,5,'S')
insert into cursados
values (3,'0201',2000,5,'S')
insert into cursados
values (3,'0202',2000,5,'S')
insert into cursados
values (3,'0301',2001,5,'S')
insert into cursados
values (3,'0302',2001,5,'S')
go

insert into cursados
values (3,'0101',1996,6,'S')
insert into cursados
values (3,'0102',1997,6,'S')
insert into cursados
values (3,'0201',1998,6,'S')
insert into cursados
values (3,'0202',1999,6,'S')
insert into cursados
values (3,'0301',2000,6,'S')
insert into cursados
values (3,'0302',2001,6,'S')
go

insert into cursados
values (4,'0101',2000,7,'S')
insert into cursados
values (4,'0102',2000,7,'S')
insert into cursados
values (4,'0201',2001,7,'S')
insert into cursados
values (4,'0202',2001,7,'S')
go

insert into cursados
values (4,'0101',1998,8,'S')
insert into cursados
values (4,'0102',1998,8,'S')
insert into cursados
values (4,'0201',1999,8,'S')
insert into cursados
values (4,'0301',2000,8,'S')
insert into cursados
values (4,'0302',2000,8,'S')
insert into cursados
values (4,'0405',2001,8,'S')
go

insert into cursados
values (5,'0101',2000,9,'S')
insert into cursados
values (5,'0102',2000,9,'S')
insert into cursados
values (5,'0201',2001,9,'S')
go

insert into cursados
values (5,'0101',2001,10,'N')
insert into cursados
values (5,'0102',2001,10,'N')
go

-- EXAMENES

insert into examenes
values ('20 dec 1996 0:00',1,'0101',1996,1,1,1,5)
insert into examenes
values ('27 dec 1996 0:00',1,'0102',1996,1,1,2,4)
insert into examenes
values ('15 dec 1997 0:00',1,'0201',1997,1,2,1,3)
insert into examenes
values ('15 feb 1998 0:00',1,'0201',1997,1,2,2,7)
insert into examenes
values ('17 dec 1998 0:00',1,'0301',1998,1,3,1,6)
insert into examenes
values ('28 dec 1998 0:00',1,'0302',1998,1,3,2,8)
insert into examenes
values ('18 nov 1999 0:00',1,'0401',1999,1,4,2,2)
insert into examenes
values ('10 dec 1999 0:00',1,'0401',1999,1,4,1,null)
go

insert into examenes
values ('20 dec 1998 0:00',1,'0101',1998,2,1,1,5)
insert into examenes
values ('07 dec 1999 0:00',1,'0102',1999,2,1,2,4)
insert into examenes
values ('15 dec 1999 0:00',1,'0201',1999,2,2,1,3)
insert into examenes
values ('15 feb 2000 0:00',1,'0201',1999,2,2,2,7)
insert into examenes
values ('17 dec 2000 0:00',1,'0301',2000,2,3,1,null)
insert into examenes
values ('28 dec 2000 0:00',1,'0302',2000,2,3,2,3)
go

insert into examenes
values ('20 dec 1995 0:00',2,'0101',1995,3,1,1,4)
insert into examenes
values ('29 dec 1995 0:00',2,'0102',1995,3,1,2,2)
insert into examenes
values ('20 feb 1996 0:00',2,'0102',1995,3,1,3,1)
go

insert into examenes
values ('02 dec 1997 0:00',2,'0101',1997,4,1,1,5)
insert into examenes
values ('02 feb 1998 0:00',2,'0101',1997,4,1,3,null)
insert into examenes
values ('10 dec 1997 0:00',2,'0102',1997,4,1,2,7)
insert into examenes
values ('12 dec 1998 0:00',2,'0201',1998,4,1,1,8)
insert into examenes
values ('22 dec 1998 0:00',2,'0202',1998,4,1,2,9)
insert into examenes
values ('04 dec 1999 0:00',2,'0301',1999,4,1,1,10)
insert into examenes
values ('05 dec 1999 0:00',2,'0302',1999,4,1,2,7)
insert into examenes
values ('11 dec 2000 0:00',2,'0403',2000,4,1,1,8)
insert into examenes
values ('12 dec 2001 0:00',2,'0404',2000,4,1,1,3)
insert into examenes
values ('18 dec 2001 0:00',2,'0404',2000,4,1,3,8)
go

insert into examenes
values ('13 dec 1999 0:00',3,'0101',1999,5,1,1,5)
insert into examenes
values ('16 dec 1999 0:00',3,'0102',1999,5,1,2,7)
insert into examenes
values ('11 dec 2000 0:00',3,'0201',2000,5,1,1,8)
insert into examenes
values ('22 dec 2000 0:00',3,'0202',2000,5,1,2,10)
insert into examenes
values ('12 dec 2001 0:00',3,'0301',2001,5,1,1,9)
insert into examenes
values ('23 dec 2001 0:00',3,'0302',2001,5,1,2,10)
go

insert into examenes
values ('10 dec 1996 0:00',3,'0101',1996,6,1,1,6)
insert into examenes
values ('11 dec 1997 0:00',3,'0102',1997,6,1,1,7)
insert into examenes
values ('13 dec 1998 0:00',3,'0201',1998,6,1,1,8)
insert into examenes
values ('12 dec 1999 0:00',3,'0202',1999,6,1,1,2)
insert into examenes
values ('13 dec 2000 0:00',3,'0301',2000,6,1,1,1)
insert into examenes
values ('13 feb 2001 0:00',3,'0301',2000,6,1,1,2)
insert into examenes
values ('13 jul 2001 0:00',3,'0301',2000,6,1,1,2)
insert into examenes
values ('12 dec 2001 0:00',3,'0302',2001,6,1,1,7)
go

insert into examenes
values ('15 dec 2000 0:00',4,'0101',2000,7,1,1,7)
insert into examenes
values ('20 dec 2000 0:00',4,'0102',2000,7,1,2,6)
insert into examenes
values ('13 dec 2001 0:00',4,'0201',2001,7,1,1,6)
insert into examenes
values ('19 dec 2001 0:00',4,'0202',2001,7,1,2,7)
go

insert into examenes
values ('10 dec 1998 0:00',4,'0101',1998,8,1,1,6)
insert into examenes
values ('12 dec 1998 0:00',4,'0102',1998,8,1,2,10)
insert into examenes
values ('13 dec 1999 0:00',4,'0201',1999,8,1,1,10)
insert into examenes
values ('14 dec 2000 0:00',4,'0301',2000,8,1,1,9)
insert into examenes
values ('21 dec 2000 0:00',4,'0302',2000,8,1,2,7)
insert into examenes
values ('12 dec 2001 0:00',4,'0405',2001,8,1,1,1)
insert into examenes
values ('22 dec 2001 0:00',4,'0405',2001,8,1,2,8)
go

insert into examenes
values ('15 dec 2000 0:00',5,'0101',2000,9,1,1,10)
insert into examenes
values ('27 dec 2000 0:00',5,'0102',2000,9,1,2,9)
insert into examenes
values ('12 dec 2001 0:00',5,'0201',2001,9,1,1,8)
go

/*

1. Programar una función que devuelva la cantidad de aplazos de un alumno en una materia.

2. Programar una función que devuelva el año de vencimiento de la regularidad de una materia para un alumno determinado. 
   Esto se calcula sumando la cantidad de años que dura la regularidad (años_regularidad en tabla carreras) al año de cursado

3. Mostrar la lista de materias de la carrera 'CARRERA 1' con la cantidad de alumnos que hayan cursado cada una de ellas 
   durante el año 2000.

4. Programar una consulta (que utilice las funciones solicitadas) muestre los alumnos que pueden rendir la materia '0102'
   de la carrera 'CARRERA 1'
   
   Un alumno puede rendir una materia si:
   1. Está regular en la misma, lo que implica:
      a. Tiene un registro en cursado con regular = 'S'
      b. Para ese registro tiene menos aplazos que la cantidad máxima definida para la carrera
      c. Esa regularidad no está vencida (el año de cursado + años de regularidad definidos para la carrera es mayor al año actual)
   2. La materia no está aprobada

*/
