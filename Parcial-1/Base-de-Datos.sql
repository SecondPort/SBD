/*Una empresa que fabrica electrodomésticos desea mantener información acerca de los mismos, sus modelos, los clientes que los han adquirido y los reclamos por garantía que han tenido. La empresa vende sus productos a comercios minoristas quienes son los encargados de vender al público.
Para esto decide implementar una base de datos relacional.

La información a almacenar en la misma es la siguiente:

    • La empresa produce diferentes tipos de electrodomésticos. Por ejemplo: heladeras, aires acondicionados, lavarropas, cocinas, hornos, etc. Cada tipo de electrodoméstico se identifica por un código interno único, nombre y clase de electrodoméstico (por ejemplo: calefacción, refrigeración, etc.)

    • De cada tipo de electrodoméstico se producen varios modelos que se identifican por un código único, y se debe registrar su denominación. Cada uno tiene diferentes prestaciones o características. Se debe mantener información acerca de sus características (cada característica se describe a través de un texto libre) y el tiempo de garantía otorgado por la empresa, medido en meses.

    • Se deben registrar las partes que componen los modelos. Las partes se identifican con un código único y se debe registrar su denominación y una descripción (texto libre). Una parte puede ser utilizada para varios modelos. Se debe indicar también, que cantidad de unidades de cada parte se utiliza en el armado de cada modelo. 

    • A medida que se van fabricando los electrodomésticos se deben ir registrando. Cada electrodoméstico fabricado se identifica por un nro. de serie único. Se debe indicar el tipo de electrodoméstico, el modelo, la fecha de fabricación, y si está vendido, el comercio minorista y la fecha de venta al comercio minorista.

    • De los comercios se requiere conocer su nombre, dirección y teléfonos. 

    • Se deben registrar también los reclamos realizados por los clientes durante el período de garantía de los electrodomésticos. En particular se necesita conocer el electrodoméstico, el cliente (usuario final), la fecha de venta al cliente (fecha de factura), la fecha de registro de la falla y una descripción de la misma (texto libre).

Se solicita:

Diseñar un modelo lógico de datos normalizado hasta la cuaerta forma normal usando sql*/

CREATE TABLE tipo_electrodomestico(
	id_tipo_electrodomestico INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	clase VARCHAR(50) NOT NULL
);

CREATE TABLE modelo(
	id_modelo INTEGER PRIMARY KEY,
	id_tipo_electrodomestico INTEGER NOT NULL,
	denominacion VARCHAR(50) NOT NULL,
	FOREIGN KEY (id_tipo_electrodomestico) REFERENCES tipo_electrodomestico(id_tipo_electrodomestico)
);

CREATE TABLE caracteristica(
	id_caracteristica INTEGER PRIMARY KEY,
	id_modelo INTEGER NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	tiempo_garantia INTEGER NOT NULL,
	FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo)
);

CREATE TABLE parte(
	id_parte INTEGER PRIMARY KEY,
	denominacion VARCHAR(50) NOT NULL,
	descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE modelo_parte(
	id_modelo INTEGER NOT NULL,
	id_parte INTEGER NOT NULL,
	cantidad INTEGER NOT NULL,
	PRIMARY KEY (id_modelo, id_parte),
	FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo),
	FOREIGN KEY (id_parte) REFERENCES parte(id_parte)
);

CREATE TABLE electrodomestico(
	id_electrodomestico INTEGER PRIMARY KEY,
	id_modelo INTEGER NOT NULL,
	fecha_fabricacion DATE NOT NULL,
	vendido BOOLEAN NOT NULL,
	id_comercio INTEGER,
	fecha_venta DATE,
	FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo),
	FOREIGN KEY (id_comercio) REFERENCES comercio(id_comercio)
);

CREATE TABLE comercio(
	id_comercio INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	telefono VARCHAR(50) NOT NULL
);

CREATE TABLE reclamo(
	id_reclamo INTEGER PRIMARY KEY,
	id_electrodomestico INTEGER NOT NULL,
	id_cliente INTEGER NOT NULL,
	fecha_venta DATE NOT NULL,
	fecha_falla DATE NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	FOREIGN KEY (id_electrodomestico) REFERENCES electrodomestico(id_electrodomestico),
	FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE cliente(
	id_cliente INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	telefono VARCHAR(50) NOT NULL
);

CREATE TABLE clase_electrodomestico(
	id_clase_electrodomestico INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL
);