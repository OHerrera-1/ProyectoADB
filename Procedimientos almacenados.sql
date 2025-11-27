USE ProyectoADB;
GO

----------------------------------------------------
-- PROSEDIMIENTOS DE LA TABLA PAGO
----------------------------------------------------

-- Insertar pago
IF OBJECT_ID('dbo.sp_InsertPago', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_InsertPago;
GO

CREATE PROCEDURE dbo.sp_InsertPago
    @id_usuario            INT,
    @id_gym                INT,
    @id_membresia          INT,
    @monto_pagado          DECIMAL(10,2),
    @fecha_inicio_vigencia DATE,
    @fecha_fin_vigencia    DATE,
    @estado_pago           NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar usuario
    IF NOT EXISTS (SELECT 1 FROM dbo.Usuario WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('El usuario no existe', 16, 1);
        RETURN;
    END;

    -- Validar gym
    IF NOT EXISTS (SELECT 1 FROM dbo.Gym WHERE id_gym = @id_gym)
    BEGIN
        RAISERROR('El gym no existe', 16, 1);
        RETURN;
    END;

    -- Validar membresia
    IF NOT EXISTS (SELECT 1 FROM dbo.Membresia WHERE id_membresia = @id_membresia)
    BEGIN
        RAISERROR('La membresia no existe', 16, 1);
        RETURN;
    END;

    -- Validar monto y fechas
    IF @monto_pagado <= 0
    BEGIN
        RAISERROR('El monto del pago debe ser mayor que cero', 16, 1);
        RETURN;
    END;

    IF @fecha_inicio_vigencia > @fecha_fin_vigencia
    BEGIN
        RAISERROR('La fecha de inicio de vigencia no puede ser mayor que la fecha de fin', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.Pago (
        id_usuario,
        id_gym,
        id_membresia,
        fecha_pago,
        monto_pagado,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        estado_pago
    )
    VALUES (
        @id_usuario,
        @id_gym,
        @id_membresia,
        GETDATE(),
        @monto_pagado,
        @fecha_inicio_vigencia,
        @fecha_fin_vigencia,
        @estado_pago
    );
END;
GO


-- Listar todos los pagos
IF OBJECT_ID('dbo.sp_ListPagos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ListPagos;
GO

CREATE PROCEDURE dbo.sp_ListPagos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id_pago,
        id_usuario,
        id_gym,
        id_membresia,
        fecha_pago,
        monto_pagado,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        estado_pago
    FROM dbo.Pago;
END;
GO


-- Listar pagos por usuario
IF OBJECT_ID('dbo.sp_ListPagosPorUsuario', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ListPagosPorUsuario;
GO

CREATE PROCEDURE dbo.sp_ListPagosPorUsuario
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar usuario
    IF NOT EXISTS (SELECT 1 FROM dbo.Usuario WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('El usuario no existe', 16, 1);
        RETURN;
    END;

    SELECT 
        p.id_pago,
        p.fecha_pago,
        p.monto_pagado,
        p.estado_pago,
        p.fecha_inicio_vigencia,
        p.fecha_fin_vigencia,
        m.nombre  AS nombre_membresia,
        g.id_gym  AS id_gym
    FROM dbo.Pago      p
    INNER JOIN dbo.Membresia m ON p.id_membresia = m.id_membresia
    INNER JOIN dbo.Gym       g ON p.id_gym       = g.id_gym
    WHERE p.id_usuario = @id_usuario
    ORDER BY p.fecha_pago DESC;
END;
GO


-- Listar pagos por rango de fechas
IF OBJECT_ID('dbo.sp_ListPagosPorRangoFechas', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ListPagosPorRangoFechas;
GO

CREATE PROCEDURE dbo.sp_ListPagosPorRangoFechas
    @fecha_inicio DATE,
    @fecha_fin    DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @fecha_inicio > @fecha_fin
    BEGIN
        RAISERROR('La fecha de inicio no puede ser mayor que la fecha final', 16, 1);
        RETURN;
    END;

    SELECT 
        p.id_pago,
        p.fecha_pago,
        p.monto_pagado,
        p.estado_pago,
        p.fecha_inicio_vigencia,
        p.fecha_fin_vigencia,
        u.id_usuario,
        u.nombre,
        u.apellido,
        m.nombre AS nombre_membresia
    FROM dbo.Pago      p
    INNER JOIN dbo.Usuario   u ON p.id_usuario   = u.id_usuario
    INNER JOIN dbo.Membresia m ON p.id_membresia = m.id_membresia
    WHERE CONVERT(DATE, p.fecha_pago) BETWEEN @fecha_inicio AND @fecha_fin
    ORDER BY p.fecha_pago DESC;
END;
GO


--procedimientos almacenados para la tabla membresia

--procedimiento sp_InsertMembresia
USE ProyectoADB;
GO

CREATE PROCEDURE sp_InsertMembresia
    @id_gym      INT,
    @nombre      NVARCHAR(200),
    @descripcion NVARCHAR(MAX) = NULL,
    @precio      DECIMAL(10,2),
    @duracion    INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar gym
    IF NOT EXISTS (SELECT 1 FROM Gym WHERE id_gym = @id_gym)
    BEGIN
        RAISERROR('El gym no existe', 16, 1);
        RETURN;
    END;

    INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
    VALUES (@id_gym, @nombre, @descripcion, @precio, @duracion);
END;
GO

--procedimiento sp_UpdateMembresia
CREATE PROCEDURE sp_UpdateMembresia
    @id_membresia INT,
    @id_gym       INT,
    @nombre       NVARCHAR(200),
    @descripcion  NVARCHAR(MAX) = NULL,
    @precio       DECIMAL(10,2),
    @duracion     INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que la membresia exista
    IF NOT EXISTS (SELECT 1 FROM Membresia WHERE id_membresia = @id_membresia)
    BEGIN
        RAISERROR('La membresia no existe', 16, 1);
        RETURN;
    END;

    -- Validar gym
    IF NOT EXISTS (SELECT 1 FROM Gym WHERE id_gym = @id_gym)
    BEGIN
        RAISERROR('El gym no existe', 16, 1);
        RETURN;
    END;

    UPDATE Membresia
    SET id_gym      = @id_gym,
        nombre      = @nombre,
        descripcion = @descripcion,
        precio      = @precio,
        duracion    = @duracion
    WHERE id_membresia = @id_membresia;
END;
GO

--procedimiento sp_DeleteMembresia
CREATE PROCEDURE sp_DeleteMembresia
    @id_membresia INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que la membresia exista
    IF NOT EXISTS (SELECT 1 FROM Membresia WHERE id_membresia = @id_membresia)
    BEGIN
        RAISERROR('La membresia no existe', 16, 1);
        RETURN;
    END;

    -- Validar que no tenga usuarios ni pagos asociados
    IF EXISTS (SELECT 1 FROM Usuario WHERE id_membresia = @id_membresia)
       OR EXISTS (SELECT 1 FROM Pago    WHERE id_membresia = @id_membresia)
    BEGIN
        RAISERROR('No se puede eliminar la membresia porque tiene usuarios o pagos asociados', 16, 1);
        RETURN;
    END;

    DELETE FROM Membresia
    WHERE id_membresia = @id_membresia;
END;
GO

--procedimiento sp_GetMembresiaById
CREATE PROCEDURE sp_GetMembresiaById
    @id_membresia INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_membresia,
           id_gym,
           nombre,
           descripcion,
           precio,
           duracion
    FROM Membresia
    WHERE id_membresia = @id_membresia;
END;
GO

--procedimiento sp_ListMembresias
CREATE PROCEDURE sp_ListMembresias
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_membresia,
           id_gym,
           nombre,
           descripcion,
           precio,
           duracion
    FROM Membresia;
END;
GO


EXEC sp_ListMembresias;


USE ProyectoADB;
GO

----------------------------------------------------
-- PROCEDIMIENTOS DE LA TABLA GYM
----------------------------------------------------

-- Insertar gym
IF OBJECT_ID('dbo.sp_InsertGym', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_InsertGym;
GO

CREATE PROCEDURE dbo.sp_InsertGym
    @nombre     NVARCHAR(200),
    @direccion  NVARCHAR(510) = NULL,
    @ciudad     NVARCHAR(200) = NULL,
    @pais       NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que no exista un gym igual (mismo nombre, ciudad y pais)
    IF EXISTS (
        SELECT 1
        FROM dbo.Gym
        WHERE nombre = @nombre
          AND ciudad = @ciudad
          AND pais   = @pais
    )
    BEGIN
        RAISERROR('Ya existe un gym con ese nombre en la misma ciudad y pais', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.Gym (nombre, direccion, ciudad, pais)
    VALUES (@nombre, @direccion, @ciudad, @pais);
END;
GO


-- Actualizar gym
IF OBJECT_ID('dbo.sp_UpdateGym', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_UpdateGym;
GO

CREATE PROCEDURE dbo.sp_UpdateGym
    @id_gym    INT,
    @nombre    NVARCHAR(200),
    @direccion NVARCHAR(510) = NULL,
    @ciudad    NVARCHAR(200) = NULL,
    @pais      NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el gym exista
    IF NOT EXISTS (SELECT 1 FROM dbo.Gym WHERE id_gym = @id_gym)
    BEGIN
        RAISERROR('El gym no existe', 16, 1);
        RETURN;
    END;

    -- Validar que no se duplique con otro gym
    IF EXISTS (
        SELECT 1
        FROM dbo.Gym
        WHERE nombre = @nombre
          AND ciudad = @ciudad
          AND pais   = @pais
          AND id_gym <> @id_gym
    )
    BEGIN
        RAISERROR('Ya existe otro gym con ese nombre en la misma ciudad y pais', 16, 1);
        RETURN;
    END;

    UPDATE dbo.Gym
    SET nombre    = @nombre,
        direccion = @direccion,
        ciudad    = @ciudad,
        pais      = @pais
    WHERE id_gym = @id_gym;
END;
GO


-- Eliminar gym
IF OBJECT_ID('dbo.sp_DeleteGym', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_DeleteGym;
GO

CREATE PROCEDURE dbo.sp_DeleteGym
    @id_gym INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el gym exista
    IF NOT EXISTS (SELECT 1 FROM dbo.Gym WHERE id_gym = @id_gym)
    BEGIN
        RAISERROR('El gym no existe', 16, 1);
        RETURN;
    END;

    -- Validar que no tenga informacion relacionada
    IF EXISTS (SELECT 1 FROM dbo.Area         WHERE id_gym = @id_gym) OR
       EXISTS (SELECT 1 FROM dbo.Comentarios  WHERE id_gym = @id_gym) OR
       EXISTS (SELECT 1 FROM dbo.Contacto_gym WHERE id_gym = @id_gym) OR
       EXISTS (SELECT 1 FROM dbo.Membresia    WHERE id_gym = @id_gym) OR
       EXISTS (SELECT 1 FROM dbo.Pago         WHERE id_gym = @id_gym)
    BEGIN
        RAISERROR('No se puede eliminar el gym porque tiene informacion relacionada (areas, comentarios, contactos, membresias o pagos)', 16, 1);
        RETURN;
    END;

    DELETE FROM dbo.Gym
    WHERE id_gym = @id_gym;
END;
GO


-- Obtener gym por id
IF OBJECT_ID('dbo.sp_GetGymById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetGymById;
GO

CREATE PROCEDURE dbo.sp_GetGymById
    @id_gym INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_gym,
           nombre,
           direccion,
           ciudad,
           pais
    FROM dbo.Gym
    WHERE id_gym = @id_gym;
END;
GO


-- Listar todos los gyms
IF OBJECT_ID('dbo.sp_ListGyms', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ListGyms;
GO

CREATE PROCEDURE dbo.sp_ListGyms
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_gym,
           nombre,
           direccion,
           ciudad,
           pais
    FROM dbo.Gym;
END;
GO

--prueba
EXEC dbo.sp_ListGyms;
-- o
EXEC dbo.sp_GetGymById @id_gym = 1;


--PROCEDIMIENTOS ALMACENADOS tabla Usuario

--Procedimiento Almacenado sp_InsertUsuario
USE ProyectoADB;
GO

CREATE PROCEDURE sp_InsertUsuario
    @id_membresia INT = NULL,
    @nombre       NVARCHAR(200),
    @apellido     NVARCHAR(200),
    @carnet       NVARCHAR(40),
    @rol          NVARCHAR(100) = NULL,
    @contrasena   NVARCHAR(510)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar membresia si se envia
    IF @id_membresia IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM Membresia WHERE id_membresia = @id_membresia)
    BEGIN
        RAISERROR('La membresia no existe', 16, 1);
        RETURN;
    END;

    -- Validar carnet unico
    IF EXISTS (SELECT 1 FROM Usuario WHERE carnet = @carnet)
    BEGIN
        RAISERROR('El carnet ya esta registrado', 16, 1);
        RETURN;
    END;

    INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
    VALUES (@id_membresia, @nombre, @apellido, @carnet, @rol, @contrasena);
END;
GO

--Procedimiento sp_UpdateUsuario
USE ProyectoADB;
GO

CREATE PROCEDURE sp_UpdateUsuario
    @id_usuario   INT,
    @id_membresia INT = NULL,
    @nombre       NVARCHAR(200),
    @apellido     NVARCHAR(200),
    @carnet       NVARCHAR(40),
    @rol          NVARCHAR(100) = NULL,
    @contrasena   NVARCHAR(510)
AS
BEGIN
    SET NOCOUNT ON;

    -- Valida que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('El usuario no existe', 16, 1);
        RETURN;
    END;

    -- Valida membresia si se envia
    IF @id_membresia IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM Membresia WHERE id_membresia = @id_membresia)
    BEGIN
        RAISERROR('La membresia no existe', 16, 1);
        RETURN;
    END;

    -- Valida carnet unico
    IF EXISTS (
        SELECT 1 
        FROM Usuario 
        WHERE carnet = @carnet
          AND id_usuario <> @id_usuario
    )
    BEGIN
        RAISERROR('El carnet ya esta registrado en otro usuario', 16, 1);
        RETURN;
    END;

    UPDATE Usuario
    SET id_membresia = @id_membresia,
        nombre       = @nombre,
        apellido     = @apellido,
        carnet       = @carnet,
        rol          = @rol,
        contrasena   = @contrasena
    WHERE id_usuario = @id_usuario;
END;
GO

--Procedimiento sp_DeleteUsuario
USE ProyectoADB;
GO

CREATE PROCEDURE sp_DeleteUsuario
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('El usuario no existe', 16, 1);
        RETURN;
    END;

    -- Validar que no tenga datos relacionados
    IF EXISTS (SELECT 1 FROM Comentarios      WHERE id_usuario = @id_usuario) OR
       EXISTS (SELECT 1 FROM Contacto_usuario WHERE id_usuario = @id_usuario) OR
       EXISTS (SELECT 1 FROM Historial        WHERE id_usuario = @id_usuario) OR
       EXISTS (SELECT 1 FROM Pago             WHERE id_usuario = @id_usuario) OR
       EXISTS (SELECT 1 FROM Reserva          WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('No se puede eliminar el usuario porque tiene informacion relacionada', 16, 1);
        RETURN;
    END;

    DELETE FROM Usuario
    WHERE id_usuario = @id_usuario;
END;
GO

--Procedimiento sp_GetUsuarioById
USE ProyectoADB;
GO

CREATE PROCEDURE sp_GetUsuarioById
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_usuario,
           id_membresia,
           nombre,
           apellido,
           carnet,
           rol,
           contrasena
    FROM Usuario
    WHERE id_usuario = @id_usuario;
END;
GO

--Procedimiento sp_ListUsuarios
USE ProyectoADB;
GO

CREATE PROCEDURE sp_ListUsuarios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_usuario,
           id_membresia,
           nombre,
           apellido,
           carnet,
           rol,
           contrasena
    FROM Usuario;
END;
GO


--PROCEDIMINETOS DE LA TABLA PAGOS

--Procedimiento sp_InsertPago
USE ProyectoADB;
GO


-- 2) Creamos de cero el procedimiento correcto
CREATE PROCEDURE dbo.sp_InsertPago
    @id_usuario            INT,
    @id_gym                INT,
    @id_membresia          INT,
    @monto_pagado          DECIMAL(10,2),
    @fecha_inicio_vigencia DATE,
    @fecha_fin_vigencia    DATE,
    @estado_pago           NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar usuario
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('El usuario no existe', 16, 1);
        RETURN;
    END;

    -- Validar gym
    IF NOT EXISTS (SELECT 1 FROM Gym WHERE id_gym = @id_gym)
    BEGIN
        RAISERROR('El gym no existe', 16, 1);
        RETURN;
    END;

    -- Validar membresia
    IF NOT EXISTS (SELECT 1 FROM Membresia WHERE id_membresia = @id_membresia)
    BEGIN
        RAISERROR('La membresia no existe', 16, 1);
        RETURN;
    END;

    -- Validar monto y fechas
    IF @monto_pagado <= 0
    BEGIN
        RAISERROR('El monto del pago debe ser mayor que cero', 16, 1);
        RETURN;
    END;

    IF @fecha_inicio_vigencia > @fecha_fin_vigencia
    BEGIN
        RAISERROR('La fecha de inicio de vigencia no puede ser mayor que la fecha de fin', 16, 1);
        RETURN;
    END;

    INSERT INTO Pago (
        id_usuario,
        id_gym,
        id_membresia,
        fecha_pago,
        monto_pagado,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        estado_pago
    )
    VALUES (
        @id_usuario,
        @id_gym,
        @id_membresia,
        GETDATE(),
        @monto_pagado,
        @fecha_inicio_vigencia,
        @fecha_fin_vigencia,
        @estado_pago
    );
END;
GO



-- Creamos el procedimiento
CREATE PROCEDURE dbo.sp_ListPagos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id_pago,
        id_usuario,
        id_gym,
        id_membresia,
        fecha_pago,
        monto_pagado,
        fecha_inicio_vigencia,
        fecha_fin_vigencia,
        estado_pago
    FROM Pago;
END;
GO


USE ProyectoADB;
GO

-- Insert de prueba (pon IDs que existan)
EXEC dbo.sp_InsertPago
    @id_usuario            = 1,
    @id_gym                = 1,
    @id_membresia          = 1,
    @monto_pagado          = 30.00,
    @fecha_inicio_vigencia = '2025-11-21',
    @fecha_fin_vigencia    = '2025-12-21',
    @estado_pago           = 'Pagado';
GO

-- Listar pagos
EXEC dbo.sp_ListPagos;
GO

--Procedimiento SP: listar pagos por usuario
USE ProyectoADB;
GO

IF OBJECT_ID('dbo.sp_ListPagosPorUsuario', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ListPagosPorUsuario;
GO

CREATE PROCEDURE dbo.sp_ListPagosPorUsuario
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar usuario
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('El usuario no existe', 16, 1);
        RETURN;
    END;

    SELECT 
        p.id_pago,
        p.fecha_pago,
        p.monto_pagado,
        p.estado_pago,
        p.fecha_inicio_vigencia,
        p.fecha_fin_vigencia,
        m.nombre  AS nombre_membresia,
        g.id_gym  AS id_gym
    FROM Pago p
    INNER JOIN Membresia m ON p.id_membresia = m.id_membresia
    INNER JOIN Gym       g ON p.id_gym       = g.id_gym
    WHERE p.id_usuario = @id_usuario
    ORDER BY p.fecha_pago DESC;
END;
GO

--prueba
EXEC dbo.sp_ListPagosPorUsuario @id_usuario = 1;

--Procedimiento SP: listar pagos por rango de fechas
USE ProyectoADB;
GO

IF OBJECT_ID('dbo.sp_ListPagosPorRangoFechas', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ListPagosPorRangoFechas;
GO

CREATE PROCEDURE dbo.sp_ListPagosPorRangoFechas
    @fecha_inicio DATE,
    @fecha_fin    DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @fecha_inicio > @fecha_fin
    BEGIN
        RAISERROR('La fecha de inicio no puede ser mayor que la fecha final', 16, 1);
        RETURN;
    END;

    SELECT 
        p.id_pago,
        p.fecha_pago,
        p.monto_pagado,
        p.estado_pago,
        p.fecha_inicio_vigencia,
        p.fecha_fin_vigencia,
        u.id_usuario,
        u.nombre,
        u.apellido,
        m.nombre AS nombre_membresia
    FROM Pago p
    INNER JOIN Usuario   u ON p.id_usuario   = u.id_usuario
    INNER JOIN Membresia m ON p.id_membresia = m.id_membresia
    WHERE CONVERT(DATE, p.fecha_pago) BETWEEN @fecha_inicio AND @fecha_fin
    ORDER BY p.fecha_pago DESC;
END;
GO

--prueba 
EXEC dbo.sp_ListPagosPorRangoFechas
    @fecha_inicio = '2025-11-01',
    @fecha_fin    = '2025-11-30';
