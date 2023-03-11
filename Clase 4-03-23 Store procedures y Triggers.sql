--*---------------------------------------
--*Empresa:  [Universidad Mariano Galvez] 
--*Facultad de Ingenieria en Sistemas
--*Curso: Base de Datos II
--*Objetivo: Store procedures, Triggers y bitacora
--*Objetos:  Tablas, SQL, T-SQL, Store Procedure
--*Autor: Walter Emanuel Alvarez Hernandez
--*Fecha: Guatemala  04-03-2023, Hora: 09:00
---*----------------------------------------

--* Configuración de Base de DAtos
Use [UMG]

create table [dbo].[Clientes] (
ID VARCHAR(15) Primary Key,
Nombres varchar(75),
Apellidos varchar(75),
Direccion varchar(75),
Nit varchar(75),
Mobil varchar(14),
email varchar(75),
Fotogreafia image,
genero int,
status int
);

create table [dbo].[Bitacora] (
fecha date,
usuario varchar(15),
evento varchar(15),
cliente varchar(15)
);

Select * from [dbo].[Clientes];

insert into  [dbo].[Clientes] values ('umg001', 'Emanuel', 'Alvarez', 'km 24 ces joya 1', '5154875', '85424552', 'ema@gmail.com', null, 0, 1);
insert into  [dbo].[Clientes] values ('umg002', 'Gabriel', 'Hernandez', '6ta, Av A zoan1', 'CF', '54752456', 'gabriel12@gmail.com', null, 0, 1);

--*Drop Procedure  [dbo].[SP_Consulta_Clientes] Elimina un procedimiento
Create Procedure  [dbo].[SP_Consulta_Clientes]
	As
Begin

Set ANSI_NULLS ON 

Select c.id as 'Codigo cliente',
	c.Nombres,
	c.Apellidos,
	c.Direccion,
	c.Nit,
	c.Mobil,
	c.email,
	isnull(c.Fotogreafia, 'No') as 'Foto',
	c.status
from [dbo].[Clientes] c

END;

 --*Llamada de un procedimiento
 execute [dbo].[SP_Consulta_Clientes]

--*Triggers

Create trigger [dbo].[trigger_bitacora_Empleado] on  [UMG].[dbo].[Clientes]
	for Update 

As 
		Declare @v_fecha as date
		Declare @v_usuario as varchar(15)
		Declare @v_evento as varchar(15)
		Declare @_cliente as varchar(15)


Begin
	Begin
		
		set @v_fecha=(Select GETDATE())
		set @v_usuario=(Select USER)
		set @v_evento=('Updating')
		set @_cliente=(Select Id from inserted)

		insert into [UMG].[dbo].[Bitacora]
		Values (@v_fecha, @v_usuario, @v_evento, @_cliente)
	End
End
Go

--*test del trigger 
insert into  [dbo].[Clientes] values ('umg003', 'Rebecka', 'Rodriguez', 'zona 14 rancho 2', 'CF', '155554545', 'rbk@gmail.com', null, 1, 1);
Go
Update [dbo].[Clientes]
Set status = 0
Where ID = 'umg003'
select * from [UMG].[dbo].[Bitacora]
Go

select *from bitacora