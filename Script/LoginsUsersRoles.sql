
--CREACION lOGINS

CREATE LOGIN admin_gym WITH PASSWORD = 'Admin123*';
CREATE LOGIN recepcion1 WITH PASSWORD = 'Recep123*';
CREATE LOGIN trainer1 WITH PASSWORD = 'Trainer123*';
CREATE LOGIN cliente1 WITH PASSWORD = 'Cliente123*';
CREATE LOGIN gerencia1 WITH PASSWORD = 'Gerencia123*';
CREATE LOGIN auditor1 WITH PASSWORD = 'Auditor123*';

--Creacion de usuarios dentro de la base de datos

CREATE USER admin_gym FOR LOGIN admin_gym;
CREATE USER recepcion1 FOR LOGIN recepcion1;
CREATE USER trainer1 FOR LOGIN trainer1;
CREATE USER cliente1 FOR LOGIN cliente1;
CREATE USER gerencia1 FOR LOGIN gerencia1;
CREATE USER auditor1 FOR LOGIN auditor1;


-- Roles principales del sistema
CREATE ROLE Role_AdminGym;
CREATE ROLE Role_Recepcion;
CREATE ROLE Role_Entrenador;
CREATE ROLE Role_Cliente;
CREATE ROLE Role_Gerencia;
CREATE ROLE Role_ReadOnly;

--ASIGNAR ROLES A LOS USUARIOS


ALTER ROLE Role_AdminGym ADD MEMBER admin_gym;
ALTER ROLE Role_Recepcion ADD MEMBER recepcion1;
ALTER ROLE Role_Entrenador ADD MEMBER trainer1;
ALTER ROLE Role_Cliente ADD MEMBER cliente1;
ALTER ROLE Role_Gerencia ADD MEMBER gerencia1;
ALTER ROLE Role_ReadOnly ADD MEMBER auditor1;


--Role_AdminGym

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Role_AdminGym;


--Role_Recepcion
GRANT SELECT, INSERT, UPDATE ON Reserva TO Role_Recepcion;
GRANT SELECT, INSERT ON Pago TO Role_Recepcion;

GRANT SELECT ON Usuario TO Role_Recepcion;
GRANT SELECT ON Comentarios TO Role_Recepcion;

--Role_Entrenador
GRANT SELECT ON Usuario TO Role_Entrenador;
GRANT SELECT ON Reserva TO Role_Entrenador;
GRANT SELECT ON Comentarios TO Role_Entrenador;

--Role_Cliente
GRANT SELECT ON Comentarios TO Role_Cliente;
GRANT INSERT ON Comentarios TO Role_Cliente;

GRANT SELECT, INSERT ON Reserva TO Role_Cliente;

--Role_Gerencia
GRANT SELECT ON SCHEMA::dbo TO Role_Gerencia;

--Role_ReadOnly
GRANT SELECT ON SCHEMA::dbo TO Role_ReadOnly;




--CREAR USUARIO ESPECIAL PARA POWER BI

SELECT name
FROM sys.server_principals
WHERE name = 'PowerBIUser';


DROP LOGIN PowerBIUser;
GO
CREATE LOGIN PowerBIUser
WITH PASSWORD = 'Admin123*',
CHECK_POLICY = OFF;
GO
--


CREATE USER PowerBIUser FOR LOGIN PowerBIUser;

--CREATE ROLE PowerBI_ReadOnly;

ALTER ROLE PowerBI_ReadOnly ADD MEMBER PowerBIUser;

CREATE ROLE PowerBI_ReadOnly;

ALTER ROLE PowerBI_ReadOnly ADD MEMBER PowerBIUser;

SELECT name, type_desc
FROM sys.database_principals
WHERE name LIKE '%PowerBI%';

GRANT SELECT ON dbo.vw_PagosPorGym               TO PowerBI_ReadOnly;
GRANT SELECT ON dbo.vw_ResumenReservasPorUsuario TO PowerBI_ReadOnly;
GRANT SELECT ON dbo.vw_RankingIngresosGym        TO PowerBI_ReadOnly;
GRANT SELECT ON dbo.vw_HistorialEventos          TO PowerBI_ReadOnly;

EXECUTE AS USER = 'PowerBIUser';
SELECT * FROM dbo.vw_RankingIngresosGym;
REVERT;