/*Se tienen las siguientes relaciones:
 
 ALUMNOS (nro_alumno, nom_alumno, nro_doc_alumno)
 
 CARRERAS (cod_carrera, nom_carrera, nota_aprob_examen_final)
 
 MATERIAS (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
 
 MATRICULAS (nro_alumno, cod_carrera, ano_ingreso)
 
 EXAMENES (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)*/
CREATE TABLE ALUMNOS (
	nro_alumno INTEGER NOT NULL,
	nom_alumno VARCHAR(50) NOT NULL,
	nro_doc_alumno INTEGER NOT NULL,
	PRIMARY KEY (nro_alumno)
);
CREATE TABLE CARRERAS (
	cod_carrera INTEGER NOT NULL,
	nom_carrera VARCHAR(50) NOT NULL,
	nota_aprob_examen_final INTEGER NOT NULL,
	PRIMARY KEY (cod_carrera)
);
CREATE TABLE MATERIAS (
	cod_carrera INTEGER NOT NULL,
	cod_materia INTEGER NOT NULL,
	nom_materia VARCHAR(50) NOT NULL,
	cuat_materia INTEGER NOT NULL,
	optativa BOOLEAN NOT NULL,
	PRIMARY KEY (cod_carrera, cod_materia),
	FOREIGN KEY (cod_carrera) REFERENCES CARRERAS(cod_carrera)
);
CREATE TABLE MATRICULAS (
	nro_alumno INTEGER NOT NULL,
	cod_carrera INTEGER NOT NULL,
	ano_ingreso INTEGER NOT NULL,
	PRIMARY KEY (nro_alumno, cod_carrera),
	FOREIGN KEY (nro_alumno) REFERENCES ALUMNOS(nro_alumno),
	FOREIGN KEY (cod_carrera) REFERENCES CARRERAS(cod_carrera)
);
CREATE TABLE EXAMENES (
	nro_alumno INTEGER NOT NULL,
	cod_carrera INTEGER NOT NULL,
	cod_materia INTEGER NOT NULL,
	fecha_examen DATE NOT NULL,
	nro_libro INTEGER NOT NULL,
	nro_acta INTEGER NOT NULL,
	nota_examen INTEGER NOT NULL,
	PRIMARY KEY (nro_alumno, cod_carrera, cod_matereria),
	FOREIGN KEY (nro_alumno, cod_carrera) REFERENCES MATRICULAS(nro_alumno, cod_carrera),
	FOREIGN KEY (cod_carrera, cod_materia) REFERENCES MATERIAS(cod_carrera, cod_materia)
);
/* 2.	Programar las siguientes consultas:
Mostrar nro_alumno, nom_alumno, cod_carrera, nom_carrera y promedio de los alumnos que ingresaron en 1995 y tienen promedio >= 7 y han rendido más de 20 exámenes finales (no considerar los ausentes)*/
SELECT A.nro_alumno,
	A.nom_alumno,
	C.cod_carrera,
	C.nom_carrera,
	AVG(E.nota_examen)
FROM ALUMNOS A
	JOIN MATRICULAS M ON A.nro_alumno = M.nro_alumno
	JOIN CARRERAS C ON M.cod_carrera = C.cod_carrera
	JOIN EXAMENES E ON M.nro_alumno = E.nro_alumno
	AND M.cod_carrera = E.cod_carrera
WHERE M.ano_ingreso = 1995
	AND E.nota_examen >= 7
	AND COUNT(E.nota_examen) > 20
GROUP BY A.nro_alumno,
	A.nom_alumno,
	C.cod_carrera,
	C.nom_carrera;
/*Cantidad de materias aprobadas por el alumno 'SANCHEZ' en la carrera 'CONTADOR PUBLICO'*/
SELECT COUNT(E.nota_examen)
FROM ALUMNOS A
	JOIN MATRICULAS M ON A.nro_alumno = M.nro_alumno
	JOIN CARRERAS C ON M.cod_carrera = C.cod_carrera
	JOIN EXAMENES E ON M.nro_alumno = E.nro_alumno
	AND M.cod_carrera = E.cod_carrera
WHERE A.nom_alumno = 'SANCHEZ'
	AND C.nom_carrera = 'CONTADOR PUBLICO'
	AND E.nota_examen >= C.nota_aprob_examen_final;
/*Cantidad de materias no aprobadas por el alumno 'SANCHEZ' en la carrera 'CONTADOR PUBLICO*/
SELECT COUNT(E.nota_examen)
FROM ALUMNOS A
	JOIN MATRICULAS M ON A.nro_alumno = M.nro_alumno
	JOIN CARRERAS C ON M.cod_carrera = C.cod_carrera
	JOIN EXAMENES E ON M.nro_alumno = E.nro_alumno
	AND M.cod_carrera = E.cod_carrera
WHERE A.nom_alumno = 'SANCHEZ'
	AND C.nom_carrera = 'CONTADOR PUBLICO'
	AND E.nota_examen < C.nota_aprob_examen_final;
/*Mostrar nro_alumno y nom_alumno de aquellos alumnos que no han rendido exámenes finales de ninguna carrera desde el 1/1/99.*/
SELECT A.nro_alumno,
	A.nom_alumno
FROM ALUMNOS A
WHERE NOT EXISTS (
		SELECT *
		FROM MATRICULAS M
			JOIN EXAMENES E ON M.nro_alumno = E.nro_alumno
			AND M.cod_carrera = E.cod_carrera
		WHERE A.nro_alumno = M.nro_alumno
			AND E.fecha_examen >= '1999-01-01'
	);
/*Mostrar nro_alumno y nom_alumno de aquellos alumnos de la carrera 10 que ingresaron en 1996 y tienen aprobadas todas las materias obligatorias de dicha carrera hasta el tercer cuatrimestre inclusive.*/
SELECT A.nro_alumno,
	A.nom_alumno
FROM ALUMNOS A
	JOIN MATRICULAS M ON A.nro_alumno = M.nro_alumno
	JOIN CARRERAS C ON M.cod_carrera = C.cod_carrera
	JOIN MATERIAS MA ON C.cod_carrera = MA.cod_carrera
	JOIN EXAMENES E ON M.nro_alumno = E.nro_alumno
	AND M.cod_carrera = E.cod_carrera
	AND MA.cod_materia = E.cod_materia
WHERE M.ano_ingreso = 1996
	AND MA.optativa = FALSE
	AND MA.cuat_materia <= 3
	AND E.nota_examen >= C.nota_aprob_examen_final;
/*Obtener aquellos alumnos que se han recibido de una carrera y tienen todas las materias aprobadas a excepción de las materias optativas que pueden o no estar aprobadas*/
SELECT A.nro_alumno,
	A.nom_alumno,
	A.nro_doc_alumno
FROM ALUMNOS A
	INNER JOIN MATRICULAS M ON A.nro_alumno = M.nro_alumno
	INNER JOIN CARRERAS C ON M.cod_carrera = C.cod_carrera
	INNER JOIN MATERIAS MA ON C.cod_carrera = MA.cod_carrera
	INNER JOIN EXAMENES E ON MA.cod_carrera = E.cod_carrera
	AND MA.cod_materia = E.cod_materia
WHERE E.nota_examen >= C.nota_aprob_examen_final
	AND MA.optativa = FALSE
GROUP BY A.nro_alumno,
	A.nom_alumno,
	A.nro_doc_alumno
HAVING COUNT(MA.cod_materia) = (
		SELECT COUNT(cod_materia)
		FROM MATERIAS
		WHERE cod_carrera = M.cod_carrera
			AND optativa = FALSE
	);