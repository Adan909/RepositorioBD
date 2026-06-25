USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TiendaOnline1')
BEGIN
    ALTER DATABASE TiendaOnline1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TiendaOnline1;
END
GO

CREATE DATABASE TiendaOnline1;
GO

USE TiendaOnline1;
GO

CREATE SCHEMA ClienteTelefono;
GO
CREATE SCHEMA Inventario;
GO
CREATE SCHEMA Usuarios;
GO

CREATE TABLE Clientes (
	IDCliente int primary key identity(1,1),
	Nombres varchar(50) not null, 
	Apellidos varchar(50) not null,
	Email varchar(100) not null unique,
	pw varbinary(100) not null constraint CK_Clientes_pw check (pw != 0x),
	DireccionEnvio varchar(200) not null,
	Pais varchar(50) constraint CK_Clientes_Pais check (Pais != ''),
	Ciudad varchar(50),
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime
);
GO

CREATE TABLE ClienteTelefono.Telefonos (
    IDTelefono int primary key identity(1,1),
    IDCliente int not null,
    Tipo varchar(20) not null constraint CK_Telefonos_Tipo check (Tipo IN ('Celular', 'Casa', 'Trabajo', 'Otro')),
    Numero varchar(9) not null constraint CK_Telefonos_Numero check (Numero LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    CONSTRAINT FK_Telefonos_Clientes FOREIGN KEY (IDCliente) REFERENCES Clientes(IDCliente),
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime
);
GO

INSERT INTO Clientes (Nombres, Apellidos, Email, pw, DireccionEnvio, Pais, Ciudad)
VALUES 
('Carlos', 'Mendoza', 'carlos.mendoza@email.com', HASHBYTES('SHA2_256', 'ClaveCarlos1'), 'Av. Central 123', 'Guatemala', 'Guatemala'),
('Ana', 'Gomez', 'ana.gomez@email.com', HASHBYTES('SHA2_256', 'PasswordAna2'), 'Calle Floresta #45', 'El Salvador', 'San Salvador');
GO

INSERT INTO ClienteTelefono.Telefonos (IDCliente, Tipo, Numero)
VALUES 
(1, 'Celular', '1234-4567'), 
(1, 'Trabajo', '5552-9988'), 
(2, 'Celular', '9876-5432'), 
(2, 'Casa',    '2221-1221'); 
GO

CREATE TABLE Inventario.CATEGORIA (
    IDCategoria INT IDENTITY(1,1), 
    Nombre      VARCHAR(100) NOT NULL, 
    CONSTRAINT pk_categoria PRIMARY KEY (IDCategoria),
    CONSTRAINT ck_nombre_categoria_no_vacio CHECK (LEN(TRIM(Nombre)) > 0),
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime
);
GO

INSERT INTO Inventario.CATEGORIA (Nombre) VALUES 
('Electrónica'), ('Hogar'), (N'Audio'), (N'Baterias y Cargadores'), 
(N'Computacion'), (N'Fotografia'), (N'Hogar y Oficina'), (N'Teklefonia'), (N'Mundo Gamer');
GO

CREATE TABLE Productos (
	IDProducto int primary key identity(1,1),
	Nombre varchar(100) not null,
	Stock int not null constraint CK_Productos_Stock check (Stock >= 0),
	IDCategoria int not null,
	CONSTRAINT FK_Productos_Categorias foreign key (IDCategoria) references Inventario.CATEGORIA(IDCategoria),
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime
);
GO

INSERT INTO productos (Nombre, Stock, IDCategoria) VALUES 
('Laptop', 10, 1), 
('Smartphone', 20, 1), 
('Audífonos', 15, 3), 
('Cargador', 30, 4), 
('Mouse', 25, 5), 
('Teclado', 18, 5), 
('Silla Gamer', 12, 7), 
('Escritorio', 8, 7);
GO

CREATE TABLE Usuarios.Rol(
	IDRol int identity(1,1),
	Rol nvarchar(50) not null,
	created_at datetime default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	constraint pk_Rol primary key (IDRol),
	constraint uq_rol_nombre unique (Rol)
);
GO

CREATE TABLE Usuarios.USUARIO(
	IDUsuario int identity(1,1),
	Nombres nvarchar(100) not null,
	Apellidos nvarchar(100) not null,
	Email nvarchar(150) not null,
	Telefono varchar(20) null,
	passw varbinary(60) not null,
	IDRol int not null, 
	created_at datetime default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	constraint pk_Usuario_Con_Rol primary key (idUsuario),
	constraint uq_usuario_email unique (Email),
	constraint fk_usuario_rol foreign key (IDRol) references Usuarios.Rol(IDRol),
	constraint chk_usuario_email check (Email like '%@%._%'),
	constraint CK_Usuarios_pw check (passw != 0x)
);
GO

INSERT INTO Usuarios.Rol (Rol) VALUES ('Administrador'), ('Vendedor'), ('Cliente');
GO

INSERT INTO Usuarios.USUARIO (Nombres, Apellidos, Email, Telefono, passw, IDRol) VALUES 
('Kellys', 'Bellanger', 'kellys.admin@tienda.com', '+50588881111', HASHBYTES('SHA2_256', 'Admin2026!'), 1),
('Alfredo', 'Ortega', 'alfeed.ventas@tienda.com', '+50588882222', HASHBYTES('SHA2_256', 'Vendedor_2026'), 2),
('Raul', 'Valverde', 'raulvruix@email.com', '+50588883333', HASHBYTES('SHA2_256', 'MiClaveSecreta'), 3);
GO

CREATE TABLE Pedido(
    IDPedido int identity(1,1) Constraint pk_idPedido Primary key,
    IDCliente int COnstraint fk_idCliente foreign key references Clientes(IDCliente),
    fechaPedido datetime constraint df_fechaPedido default getdate() not null,
    IDProducto int Constraint fk_idProducto_Pedido foreign key references Productos(IDProducto),
    Estado varchar(20) Constraint df_Estado default 'Pendiente',
    created_at datetime Constraint df_createdat default getdate(),
    updated_at datetime null,
    deleted_at datetime,
    Constraint ck_Estado CHECK(Estado IN ('Pendiente', 'Enviado', 'Entregado', 'Cancelado'))
);
GO

CREATE TABLE DetallePedido(
    idDetalle int identity(1,1) Constraint pk_idDetalle Primary key,
    IDPedido int Constraint fk_idPedido_Detalle foreign key references Pedido(IDPedido),
    IDProducto int Constraint fk_idProducto_Detalle foreign key references Productos(IDProducto),
    cantidad int not null,
    precioUnitario decimal(10,2) not null constraint ck_precioUnitario CHECK(precioUnitario > 0),
    MetodoPago varchar(20) Constraint df_MetodoPago default 'Efectivo',
    created_at datetime Constraint df_createdate default getdate(),
    updated_at datetime null,
    deleted_at datetime
);
GO

INSERT INTO Pedido (IDCliente, IDProducto, Estado) VALUES
(1, 1, 'Pendiente'),
(2, 2, 'Enviado'),
(1, 3, 'Entregado'),
(1, 4, 'Cancelado'),
(2, 5, 'Pendiente');
GO

INSERT INTO DetallePedido(IDPedido, IDProducto, Cantidad, PrecioUnitario, MetodoPago) VALUES
(1, 1, 2, 15.50, 'Efectivo'),
(2, 2, 1, 25.00, 'Tarjeta'),
(3, 3, 3, 12.75, 'Transferencia'),
(4, 4, 5, 8.99, 'Efectivo'),
(5, 5, 1, 45.00, 'Tarjeta');
GO

UPDATE Clientes
SET DireccionEnvio = 'Calle Principal #789, Apt 2B', 
    Ciudad = 'Antigua Guatemala',
    updated_at = GETDATE()
WHERE IDCliente = 1;

UPDATE Inventario.CATEGORIA
SET Nombre = 'Telefonía'
WHERE Nombre = 'Teklefonia';

UPDATE Productos
SET Stock = Stock + 15
WHERE Nombre = 'Laptop';

UPDATE Pedido
SET Estado = 'Enviado',
    updated_at = GETDATE()
WHERE IDPedido = 1;

UPDATE Usuarios.USUARIO
SET Telefono = '888889999',
    updated_at = GETDATE()
WHERE Email = 'kellys.admin@tienda.com';
GO

DELETE FROM ClienteTelefono.Telefonos
WHERE IDTelefono = 4;
GO

SELECT * FROM Clientes;
SELECT * FROM ClienteTelefono.Telefonos;
SELECT * FROM Inventario.CATEGORIA;
SELECT * FROM Productos;
SELECT * FROM Usuarios.Rol;
SELECT * FROM Usuarios.USUARIO;
SELECT * FROM Pedido;
SELECT * FROM DetallePedido;
GO