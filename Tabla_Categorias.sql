create schema Inventario;
go

create table Inventario.CATEGORIA (
    id_categoria INT IDENTITY(1,1),
    nombre       NVARCHAR(100) NOT NULL,
    
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria),
    
    CONSTRAINT ck_nombre_categoria_no_vacio CHECK (LEN(TRIM(nombre)) > 0)
)
go

Insert into Inventario.CATEGORIA (nombre) values (N'Audio');
Insert into Inventario.CATEGORIA (nombre) values (N'Baterias y Cargadores');
Insert into Inventario.CATEGORIA (nombre) values (N'Computacion');
Insert into Inventario.CATEGORIA (nombre) values (N'Fotografia');
Insert into Inventario.CATEGORIA (nombre) values (N'Hogar y Oficina');
Insert into Inventario.CATEGORIA (nombre) values (N'Teklefonia');
Insert into Inventario.CATEGORIA (nombre) values (N'Mundo Gamer');
go