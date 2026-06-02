create table Pedido
(IDPedido int identity(1,1) Constraint pk_idPedido Primary key,
IDCliente int COnstraint fk_idCliente foreign key references Clientes(IDCliente),
fechaPedido datetime constraint df_fechaPedido default getdate() not null,
IDProducto int Constraint fk_idProducto foreign key references Producto(IDProducto),
Estado varchar(20) Constraint df_Estado default 'Pendiente',
created_at datetime Constraint df_createdat default getdate(),
updated_at datetime null,
deleted_at datetime,
Constraint ck_Estado CHECK(Estado IN ('Pendiente', 'Enviado', 'Entregado', 'Cancelado')
);

GO

create table DetallePedido
(idDetalle int identity(1,1) Constraint pk_idDetalle Primary key,
IDPedido int Constraint fk_idPedido foreign key references Pedido(IDPedido),
IDProducto int Constraint fk_idProducto foreign key references Producto(IDProducto),
cantidad int not null,
precioUnitario decimal(10,2) not null constraint ck_precioUnitario CHECK(precioUnitario > 0),
MetodoPago varchar(20) Constraint df_MetodoPago default 'Efectivo',
created_at datetime Constraint df_createdat default getdate(),
updated_at datetime null,
deleted_at datetime
);

GO

-- PEDIDOS
INSERT INTO Pedido (IDCliente, IDProducto, Estado)
VALUES
(1, 1, 'Pendiente'),
(2, 3, 'Enviado'),
(3, 2, 'Entregado'),
(1, 4, 'Cancelado'),
(4, 5, 'Pendiente');
GO

-- DETALLE PEDIDO
INSERT INTO DetallePedido
(IDPedido, IDProducto, Cantidad, PrecioUnitario, MetodoPago)
VALUES
(1, 1, 2, 15.50, 'Efectivo'),
(1, 2, 1, 25.00, 'Tarjeta'),
(2, 3, 3, 12.75, 'Transferencia'),
(3, 2, 5, 8.99, 'Efectivo'),
(4, 4, 1, 45.00, 'Tarjeta'),
(5, 5, 2, 30.00, 'Efectivo');
GO


