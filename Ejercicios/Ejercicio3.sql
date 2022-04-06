/*Se tienen las siguientes relaciones:

PRODUCTOS (nro_producto, nom_producto, stock)

nro_producto es único

PROVEEDORES (nro_proveedor, nom_proveedor)

nro_proveedor es único

COMPONENTES (nro_componente, nom_componente, nro_proveedor, stock)

nro_componente es único

ARMADO (nro_producto, nro_componente, cantidad)

nro_componente es único por producto

CLIENTES (nro_cliente, nom_cliente, loc_cliente)

nro_cliente es único

PEDIDOS (nro_pedido, nro_cliente, fecha_pedido)

nro_pedido es único

DETALLE_PEDIDOS (nro_pedido, nro_producto, cantidad)

nro_producto es único por pedido en sql*/

CREATE TABLE PRODUCTOS (
	nro_producto INTEGER NOT NULL,
	nom_producto VARCHAR(50) NOT NULL,
	stock INTEGER NOT NULL,
	PRIMARY KEY (nro_producto)
);

CREATE TABLE PROVEEDORES (
	nro_proveedor INTEGER NOT NULL,
	nom_proveedor VARCHAR(50) NOT NULL,
	PRIMARY KEY (nro_proveedor)
);

CREATE TABLE COMPONENTES (
	nro_componente INTEGER NOT NULL,
	nom_componente VARCHAR(50) NOT NULL,
	nro_proveedor INTEGER NOT NULL,
	stock INTEGER NOT NULL,
	PRIMARY KEY (nro_componente),
	FOREIGN KEY (nro_proveedor) REFERENCES PROVEEDORES(nro_proveedor)
);

CREATE TABLE ARMADO (
	nro_producto INTEGER NOT NULL,
	nro_componente INTEGER NOT NULL,
	cantidad INTEGER NOT NULL,
	PRIMARY KEY (nro_producto, nro_componente),
	FOREIGN KEY (nro_producto) REFERENCES PRODUCTOS(nro_producto),
	FOREIGN KEY (nro_componente) REFERENCES COMPONENTES(nro_componente)
);

CREATE TABLE CLIENTES (
	nro_cliente INTEGER NOT NULL,
	nom_cliente VARCHAR(50) NOT NULL,
	loc_cliente VARCHAR(50) NOT NULL,
	PRIMARY KEY (nro_cliente)
);

CREATE TABLE PEDIDOS (
	nro_pedido INTEGER NOT NULL,
	nro_cliente INTEGER NOT NULL,
	fecha_pedido DATE NOT NULL,
	PRIMARY KEY (nro_pedido),
	FOREIGN KEY (nro_cliente) REFERENCES CLIENTES(nro_cliente)
);

CREATE TABLE DETALLE_PEDIDOS (
	nro_pedido INTEGER NOT NULL,
	nro_producto INTEGER NOT NULL,
	cantidad INTEGER NOT NULL,
	PRIMARY KEY (nro_pedido, nro_producto),
	FOREIGN KEY (nro_pedido) REFERENCES PEDIDOS(nro_pedido),
	FOREIGN KEY (nro_producto) REFERENCES PRODUCTOS(nro_producto)
);

/*nro_componente, nom_componente de aquellos componentes que se utilicen en el armado de más productos.*/
SELECT nro_componente, nom_componente
FROM COMPONENTES
WHERE nro_componente IN (
	SELECT nro_componente
	FROM ARMADO
	GROUP BY nro_componente
	HAVING COUNT(*) > 1
);

/*nro_producto y nom_producto de los productos que hayan sido pedidos por algún cliente y que utilicen algún componente del proveedor ‘J. PEREZ Y CIA.’ que tenga stock = 0.*/
SELECT nro_producto, nom_producto
FROM PRODUCTOS
WHERE nro_producto IN (
	SELECT nro_producto
	FROM ARMADO
	WHERE nro_componente IN (
		SELECT nro_componente
		FROM COMPONENTES
		WHERE nro_proveedor IN (
			SELECT nro_proveedor
			FROM PROVEEDORES
			WHERE nom_proveedor = 'J. PEREZ Y CIA.'
		) AND stock = 0
	)
) AND nro_producto IN (
	SELECT nro_producto
	FROM DETALLE_PEDIDOS
);

/*nom_producto y cantidad que se deberá fabricar de cada producto para satisfacer los pedidos de los clientes*/
SELECT nom_producto, SUM(cantidad) AS cantidad
FROM PRODUCTOS
INNER JOIN DETALLE_PEDIDOS ON PRODUCTOS.nro_producto = DETALLE_PEDIDOS.nro_producto
GROUP BY nom_producto;

/*lista de componentes (nro_componente, nom_componente y cantidad que hará falta comprar de cada componente) para fabricar la cantidad faltante de productos que satisfacen los pedidos de los clientes. (Solo se comprará una cantidad determinada de un componente si hace falta fabricar productos que utilicen ese componente y no hay stock suficiente del mismo para fabricar los productos)*/

SELECT nro_componente, nom_componente, SUM(cantidad) AS cantidad
FROM COMPONENTES
INNER JOIN ARMADO ON COMPONENTES.nro_componente = ARMADO.nro_componente
INNER JOIN DETALLE_PEDIDOS ON ARMADO.nro_producto = DETALLE_PEDIDOS.nro_producto
GROUP BY nro_componente, nom_componente
HAVING SUM(cantidad) > stock;