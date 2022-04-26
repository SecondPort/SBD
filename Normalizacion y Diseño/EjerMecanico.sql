/*Un taller mecánico de una concesionaria de automóviles de una marca X desea construir una aplicación que le permita registrar y consultar información acerca de las reparaciones realizadas en el mismo. Para esto se deberá diseñar una base de datos relacional de acuerdo a las siguientes especificaciones:

- Se deberá registrar información acerca de todas las concesionarias de la marca (nro_concesionaria, nom_concesionaria, dir_concesionaria, teléfonos).

- Para esta concesionaria se deberá registrar información acerca de:

- los empleados del taller: datos personales, especialidad y su cargo.

- los repuestos: nro_repuesto, nom_repuesto, stock, costo, modelos y años de fabricación en los que se utiliza

- los servicios que brinda el taller: nro_servicio, desc_servicio, costo

- Para cada vehículo se registra la siguiente información: Chapa patente, país donde está registrado, modelo, año de fabricación, nro. de chasis, nro. de motor, tipo de vehículo (automóvil o pick-up), concesionaria donde fue comprado.

- Cada cliente tiene registrada información acerca de sus datos personales tales como: nombre, dirección y teléfono. Se los identifica por un número.

- Un cliente puede tener más de un vehículo. Un vehículo tiene un dueño actual, pero podría haber sido propiedad de otro cliente anteriormente.

- Se deberá registrar información acerca de los presupuestos que se emiten indicando: nro_presupuesto, fecha_presupuesto, validez_presupuesto, cliente, vehículo, kilómetros recorridos, en garantía (si o no), problemas planteados, soluciones posibles, costos de cada una de ellas, responsable del presupuesto.

- Se deberá registrar la siguiente información acerca de los trabajos realizados (servicios y repuestos utilizados en el mismo): nro_factura, fecha_factura, fecha_entrada, fecha_salida, cliente, vehículo, kilómetros recorridos, en garantía (si o no), problemas planteados, observaciones, servicios realizados, repuestos utilizados, cantidad utilizada de los mismos, precio unitario de cada uno, nro. de presupuesto asociado en el caso de tenerlo, mecánicos que participaron, responsable del trabajo, conforme (si o no).

Realizarlo utilizando sql
*/

CREATE TABLE concesionaria(
	nro_concesionaria INTEGER NOT NULL,
	nom_concesionaria VARCHAR(50) NOT NULL,
	dir_concesionaria VARCHAR(50) NOT NULL,
	telefono VARCHAR(50) NOT NULL,
	PRIMARY KEY (nro_concesionaria)
);

CREATE TABLE empleado(
	nro_empleado INTEGER NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	dni VARCHAR(50) NOT NULL,
	especialidad VARCHAR(50) NOT NULL,
	cargo VARCHAR(50) NOT NULL,
	PRIMARY KEY (nro_empleado)
);

CREATE TABLE repuesto(
	nro_repuesto INTEGER NOT NULL,
	nom_repuesto VARCHAR(50) NOT NULL,
	stock INTEGER NOT NULL,
	costo INTEGER NOT NULL,
	modelos VARCHAR(50) NOT NULL,
	años_fabricacion INTEGER NOT NULL,
	PRIMARY KEY (nro_repuesto)
);

CREATE TABLE servicio(
	nro_servicio INTEGER NOT NULL,
	desc_servicio VARCHAR(50) NOT NULL,
	costo INTEGER NOT NULL,
	PRIMARY KEY (nro_servicio)
);

CREATE TABLE vehiculo(
	chapa_patente VARCHAR(50) NOT NULL,
	pais_registro VARCHAR(50) NOT NULL,
	modelo VARCHAR(50) NOT NULL,
	año_fabricacion INTEGER NOT NULL,
	nro_chasis INTEGER NOT NULL,
	nro_motor INTEGER NOT NULL,
	tipo_vehiculo VARCHAR(50) NOT NULL,
	nro_concesionaria INTEGER NOT NULL,
	PRIMARY KEY (chapa_patente),
	FOREIGN KEY (nro_concesionaria) REFERENCES concesionaria(nro_concesionaria)
);

CREATE TABLE cliente(
	nro_cliente INTEGER NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	telefono VARCHAR(50) NOT NULL,
	PRIMARY KEY (nro_cliente)
);

CREATE TABLE presupuesto(
	nro_presupuesto INTEGER NOT NULL,
	fecha_presupuesto DATE NOT NULL,
	validez_presupuesto DATE NOT NULL,
	nro_cliente INTEGER NOT NULL,
	chapa_patente VARCHAR(50) NOT NULL,
	kilometros_recorridos INTEGER NOT NULL,
	en_garantia VARCHAR(50) NOT NULL,
	problemas_planteados VARCHAR(50) NOT NULL,
	soluciones_posibles VARCHAR(50) NOT NULL,
	costos INTEGER NOT NULL,
	nro_empleado INTEGER NOT NULL,
	PRIMARY KEY (nro_presupuesto),
	FOREIGN KEY (nro_cliente) REFERENCES cliente(nro_cliente),
	FOREIGN KEY (chapa_patente) REFERENCES vehiculo(chapa_patente),
	FOREIGN KEY (nro_empleado) REFERENCES empleado(nro_empleado)
);

CREATE TABLE trabajo(
	nro_factura INTEGER NOT NULL,
	fecha_factura DATE NOT NULL,
	fecha_entrada DATE NOT NULL,
	fecha_salida DATE NOT NULL,
	nro_cliente INTEGER NOT NULL,
	chapa_patente VARCHAR(50) NOT NULL,
	kilometros_recorridos INTEGER NOT NULL,
	en_garantia VARCHAR(50) NOT NULL,
	problemas_planteados VARCHAR(50) NOT NULL,
	observaciones VARCHAR(50) NOT NULL,
	nro_servicio INTEGER NOT NULL,
	nro_repuesto INTEGER NOT NULL,
	cantidad_utilizada INTEGER NOT NULL,
	precio_unitario INTEGER NOT NULL,
	nro_presupuesto INTEGER NOT NULL,
	nro_empleado INTEGER NOT NULL,
	conforme VARCHAR(50) NOT NULL,
	PRIMARY KEY (nro_factura),
	FOREIGN KEY (nro_cliente) REFERENCES cliente(nro_cliente),
	FOREIGN KEY (chapa_patente) REFERENCES vehiculo(chapa_patente),
	FOREIGN KEY (nro_servicio) REFERENCES servicio(nro_servicio),
	FOREIGN KEY (nro_repuesto) REFERENCES repuesto(nro_repuesto),
	FOREIGN KEY (nro_presupuesto) REFERENCES presupuesto(nro_presupuesto),
	FOREIGN KEY (nro_empleado) REFERENCES empleado(nro_empleado)
);