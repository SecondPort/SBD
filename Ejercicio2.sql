/*Se tienen las siguientes relaciones:
 
 ALUMNOS (nro_alumno, nom_alumno, nro_doc_alumno)
 
 CARRERAS (cod_carrera, nom_carrera, nota_aprob_examen_final)
 
 MATERIAS (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
 
 MATRICULAS (nro_alumno, cod_carrera, ano_ingreso)
 
 EXAMENES (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
 Identificar claves primarias, claves alternativas y claves foráneas en SQL
 */

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
    optativa INTEGER NOT NULL,
    PRIMARY KEY (cod_carrera, cod_materia)
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
    PRIMARY KEY (nro_alumno, cod_carrera, cod_materia),
    FOREIGN KEY (nro_alumno, cod_carrera) REFERENCES MATRICULAS(nro_alumno, cod_carrera),
    FOREIGN KEY (cod_carrera, cod_materia) REFERENCES MATERIAS(cod_carrera, cod_materia)
);

/*Mostrar nro_alumno, nom_alumno, cod_carrera, nom_carrera y promedio de los alumnos que ingresaron en 1995 y tienen promedio >= 7 y han rendido más de 20 exámenes finales (no considerar los ausentes)*/
SELECT nro_alumno,
    nom_alumno,
    cod_carrera,
    nom_carrera,
    promedio
FROM (
        SELECT nro_alumno,
            nom_alumno,
            cod_carrera,
            nom_carrera,
            AVG(nota_examen) AS promedio
        FROM ALUMNOS,
            CARRERAS,
            MATRICULAS,
            EXAMENES
        WHERE ALUMNOS.nro_alumno = MATRICULAS.nro_alumno
            AND CARRERAS.cod_carrera = MATRICULAS.cod_carrera
            AND MATRICULAS.nro_alumno = EXAMENES.nro_alumno
            AND MATRICULAS.cod_carrera = EXAMENES.cod_carrera
            AND MATRICULAS.ano_ingreso = 1995
            AND EXAMENES.nota_examen > 0
        GROUP BY nro_alumno,
            nom_alumno,
            cod_carrera,
            nom_carrera
        HAVING COUNT(*) > 20
    ) AS T
WHERE promedio >= 7;


/*Cantidad de materias aprobadas por el alumno 'SANCHEZ' en la carrera 'CONTADOR PUBLICO'*/
SELECT COUNT(*)
FROM EXAMENES,
    ALUMNOS,
    CARRERAS
WHERE ALUMNOS.nro_alumno = EXAMENES.nro_alumno
    AND CARRERAS.cod_carrera = EXAMENES.cod_carrera
    AND ALUMNOS.nom_alumno = 'SANCHEZ'
    AND CARRERAS.nom_carrera = 'CONTADOR PUBLICO'
    AND EXAMENES.nota_examen >= CARRERAS.nota_aprob_examen_final;


/*Cantidad de materias no aprobadas por el alumno 'SANCHEZ' en la carrera 'CONTADOR PUBLICO'*/
SELECT COUNT(*)
FROM EXAMENES,
    ALUMNOS,
    CARRERAS
WHERE ALUMNOS.nro_alumno = EXAMENES.nro_alumno
    AND CARRERAS.cod_carrera = EXAMENES.cod_carrera
    AND ALUMNOS.nom_alumno = 'SANCHEZ'
    AND CARRERAS.nom_carrera = 'CONTADOR PUBLICO'
    AND EXAMENES.nota_examen < CARRERAS.nota_aprob_examen_final;


/*Mostrar nro_alumno y nom_alumno de aquellos alumnos que no han rendido exámenes finales de ninguna carrera desde el 1/1/99*/
SELECT nro_alumno,
    nom_alumno
FROM ALUMNOS
WHERE nro_alumno NOT IN (
        SELECT nro_alumno
        FROM EXAMENES
        WHERE fecha_examen >= '1999-01-01'
    );


/*Mostrar nro_alumno y nom_alumno de aquellos alumnos de la carrera 10 que ingresaron en 1996 y tienen aprobadas todas las materias obligatorias de dicha carrera hasta el tercer cuatrimestre inclusive.*/
SELECT nro_alumno,
    nom_alumno
FROM ALUMNOS,
    MATRICULAS,
    EXAMENES,
    MATERIAS
WHERE ALUMNOS.nro_alumno = MATRICULAS.nro_alumno
    AND MATRICULAS.nro_alumno = EXAMENES.nro_alumno
    AND MATRICULAS.cod_carrera = EXAMENES.cod_carrera
    AND MATRICULAS.cod_carrera = MATERIAS.cod_carrera
    AND MATRICULAS.cod_carrera = 10
    AND MATRICULAS.ano_ingreso = 1996
    AND MATERIAS.optativa = 0
    AND EXAMENES.cod_materia = MATERIAS.cod_materia
    AND EXAMENES.nota_examen >= MATERIAS.nota_aprob_examen_final
    AND MATERIAS.cuat_materia <= 3
GROUP BY nro_alumno,
    nom_alumno
HAVING COUNT(*) = (
        SELECT COUNT(*)
        FROM MATERIAS
        WHERE MATERIAS.cod_carrera = 10
            AND MATERIAS.optativa = 0
            AND MATERIAS.cuat_materia <= 3
    );