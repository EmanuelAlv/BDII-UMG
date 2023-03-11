---* TRANSACCIONES---------------------------------------------------------------------------------------------------

Create Database UMG;

Use [UMG]  --* Configurar Variable de Ambiene (Base de Datos)
Go

--* Creando Schema
Create Schema Test;--*Creacion y llenado de tablas para ejemplos

--* Creacion de Tabla
 Create Table [Test].[Cientes]
(
Id_cliente Int Primary Key,
Nombres     Varchar(50),
Apellidos   Varchar(50),
Telefono    Varchar(15),
Status      Int
);

Create Table [Test].Cuenta
(
Id_cuenta Int Primary Key,
Monto Decimal(38,2),
Id_Cliente Int,
Status Int
);

--* Agregando LLave Foranea Externa
Alter Table [UMG].[Test].[Cuenta] Add Foreign Key (Id_Cliente) REFERENCES [UMG].[Test].[Cientes](Id_Cliente);

--* Insertando Datos Manualmente a Tabla Clientes
Insert Into [Test].[Cientes] Values (00001,'Eddy','Hernández','41469099',1);
Insert Into [Test].[Cientes] Values (00002,'Magda','Alvizures','65897460',1);
Insert Into [Test].[Cientes] Values (00003,'Claudia','Colindres','54483097',1);
Insert Into [Test].[Cientes] Values (00004,'Hector','Alvizures','24386121',1);
Insert Into [Test].[Cientes] Values (00005,'Vicenta','Canel','23984510',0);


--* Validando Datos Insertados
Select *
From [Test].[Cientes];

--* Insertando Datos Manualmente a Tabla Cuenta
Insert Into [Test].[Cuenta] Values (1,2000.00,00001,1);
Insert Into [Test].[Cuenta] Values (2,2000.00,00001,1);
Insert Into [Test].[Cuenta] Values (3,2000.00,00001,1);
Insert Into [Test].[Cuenta] Values (4,2000.00,00001,1);
Insert Into [Test].[Cuenta] Values (5,2000.00,00001,1);


--*TRANSACCION EJEMPLO
--* Operacion [Deposito]

Begin Tran Deposito  --* El Analizador de Codigo Define el inicio de la Transaccion etiquetada con un nombre
 Update [Test].[Cuenta] --* Actualizacion de Tabla Cuenta (DML)
 Set Monto=(Monto+1200)   --* Actualizacion de Monto + un valor de Q1200.00
 Where Id_cliente=1     --* 1era Condición de validación cuando el cliente es = 1
 And   Status=1         --* 2da  Condición de validación cuando el status = 1
 Save Tran P1           --* Definimos un Punto de Control etiquetado (P1) por si existe alguna falla el el proceso
 Rollback Tran P1       --* Si existe una falla aplica una reversión al Punto de Control (P1)
 Commit Tran Deposito   --* Si todo esta Correcto entonces confirma,aplica los cambios hechos

 --* Consultamos los cambios efectuados en transaccion:

 Select *
 From [Test].[Cuenta];


 --* Operacion [Retiro]

Begin Tran Retiro         --* El Analizador de Codigo Define el inicio de la Transaccion etiquetada con un nombre RETIRO
 Update [Test].[Cuenta] --* Actualizacion de Tabla Cuenta (DML)
 Set Monto=Monto-1500   --* Actualizacion de Monto - un valor de Q1500.00
 Where Id_cliente=1     --* 1era Condición de validación cuando el cliente es = 1
 And   Status=1         --* 2da  Condición de validación cuando el status = 1
 And   Monto>1500       --* 3ra  Condicion de validación cuando el Monto> 1200
 Save Tran P2           --* Definimos un Punto de Control etiquetado (P2) por si existe alguna falla el el proceso
 Rollback Tran P2       --* Si existe una falla aplica una reversión al Punto de Control (P2)
 Commit Tran Retiro     --* Si todo esta Correcto entonces confirma,aplica los cambios hechos