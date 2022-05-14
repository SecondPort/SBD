declare cm cursor for
select m.nro_alumno, a.nom_alumno, m.cod_carrera, c.nom_carrera, avg(e.nota_examen), count(e.nota_examen)
  from dbo.matriculas m
       join dbo.alumnos a
	     on m.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
       join dbo.examenes e
	     on m.nro_alumno = e.nro_alumno
		and m.cod_carrera = e.cod_carrera
 where m.ano_ingreso = 1995
 group by m.nro_alumno, a.nom_alumno, m.cod_carrera, c.nom_carrera
having avg(e.nota_examen) >= 7
   and count(e.nota_examen) > 3
order by nom_carrera, nom_alumno

declare @nro_alumno		integer,
        @cod_carrera	smallint,
        @nom_alumno		varchar(40), 
		@nom_carrera	varchar(40), 
		@promedio       decimal(4,2),
		@cant_rendidos	tinyint

declare @matriculas table
(
 nro_alumno		integer,
 nom_alumno		varchar(40), 
 cod_carrera	smallint,
 nom_carrera	varchar(40), 
 promedio       decimal(4,2),
 cant_rendidos	tinyint
)

----------------------------------------------------------------

open cm
fetch cm into @nro_alumno, @nom_alumno, @cod_carrera, @nom_carrera, @promedio, @cant_rendidos
while @@fetch_status = 0
begin
   -- PROCESAR REGISTRO DEL CURSOR
   insert into @matriculas (nro_alumno, cod_carrera, nom_alumno, nom_carrera, promedio, cant_rendidos)
   select @nro_alumno, @cod_carrera, @nom_alumno, @nom_carrera, @promedio, @cant_rendidos

   fetch cm into @nro_alumno, @nom_alumno, @cod_carrera, @nom_carrera, @promedio, @cant_rendidos
end
--close cm
deallocate cm

select * 
  from @matriculas
----------------------------------------------------------------




declare cm cursor for
select m.nro_alumno, a.nom_alumno, m.cod_carrera, c.nom_carrera
  from dbo.matriculas m
       join dbo.alumnos a
	     on m.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
 where m.ano_ingreso = 1995
order by nom_carrera, nom_alumno

declare @nro_alumno		integer,
        @cod_carrera	smallint,
        @nom_alumno		varchar(40), 
		@nom_carrera	varchar(40), 
		@promedio       decimal(4,2),
		@cant_rendidos	tinyint,
		@nota_examen	tinyint,
		@suma_notas		smallint

declare @matriculas table
(
 nro_alumno		integer,
 nom_alumno		varchar(40), 
 cod_carrera	smallint,
 nom_carrera	varchar(40), 
 promedio       decimal(4,2),
 cant_rendidos	tinyint
)

----------------------------------------------------------------

open cm
fetch cm into @nro_alumno, @nom_alumno, @cod_carrera, @nom_carrera
while @@fetch_status = 0
begin
   -- PROCESAR MATRICULA
   select @promedio      = 0.00,
          @cant_rendidos = 0,
		  @suma_notas    = 0

   declare ce cursor for
   select e.nota_examen
     from dbo.examenes e
    where e.nro_alumno = @nro_alumno
	  and e.cod_carrera = @cod_carrera

   open ce
   fetch ce into @nota_examen
   while @@FETCH_STATUS = 0
   begin
      -- PROCESAR EXAMEN
	  if @nota_examen is not null
	     begin
	        set @suma_notas = @suma_notas + @nota_examen
		    set @cant_rendidos = @cant_rendidos + 1
		 end

      fetch ce into @nota_examen
   end
   deallocate ce

   if @cant_rendidos > 0 
      begin
	     set @promedio = @suma_notas / @cant_rendidos
   	  end 

   if @promedio >= 7 and @cant_rendidos > 3
      begin
         insert into @matriculas (nro_alumno, cod_carrera, nom_alumno, nom_carrera, promedio, cant_rendidos)
         select @nro_alumno, @cod_carrera, @nom_alumno, @nom_carrera, @promedio, @cant_rendidos
      end

   fetch cm into @nro_alumno, @nom_alumno, @cod_carrera, @nom_carrera
end
--close cm
deallocate cm

select * 
  from @matriculas
----------------------------------------------------------------
