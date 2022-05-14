alter table carreras add
 nota_minima	tinyint		not null constraint DF__carreras__nota_minima__0__END  default 0,
 nota_maxima	tinyint		not null constraint DF__carreras__nota_maxima__10__END default 10
go

alter table carreras add
constraint CK__carreras__rango_notas__END check (nota_minima < nota_maxima)
go

alter table carreras drop constraint CK__carreras__nota_a__13BCEBC1
go

alter table carreras add
constraint CK__carreras__nota_aprob_examen_final__END check (nota_aprob_examen_final between nota_minima+1 and nota_maxima-1)
go

-- REGLA DE INTEGRIDAD: las notas de exámenes deben estar dentro del rango de la carrera
-----------------------------------------------------------------------------------------------------
-- 1. Determinar filas que no cumplen con la regla de integridad
-----------------------------------------------------------------------------------------------------
select *
  from dbo.examenes e
       join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera
 where e.nota_examen NOT BETWEEN c.nota_minima and c.nota_maxima

-----------------------------------------------------------------------------------------------------
-- 2. Determinar qué triggers tengo que programar
-----------------------------------------------------------------------------------------------------
tabla - operacion - el momento			cantidad de veces
tabla1  insert		antes o después		1 sola vez - 1 vez por fila actualizada
tabla1	delete		antes o después		1 sola vez - 1 vez por fila actualizada
tabla1	update		antes o después		1 sola vez - 1 vez por fila actualizada

-------------------------------------------------------------------------------------------------------------------
-- tabla						insert						delete					update
-------------------------------------------------------------------------------------------------------------------
-- carreras						NO							NO						SI (nota_minima o nota_maxima)
-------------------------------------------------------------------------------------------------------------------
-- examenes						SI							NO						SI (nota_examen, cod_carrera)
-------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-- 3. Programar los triggers
-----------------------------------------------------------------------------------------------------
CREATE TRIGGER dbo.ti_ri_examenes
ON dbo.examenes
FOR insert
AS
BEGIN
   IF EXISTS (select *
                from inserted e
                     join dbo.carreras c
	                   on e.cod_carrera = c.cod_carrera
               where e.nota_examen NOT BETWEEN c.nota_minima and c.nota_maxima)
      BEGIN
         RAISERROR('La nota no está en el rango esperado', 16, 1)
		 ROLLBACK
		 RETURN
	  END

END
GO

CREATE TRIGGER dbo.tu_ri_examenes
ON dbo.examenes
FOR update
AS
BEGIN
   IF EXISTS (select *
                from inserted e
                     join dbo.carreras c
	                   on e.cod_carrera = c.cod_carrera
               where e.nota_examen NOT BETWEEN c.nota_minima and c.nota_maxima)
      BEGIN
         RAISERROR('La nota no está en el rango esperado', 16, 1)
		 ROLLBACK
		 RETURN
	  END

END
GO

CREATE TRIGGER dbo.tu_ri_carreras
ON dbo.carreras
FOR update
AS
BEGIN
   IF EXISTS (select *
                from examenes e
                     join inserted c
	                   on e.cod_carrera = c.cod_carrera
               where e.nota_examen NOT BETWEEN c.nota_minima and c.nota_maxima)
      BEGIN
         RAISERROR('La nota no está en el rango esperado', 16, 1)
		 ROLLBACK
		 RETURN
	  END

END
GO

-----------------------------------------------------------------------------------------------------
-- 4. Programar la adecuación de los datos a la nueva regla de integridad
-----------------------------------------------------------------------------------------------------
update e
   set nota_examen = case when e.nota_examen < c.nota_minima then c.nota_minima 
                          when e.nota_examen > c.nota_maxima then c.nota_maxima
					 end
--select *
  from dbo.examenes e
       join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera
 where e.nota_examen NOT BETWEEN c.nota_minima and c.nota_maxima

-----------------------------------------------------------------------------------------------------
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,5,'12 jun 2010 0:00',2,9,11)



