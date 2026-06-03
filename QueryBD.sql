use TiendaOnline1
go
--Usamos nuestra base de datos

--Validar y crear el esquema si no existe
if not exists (select * from sys.schemas where name = 'Usuarios')
begin
    exec('create schema Usuarios')
end
go

-- 2. Crear la tabla de Roles
create table Usuarios.Rol(
	IDRol int identity(1,1),
	Rol nvarchar(50) not null,

	created_at datetime default getdate(),
	updated_at datetime null,
	deleted_at datetime null,

	constraint pk_Rol primary key (IDRol),
	constraint uq_rol_nombre unique (Rol)
)
go

-- 3. Crear la tabla de Usuarios
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
	constraint chk_usuario_email check (Email like '%_@_%._%'),
	constraint CK_Clientes_pw check (passw != '0x')
)
go

--insertamos valores a tabla Rol
insert into Usuarios.Rol (Rol) values ('Administrador');
insert into Usuarios.Rol (Rol) values ('Vendedor');
insert into Usuarios.Rol (Rol) values ('Cliente');
go

--insertamos valores a tabla Usuario
insert into Usuarios.USUARIO (Nombres, Apellidos, Email, Telefono, passw, IDRol)
values (
    'Kellys', 
    'Bellanger', 
    'kellys.admin@tienda.com', 
    '+50588881111', 
    HASHBYTES('SHA2_256', 'Admin2026!'), -- Se guarda como VARBINARY automáticamente
    1
);
insert into Usuarios.USUARIO (Nombres, Apellidos, Email, Telefono, passw, IDRol)
values (
    'Alfredo', 
    'Ortega', 
    'alfeed.ventas@tienda.com', 
    '+50588882222', 
    HASHBYTES('SHA2_256', 'Vendedor_2026'), 
    2
);
insert into Usuarios.USUARIO (Nombres, Apellidos, Email, Telefono, passw, IDRol)
values (
    'Raul', 
    'Valverde', 
    'raulvruix@email.com', 
    '+50588883333', 
    HASHBYTES('SHA2_256', 'MiClaveSecreta'), 
    3
);
go