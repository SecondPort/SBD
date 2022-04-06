/*PRODUCTOS (nro_producto, nom_producto, stock)
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
nro_producto es único por pedido
 */
CREATE TABLE PRODUCTOS (
    nro_producto INTEGER PRIMARY KEY,
    nom_producto VARCHAR(50) NOT NULL,
    stock INTEGER NOT NULL
);
CREATE TABLE PROVEEDORES (
    nro_proveedor INTEGER PRIMARY KEY,
    nom_proveedor VARCHAR(50) NOT NULL
);
CREATE TABLE COMPONENTES (
    nro_componente INTEGER PRIMARY KEY,
    nom_componente VARCHAR(50) NOT NULL,
    nro_proveedor INTEGER NOT NULL,
    stock INTEGER NOT NULL,
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
    nro_cliente INTEGER PRIMARY KEY,
    nom_cliente VARCHAR(50) NOT NULL,
    loc_cliente VARCHAR(50) NOT NULL
);
CREATE TABLE PEDIDOS (
    nro_pedido INTEGER PRIMARY KEY,
    nro_cliente INTEGER NOT NULL,
    fecha_pedido DATE NOT NULL,
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

/*nro_componente, nom_componente de aquellos componentes que se utilicen en el armado de más productos. usando JOIN*/
SELECT c.nro_componente,
    c.nom_componente
FROM COMPONENTES c
    JOIN ARMADO a ON c.nro_componente = a.nro_componente
GROUP BY c.nro_componente,
    c.nom_componente
HAVING COUNT(*) > 1;

/*nro_producto y nom_producto de los productos que hayan sido pedidos por algún cliente y que utilicen algún componente del proveedor ‘J. PEREZ Y CIA.’ que tenga stock = 0.*/
SELECT p.nro_producto,
    p.nom_producto
FROM PRODUCTOS p
    JOIN ARMADO a ON p.nro_producto = a.nro_producto
    JOIN COMPONENTES c ON a.nro_componente = c.nro_componente
    JOIN PROVEEDORES pr ON c.nro_proveedor = pr.nro_proveedor
    JOIN DETALLE_PEDIDOS dp ON p.nro_producto = dp.nro_producto
WHERE c.stock = 0
    AND pr.nom_proveedor = 'J. PEREZ Y CIA.';

/*nom_producto y cantidad que se deberá fabricar de cada producto para satisfacer los pedidos de los clientes.*/
SELECT p.nom_producto,
    SUM(dp.cantidad) AS cantidad
FROM PRODUCTOS p
    JOIN DETALLE_PEDIDOS dp ON p.nro_producto = dp.nro_producto
GROUP BY p.nom_producto;

/*lista de componentes (nro_componente, nom_componente y cantidad que hará falta comprar de cada componente) para fabricar la cantidad faltante de productos que satisfacen los pedidos de los clientes. (Solo se comprará una cantidad determinada de un componente si hace falta fabricar productos que utilicen ese componente y no hay stock suficiente del mismo para fabricar los productos)*/
SELECT c.nro_componente,
    c.nom_componente,
    SUM(a.cantidad * dp.cantidad) AS cantidad
FROM COMPONENTES c
    JOIN ARMADO a ON c.nro_componente = a.nro_componente
    JOIN PRODUCTOS p ON a.nro_producto = p.nro_producto
    JOIN DETALLE_PEDIDOS dp ON p.nro_producto = dp.nro_producto
GROUP BY c.nro_componente,
    c.nom_componente
HAVING SUM(a.cantidad * dp.cantidad) > c.stock;