use master
go

create database TiendaOnline1;
go	




CREATE SCHEMA ClienteTelefono;
GO

CREATE SCHEMA Inventario;
GO

CREATE SCHEMA Usuarios;
GO

Create table Clientes (
	IDCliente int primary key identity(1,1),
	Nombres varchar(50) not null, 
	Apellidos varchar(50) not null,
	Email varchar(100) not null unique,
	pw varbinary(100) not null constraint CK_Clientes_pw check (pw != '0x'),
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
    Numero varchar(8) not null constraint CK_Telefonos_Numero check (Numero LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    CONSTRAINT FK_Telefonos_Clientes FOREIGN KEY (IDCliente) REFERENCES Clientes(IDCliente)
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
    CONSTRAINT ck_nombre_categoria_no_vacio CHECK (LEN(TRIM(Nombre)) > 0)
);
GO

INSERT INTO Inventario.CATEGORIA (Nombre) VALUES ('Electrónica'), ('Hogar');
INSERT INTO Inventario.CATEGORIA (Nombre) VALUES (N'Audio');
INSERT INTO Inventario.CATEGORIA (Nombre) VALUES (N'Baterias y Cargadores');
INSERT INTO Inventario.CATEGORIA (Nombre) VALUES (N'Computacion');
INSERT INTO Inventario.CATEGORIA (Nombre) VALUES (N'Fotografia');
INSERT INTO Inventario.CATEGORIA (Nombre) VALUES (N'Hogar y Oficina');
INSERT INTO Inventario.CATEGORIA (Nombre) VALUES (N'Teklefonia');
INSERT INTO Inventario.CATEGORIA (Nombre) VALUES (N'Mundo Gamer');
GO

CREATE TABLE Productos (
	IDProducto int primary key identity(1,1),
	Nombre varchar(100) not null,
	Stock int not null constraint CK_Productos_Stock check (Stock >= 0),
	IDCategoria int not null,
	CONSTRAINT FK_Productos_Categorias foreign key (IDCategoria) references Inventario.CATEGORIA(IDCategoria)
);
GO

create table Usuarios.Rol(
	IDRol int identity(1,1),
	Rol nvarchar(50) not null,
	created_at datetime default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	constraint pk_Rol primary key (IDRol),
	constraint uq_rol_nombre unique (Rol)
);
GO

create table Usuarios.USUARIO(
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
	constraint CK_Usuarios_pw check (passw != '0x')
);
GO

insert into Usuarios.Rol (Rol) values ('Administrador'), ('Vendedor'), ('Cliente');
GO

insert into Usuarios.USUARIO (Nombres, Apellidos, Email, Telefono, passw, IDRol)
values 
('Kellys', 'Bellanger', 'kellys.admin@tienda.com', '+50588881111', HASHBYTES('SHA2_256', 'Admin2026!'), 1),
('Alfredo', 'Ortega', 'alfeed.ventas@tienda.com', '+50588882222', HASHBYTES('SHA2_256', 'Vendedor_2026'), 2),
('Raul', 'Valverde', 'raulvruix@email.com', '+50588883333', HASHBYTES('SHA2_256', 'MiClaveSecreta'), 3);
GO

create table Pedido(
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

create table DetallePedido(
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

INSERT INTO Pedido (IDCliente, IDProducto, Estado)
VALUES
(1, 1, 'Pendiente'),
(2, 1, 'Enviado'),
(1, 1, 'Entregado'),
(1, 1, 'Cancelado'),
(2, 1, 'Pendiente');
GO

INSERT INTO DetallePedido(IDPedido, IDProducto, Cantidad, PrecioUnitario, MetodoPago)
VALUES
(3, 1, 2, 15.50, 'Efectivo'),
(4, 1, 1, 25.00, 'Tarjeta'),
(5, 1, 3, 12.75, 'Transferencia'),
(6, 1, 5, 8.99, 'Efectivo'),
(7, 1, 1, 45.00, 'Tarjeta');
GO

insert into productos (Nombre, Stock, IDCategoria) values 
('Laptop', 10, 1), 
('Smartphone', 20, 1), 
('Audífonos', 15, 3), 
('Cargador', 30, 4), 
('Mouse', 25, 5), 
('Teclado', 18, 5), 
('Silla Gamer', 12, 7), 
('Escritorio', 8, 7);

select* from sys.tables;

select * from Clientes;

select * from Inventario.CATEGORIA;
select * from Productos;
select * from Usuarios.Rol;
select * from Usuarios.USUARIO;
select * from Pedido;
select * from DetallePedido;
