CREATE SCHEMA ClienteTelefono;
GO


Create table Clientes (
	IDCliente int primary key identity(1,1),
	Nombres varchar(50) not null, 
	Apellidos varchar(50) not null constraint CK_Clientes_Apellido check (Apellidos != ''),
	Email varchar(100) not null unique,
	pw varbinary(100) not null constraint CK_Clientes_pw check (pw != '0x'),
	DireccionEnvio varchar(200) not null,
	Pais varchar(50) constraint CK_Clientes_Pais check (Pais != ''),
	Ciudad varchar(50),
	created_at datetime default getdate(),
	updated_at datetime,
	deleted_at datetime
);

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

Create table Productos (
	IDProducto int primary key identity(1,1),
	Nombre varchar(100) not null,
	Stock int not null constraint CK_Productos_Stock check (Stock >= 0),
	IDCategoria int not null constraint FK_Productos_Categorias foreign key references Categorias(IDCategoria)
);

insert into Productos (Nombre, Stock, IDCategoria) values 
('Laptop', 10, 1),
('Smartphone', 20, 1),
('Cámara', 15, 2),
('Televisor', 5, 2)