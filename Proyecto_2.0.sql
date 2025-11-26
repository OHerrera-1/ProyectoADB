-- SISTEMA DE GESTI�N DE GIMNASIOS
Create database Proyecto;
GO
USE Proyecto;
GO

CREATE TABLE Gym (
    id_gym INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    direccion NVARCHAR(255),
    ciudad NVARCHAR(100),
    pais NVARCHAR(100)
);

CREATE TABLE Contacto_gym (
    id_contacto INT IDENTITY(1,1) PRIMARY KEY,
    id_gym INT NOT NULL,
    telefono NVARCHAR(20),
    correo NVARCHAR(100),
    FOREIGN KEY (id_gym) REFERENCES Gym(id_gym)
);

CREATE TABLE Membresia (
    id_membresia INT IDENTITY(1,1) PRIMARY KEY,
    id_gym INT NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX),
    precio DECIMAL(10,2) NOT NULL,
    duracion INT NOT NULL,
    FOREIGN KEY (id_gym) REFERENCES Gym(id_gym)
);

CREATE TABLE Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    id_membresia INT,
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    carnet NVARCHAR(20) UNIQUE,
    rol NVARCHAR(50),
    contrasena NVARCHAR(255) NOT NULL,
    FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia)
);

CREATE TABLE Contacto_usuario (
    id_contacto_usuario INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    telefono NVARCHAR(20),
    email NVARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Area (
    id_area INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    id_gym INT NOT NULL,
    FOREIGN KEY (id_gym) REFERENCES Gym(id_gym)
);

CREATE TABLE Equipo (
    id_equipo INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    descripcion NVARCHAR(MAX)
);

CREATE TABLE Reserva (
    id_reserva INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    estado NVARCHAR(50),
    descripcion NVARCHAR(MAX),
    fecha_reserva DATETIME2 NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Extra (
    id_reserva INT NOT NULL,
    id_equipo INT NOT NULL,
    PRIMARY KEY (id_reserva, id_equipo),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo)
);

CREATE TABLE Comentarios (
    id_comentario INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_gym INT NOT NULL,
    comentario NVARCHAR(MAX),
    clasificacion INT,
    CONSTRAINT CHK_Clasificacion CHECK (clasificacion BETWEEN 1 AND 5),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_gym) REFERENCES Gym(id_gym)
);

CREATE TABLE Pago (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_gym INT NOT NULL,
    id_membresia INT NOT NULL,
    fecha_pago DATETIME2 NOT NULL DEFAULT GETDATE(),
    monto_pagado DECIMAL(10,2) NOT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL,
    estado_pago NVARCHAR(50) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_gym) REFERENCES Gym(id_gym),
    FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia)
);

CREATE TABLE Historial (
    id_historial INT IDENTITY(1,1) PRIMARY KEY,
    id_reserva INT,
    id_usuario INT,
    tipo_accion NVARCHAR(100),
    fecha_registro DATETIME2 DEFAULT GETDATE(),
    descripcion NVARCHAR(MAX),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);
-- Insertar gimnasios 

INSERT INTO Gym (nombre, direccion, ciudad, pais)
VALUES
('PowerFit', 'Avenida Las Magnolias #452', 'San Salvador', 'El Salvador'),
('Titanium Gym', 'Calle La Reforma #22', 'Santa Tecla', 'El Salvador'),
('Iron Club', 'Boulevard Los Pr�ceres #18', 'San Miguel', 'El Salvador'),
('MegaGym', 'Avenida Roosevelt #134', 'San Vicente', 'El Salvador'),
('BodyTech', 'Calle San Antonio Abad #56', 'San Salvador', 'El Salvador'),
('MuscleZone', 'Colonia Palmira, Boulevard Suyapa #10', 'Tegucigalpa', 'Honduras'),
('StrongLife', 'Residencial Los Robles, Calle Principal #8', 'Managua', 'Nicaragua'),
('FitArena', 'Avenida Central, Calle 7', 'San Jos�', 'Costa Rica'),
('TotalBody Gym', 'Calzada Roosevelt Zona 11', 'Guatemala City', 'Guatemala'),
('Energy Fitness', 'Avenida Balboa, Torre Ocean Business Plaza', 'Ciudad de Panam�', 'Panam�');
GO

---- Insertar contactos

INSERT INTO Contacto_gym (id_gym, telefono, correo)
VALUES
(1, '+503 7890-1122', 'contacto@powerfit.com.sv'),
(1, '+503 7721-8899', 'admin@powerfit.com.sv'),
(2, '+503 7654-2233', 'info@titaniumgym.com.sv'),
(2, '+503 7812-3344', 'soporte@titaniumgym.com.sv'),
(3, '+503 7012-5566', 'contact@ironclub.com.sv'),
(3, '+503 7923-7788', 'gerencia@ironclub.com.sv'),
(4, '+503 7412-9988', 'info@megagym.com.sv'),
(4, '+503 7690-4433', 'reservas@megagym.com.sv'),
(5, '+503 7800-6677', 'admin@bodytech.com.sv'),
(5, '+503 7955-9900', 'soporte@bodytech.com.sv'),
(6, '+504 9450-1223', 'info@musclezone.hn'),
(6, '+504 9543-8877', 'contacto@musclezone.hn'),
(7, '+505 8844-2211', 'contacto@stronglife.ni'),
(7, '+505 8765-9900', 'gerente@stronglife.ni'),
(8, '+506 7012-5566', 'info@fitarena.cr'),
(8, '+506 7113-7799', 'admin@fitarena.cr'),
(9, '+502 4433-2299', 'contacto@totalbody.gt'),
(9, '+502 5566-7788', 'soporte@totalbody.gt'),
(10, '+507 6612-3344', 'info@energyfitness.pa'),
(10, '+507 6900-5566', 'admin@energyfitness.pa');
GO

-- Insertar Membresias 

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(1, 'Normal', 'Acceso general a todas las �reas b�sicas del gimnasio.', 25.00, 30),
(1, 'Premium', 'Acceso total al gimnasio y clases grupales ilimitadas.', 45.00, 30),
(1, 'Internacional', 'Acceso a todos los gimnasios afiliados en Centroam�rica.', 65.00, 30),
(1, 'Ejecutivo', 'Incluye acceso a �reas restringidas y zona VIP.', 80.00, 30),
(1, 'Socio', 'Plan exclusivo para empleados del gimnasio.', 0.00, 30);

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(2, 'Normal', 'Acceso general al gimnasio y m�quinas b�sicas.', 20.00, 30),
(2, 'Premium', 'Acceso a todas las �reas y clases funcionales.', 40.00, 30),
(2, 'Internacional', 'Acceso a sucursales regionales afiliadas.', 60.00, 30),
(2, 'Socio', 'Plan para personal del gimnasio.', 0.00, 30);

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(3, 'Normal', 'Entrenamiento libre y asesor�a b�sica.', 22.00, 30),
(3, 'Premium', 'Incluye rutinas personalizadas y acceso completo.', 42.00, 30),
(3, 'Internacional', 'Acceso extendido a gimnasios aliados.', 60.00, 30),
(3, 'Ejecutivo', 'Acceso a sala privada, spa y entrenamiento VIP.', 75.00, 30),
(3, 'Socio', 'Plan interno para trabajadores.', 0.00, 30);

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(4, 'Normal', 'Acceso general y m�quinas de fuerza.', 18.00, 30),
(4, 'Premium', 'Acceso completo y clases de alto rendimiento.', 35.00, 30),
(4, 'Internacional', 'Acceso a todos los MegaGyms de la regi�n.', 55.00, 30);

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(5, 'Normal', 'Acceso general a �reas b�sicas del gimnasio.', 25.00, 30),
(5, 'Premium', 'Acceso total, incluye asesor�a y nutrici�n.', 45.00, 30),
(5, 'Internacional', 'Acceso en todos los BodyTech del pa�s.', 60.00, 30),
(5, 'Ejecutivo', 'Acceso a �rea restringida y entrenamiento VIP.', 80.00, 30),
(5, 'Socio', 'Plan gratuito exclusivo para trabajadores.', 0.00, 30);

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(6, 'Normal', 'Acceso general a m�quinas y cardio.', 23.00, 30),
(6, 'Premium', 'Acceso completo, sauna y clases funcionales.', 45.00, 30),
(6, 'Internacional', 'Acceso a gimnasios aliados de la regi�n.', 60.00, 30),
(6, 'Socio', 'Plan interno para empleados.', 0.00, 30);

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(7, 'Normal', 'Acceso general al gimnasio.', 20.00, 30),
(7, 'Premium', 'Acceso total y asesor�a personalizada.', 38.00, 30),
(7, 'Internacional', 'Acceso extendido en Centroam�rica.', 55.00, 30),
(7, 'Ejecutivo', 'Incluye acceso a salas restringidas y spa.', 70.00, 30),
(7, 'Socio', 'Plan laboral gratuito.', 0.00, 30);

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(8, 'Normal', 'Uso libre de m�quinas y zona de pesas.', 25.00, 30),
(8, 'Premium', 'Clases funcionales, box y entrenamiento personalizado.', 45.00, 30),
(8, 'Internacional', 'Acceso a sedes afiliadas en la regi�n.', 65.00, 30);

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(9, 'Normal', 'Acceso general a las �reas principales.', 21.00, 30),
(9, 'Premium', 'Acceso completo y clases ilimitadas.', 40.00, 30),
(9, 'Internacional', 'Acceso en todos los gimnasios TotalBody.', 60.00, 30),
(9, 'Ejecutivo', 'Acceso VIP con beneficios exclusivos.', 78.00, 30),
(9, 'Socio', 'Solo empleados del gimnasio.', 0.00, 30);

INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
VALUES
(10, 'Normal', 'Acceso general a m�quinas y cardio.', 28.00, 30),
(10, 'Premium', 'Acceso a todas las �reas, clases y asesor�a.', 48.00, 30),
(10, 'Internacional', 'Acceso internacional a sedes de Energy Fitness.', 70.00, 30),
(10, 'Ejecutivo', 'Acceso a �reas restringidas y servicios adicionales.', 90.00, 30);

--insersion de areas (Basandome en las membresias, las areas que ofrece y lo que cuesta)

-- �reas de los gimnasios
INSERT INTO Area (nombre, precio, id_gym)
VALUES
-- PowerFit (id_gym = 1)
('�rea de m�quinas b�sicas', 25.00, 1),
('Zona VIP', 35.00, 1),

-- Titanium Gym (id_gym = 2)
('�rea de fuerza y cardio', 20.00, 2),
('Clases funcionales', 20.00, 2),

-- Iron Club (id_gym = 3)
('Entrenamiento libre', 22.00, 3),
('Spa y zona VIP', 33.00, 3),

-- MegaGym (id_gym = 4)
('M�quinas de pesas', 18.00, 4),
('Clases de alto rendimiento', 17.00, 4),

-- BodyTech (id_gym = 5)
('�rea de m�quinas b�sicas y pesas', 25.00, 5),
('Zona VIP', 35.00, 5),

-- MuscleZone (id_gym = 6)
('�rea de m�quinas y cardio', 23.00, 6),
('Sauna y clases funcionales', 22.00, 6),

-- StrongLife (id_gym = 7)
('�rea general de pesas y maquinas', 20.00, 7),
('Sala restringida y spa', 32.00, 7),

-- FitArena (id_gym = 8)
('Zona de pesas y m�quinas', 25.00, 8),
('Clases funcionales y box', 20.00, 8),

-- TotalBody Gym (id_gym = 9)
('�rea principal de pesas', 21.00, 9),
('�rea VIP', 38.00, 9),

-- Energy Fitness (id_gym = 10)
('�rea de m�quinas, pesas y cardio', 28.00, 10),
('�rea restringida y servicios adicionales', 42.00, 10);

--equipo complementario a reservar para los entrenos
INSERT INTO Equipo (nombre, precio, descripcion)
VALUES
('Bandas de resistencia (set)', 5.00, 'Set de bandas el�sticas de diferentes tensiones para entrenamiento funcional'),
('Kettlebell 12 kg', 4.00, 'Kettlebell de 12 kg para swings, fuerza y cardio'),
('Pelota medicinal 6 kg', 3.50, 'Pelota medicinal de 6 kg para ejercicios de core, lanzamientos y movimientos din�micos'),
('Step aer�bico ajustable', 6.00, 'Plataforma de step con altura regulable para clases de cardio y funcional'),
('Rueda abdominal', 2.50, 'Rueda para ejercicios de core y estabilizaci�n'),
('Cuerda de saltar profesional', 2.00, 'Cuerda de velocidad para entrenamiento de salto y cardio'),
('TRX suspensi�n', 8.00, 'Sistema de suspensi�n para entrenamiento de peso corporal y funcional'),
('Rodillo de espuma (foam roller)', 2.00, 'Rodillo para recuperaci�n, estiramiento y liberaci�n miofascial'),
('Set mancuernas ajustables (5-15 kg)', 7.00, 'Par de mancuernas que se ajustan dentro de ese rango para entrenamiento libre'),
('Bosu Balance Trainer', 6.50, 'Medio bal�n de estabilidad para ejercicios de equilibrio y core');

-- GYM 1
INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(1, 'Jorge',       'Santos',       'JS001_1', 'Entrenador',     'Pass123!'),
(1, 'Elena',       'Peralta',      'EP002_2', 'Recepcionista',  'Pass123!'),
(1, 'Marco',       'Villalobos',   'MV003_3', 'Limpieza',       'Pass123!'),
(1, 'Claudia',     'N��ez',        'CN004_4', 'Administrador', 'Pass123!'),
(1, 'Pedro',       'Campos',       'PC005_5', 'Entrenador',     'Pass123!'),
(1, 'Ver�nica',    'M�ndez',       'VM006_6', 'Nutricionista',  'Pass123!'),
(1, 'Diego',       'Ramos',        'DR007_7', 'Mantenimiento', 'Pass123!'),
(1, 'Laura',       'Gonz�lez',     'LG008_8', 'Recepcionista',  'Pass123!'),
(1, 'Andr�s',      'P�rez',        'AP009_9', 'Entrenador',     'Pass123!'),
(1, 'Marisol',     'Ortiz',        'MO010_10', 'Limpieza',       'Pass123!'),
(1, 'Ricardo',     'Morales',      'RM011_11', 'Entrenador',     'Pass123!'),
(1, 'Patricia',    'Hern�ndez',    'PH012_12', 'Administrativo','Pass123!'),
(1, 'Fernando',    'Guti�rrez',    'FG013_13', 'Mantenimiento', 'Pass123!'),
(1, 'Carolina',    'Ruiz',         'CR014_14', 'Nutricionista',  'Pass123!'),
(1, 'Juli�n',      'Salazar',      'JS015_15', 'Entrenador',     'Pass123!');

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(1, 'Alejandro', 'Vargas',     'AV001_16', 'Cliente', 'Pwd123!'),
(2, 'Mariana',   'Lozano',      'ML002_17', 'Cliente', 'Pwd123!'),
(3, 'Ricardo',   'Navarro',     'RN003_18', 'Cliente', 'Pwd123!'),
(4, 'Patricia',  'Castillo',    'PC004_19', 'Cliente', 'Pwd123!'),
(5, 'Jorge',     'Molina',       'JM005_20', 'Cliente', 'Pwd123!'),
(2, 'Luc�a',     'S�nchez',     'LS006_21', 'Cliente', 'Pwd123!'),
(3, 'Fernando',  'G�mez',       'FG007_22', 'Cliente', 'Pwd123!'),
(1, 'Ver�nica',  'Paredes',     'VP008_23', 'Cliente', 'Pwd123!'),
(4, 'Andr�s',    'Flores',      'AF009_24', 'Cliente', 'Pwd123!'),
(5, 'Natalia',   'Rojas',       'NR010_25', 'Cliente', 'Pwd123!'),
(3, 'David',     'Mart�nez',    'DM011_26', 'Cliente', 'Pwd123!'),
(1, 'Sandra',    'Dom�nguez',   'SD012_27', 'Cliente', 'Pwd123!'),
(2, 'Carlos',    'Herrera',     'CH013_28', 'Cliente', 'Pwd123!'),
(5, 'M�nica',    'P�rez',       'MP014_29', 'Cliente', 'Pwd123!'),
(4, 'Javier',    'Ruiz',        'JR015_30', 'Cliente', 'Pwd123!'),
(1, 'Andrea',    'Cruz',        'AC016_31', 'Cliente', 'Pwd123!'),
(3, 'Luis',      'Ortiz',       'LO017_32', 'Cliente', 'Pwd123!'),
(2, 'Gabriela',  'Vega',        'GV018_33', 'Cliente', 'Pwd123!'),
(4, 'Mauricio',  'Fern�ndez',   'MF019_34', 'Cliente', 'Pwd123!'),
(5, 'Elena',     'Soto',        'ES020_35', 'Cliente', 'Pwd123!'),
(1, 'Hugo',      'Medina',      'HM021_36', 'Cliente', 'Pwd123!'),
(2, 'Isabel',    'Morales',     'IM022_37', 'Cliente', 'Pwd123!'),
(3, '�scar',     'Castro',      'OC023_38', 'Cliente', 'Pwd123!'),
(4, 'Karina',    'Reyes',       'KR024_39', 'Cliente', 'Pwd123!'),
(1, 'Rafael',    'Guerra',      'RG025_40', 'Cliente', 'Pwd123!'),
(5, 'Camila',    'Valle',       'CV026_41', 'Cliente', 'Pwd123!'),
(2, 'Manuel',    'Salinas',     'MS027_42', 'Cliente', 'Pwd123!'),
(3, 'Patricia',  'N��ez',       'PN028_43', 'Cliente', 'Pwd123!'),
(4, 'Diego',     'Rivas',       'DR029_44', 'Cliente', 'Pwd123!'),
(1, 'Maritza',   'Ayala',       'MA030_45', 'Cliente', 'Pwd123!'),
(5, 'Sebasti�n', 'Gonz�lez',    'SG031_46', 'Cliente', 'Pwd123!'),
(3, 'Yolanda',   'Ch�vez',      'YC032_47', 'Cliente', 'Pwd123!'),
(2, 'Eduardo',   'M�ndez',      'EM033_48', 'Cliente', 'Pwd123!'),
(4, 'Denise',    'Castellanos', 'DC034_49', 'Cliente', 'Pwd123!'),
(1, 'Oscar',     'Medrano',     'OM035_50', 'Cliente', 'Pwd123!'),
(5, 'Lorena',    'Vargas',      'LV036_51', 'Cliente', 'Pwd123!'),
(2, 'Mario',     'Barrios',     'MB037_52', 'Cliente', 'Pwd123!'),
(3, 'Claudia',   'Ju�rez',      'CJ038_53', 'Cliente', 'Pwd123!'),
(4, 'Ram�n',     'Pineda',      'RP039_54', 'Cliente', 'Pwd123!'),
(1, 'Liliana',   'Ramos',       'LR040_55', 'Cliente', 'Pwd123!'),
(5, 'Joaqu�n',   'Sandoval',    'JS041_56', 'Cliente', 'Pwd123!'),
(3, 'Viviana',   'Lopez',       'VL042_57', 'Cliente', 'Pwd123!'),
(2, 'Felipe',    'Tapia',       'FT043_58', 'Cliente', 'Pwd123!'),
(1, 'Adriana',   'G�mez',       'AG044_59', 'Cliente', 'Pwd123!'),
(4, 'Ricardo',   'Silva',       'RS045_60', 'Cliente', 'Pwd123!'),
(5, 'Raquel',    'R�os',        'RR046_61', 'Cliente', 'Pwd123!'),
(2, 'Gustavo',   'Fuentes',     'GF047_62', 'Cliente', 'Pwd123!'),
(3, 'Ver�nica',  'Pacheco',     'VP048_63', 'Cliente', 'Pwd123!'),
(1, 'Alejandra', 'Romero',      'AR049_64', 'Cliente', 'Pwd123!'),
(5, 'Sergio',    'Ortega',      'SO050_65', 'Cliente', 'Pwd123!'),
(2, 'Brenda',    'Luna',        'BL051_66', 'Cliente', 'Pwd123!'),
(3, 'H�ctor',    'Silva',       'HS052_67', 'Cliente', 'Pwd123!'),
(4, 'Elisa',     'Duarte',      'ED053_68', 'Cliente', 'Pwd123!'),
(1, 'Andr�s',    'Ram�rez',     'AR054_69', 'Cliente', 'Pwd123!'),
(5, 'Sof�a',     'Vargas',      'SV055_70', 'Cliente', 'Pwd123!'),
(3, 'V�ctor',    'Acosta',      'VA056_71', 'Cliente', 'Pwd123!'),
(2, 'Paola',     'Herrera',     'PH057_72', 'Cliente', 'Pwd123!'),
(4, 'Iv�n',      'Garc�a',      'IG058_73', 'Cliente', 'Pwd123!'),
(1, 'Daniela',   'Reyes',       'DR059_74', 'Cliente', 'Pwd123!'),
(5, 'Alberto',   'Molina',      'AM060_75', 'Cliente', 'Pwd123!'),
(2, 'Pamela',    'Carrillo',    'PC061_76', 'Cliente', 'Pwd123!'),
(3, 'Esteban',   'Ortiz',       'EO062_77', 'Cliente', 'Pwd123!'),
(4, 'Melissa',   'Vargas',      'MV063_78', 'Cliente', 'Pwd123!'),
(1, 'Hugo',      'Pe�a',        'HP064_79', 'Cliente', 'Pwd123!'),
(3, 'Yessica',   'Campos',      'YC065_80', 'Cliente', 'Pwd123!'),
(5, 'Mauricio',  'L�pez',       'ML066_81', 'Cliente', 'Pwd123!'),
(2, 'Carolina',  'V�zquez',     'CV067_82', 'Cliente', 'Pwd123!'),
(4, 'Rodrigo',   'Dom�nguez',   'RD068_83', 'Cliente', 'Pwd123!'),
(1, 'Fernanda',  'Rojas',       'FR069_84', 'Cliente', 'Pwd123!'),
(2, 'Diego',     'Hern�ndez',   'DH070_85', 'Cliente', 'Pwd123!'),
(3, 'Nora',      'Castillo',    'NC071_86', 'Cliente', 'Pwd123!'),
(4, 'Christian','S�nchez',     'CS072_87', 'Cliente', 'Pwd123!'),
(1, 'Sandra',    'Ruiz',        'SR073_88', 'Cliente', 'Pwd123!'),
(5, 'Ignacio',   'Maldonado',   'IM074_89', 'Cliente', 'Pwd123!'),
(3, 'Alicia',    'Flores',      'AF075_90', 'Cliente', 'Pwd123!'),
(2, 'Marco',     'P�rez',       'MP076_91', 'Cliente', 'Pwd123!'),
(4, 'Karina',    'G�mez',       'KG077_92', 'Cliente', 'Pwd123!'),
(1, 'Roberto',   'Jim�nez',     'RJ078_93', 'Cliente', 'Pwd123!'),
(5, 'Miranda',   'Quintero',    'MQ079_94', 'Cliente', 'Pwd123!'),
(3, 'Pablo',     'Osorio',      'PO080_95', 'Cliente', 'Pwd123!'),
(2, 'Gabriela',  'L�pez',       'GL081_96', 'Cliente', 'Pwd123!'),
(1, 'Rodolfo',   'Salazar',     'RS082_97', 'Cliente', 'Pwd123!'),
(4, 'Yolanda',   'M�ndez',      'YM083_98', 'Cliente', 'Pwd123!'),
(5, 'Orlando',   'Torres',      'OT084_99', 'Cliente', 'Pwd123!'),
(2, 'Ver�nica',  'Mart�nez',    'VM085_100', 'Cliente', 'Pwd123!'),
(3, 'Diego',     'Gonz�lez',    'DG086_101', 'Cliente', 'Pwd123!'),
(4, 'Clara',     'Hern�ndez',   'CH087_102', 'Cliente', 'Pwd123!'),
(1, 'Luis',      'Rivas',       'LR088_103', 'Cliente', 'Pwd123!'),
(5, 'Natalia',   'Mendoza',     'NM089_104', 'Cliente', 'Pwd123!'),
(3, 'Ernesto',   'Fuentes',     'EF090_105', 'Cliente', 'Pwd123!'),
(2, 'Viviana',   'Cardoza',     'VC091_106', 'Cliente', 'Pwd123!'),
(4, 'Jorge',     'Alvarado',    'JA092_107', 'Cliente', 'Pwd123!'),
(1, 'Luc�a',     'Arias',       'LA093_108', 'Cliente', 'Pwd123!'),
(3, 'Sebasti�n', 'Ram�rez',     'SR094_109', 'Cliente', 'Pwd123!'),
(2, 'Melissa',   'Guzm�n',      'MG095_110', 'Cliente', 'Pwd123!'),
(4, 'H�ctor',    'Vargas',      'HV096_111', 'Cliente', 'Pwd123!'),
(1, 'Adriana',   'Mor�n',       'AM097_112', 'Cliente', 'Pwd123!'),
(5, 'Fernando',  'Ortiz',       'FO098_113', 'Cliente', 'Pwd123!'),
(2, 'Ariana',    'Delgado',     'AD099_114', 'Cliente', 'Pwd123!'),
(3, 'Jes�s',     'Dom�nguez',   'JD100_115', 'Cliente', 'Pwd123!');

--Gym 2

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(6, 'Alejandro',  'Miranda',     'AM001_116', 'Entrenador',     'Pwd123!'),
(6, 'Beatriz',    'Carrera',      'BC002_117', 'Recepcionista',  'Pwd123!'),
(6, 'Carlos',     'D�az',         'CD003_118', 'Limpieza',       'Pwd123!'),
(6, 'Diana',      'Rivera',       'DR004_119', 'Administrador',  'Pwd123!'),
(6, 'Eduardo',    'Pacheco',      'EP005_120', 'Entrenador',     'Pwd123!'),
(6, 'Fernanda',   'Ortega',       'FO006_121', 'Nutricionista',  'Pwd123!'),
(6, 'Gustavo',    'Quintana',     'GQ007_122', 'Mantenimiento',  'Pwd123!'),
(6, 'Hilda',      'Su�rez',       'HS008_123', 'Recepcionista',  'Pwd123!'),
(6, 'Ignacio',    'Vega',         'IV009_124', 'Entrenador',     'Pwd123!'),
(6, 'Juliana',    'Zamora',       'JZ010_125', 'Entrenador',     'Pwd123!');

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(6,  'Ana',        'Garc�a',       'AG001_126', 'Cliente', 'Pwd123!'),
(7,  'Bruno',      'M�ndez',       'BM002_127', 'Cliente', 'Pwd123!'),
(8,  'Carla',      'Ramos',        'CR003_128', 'Cliente', 'Pwd123!'),
(9,  'Diego',      'Ortiz',        'DO004_129', 'Cliente', 'Pwd123!'),
(6,  'Elena',      'P�rez',        'EP005_130', 'Cliente', 'Pwd123!'),
(7,  'Fernando',   'Lozano',       'FL006_131', 'Cliente', 'Pwd123!'),
(8,  'Gabriela',   'Vega',         'GV007_132', 'Cliente', 'Pwd123!'),
(9,  'Hugo',       'Ram�rez',      'HR008_133', 'Cliente', 'Pwd123!'),
(6,  'Isabel',     'Soto',         'IS009_134', 'Cliente', 'Pwd123!'),
(7,  'Javier',     'Ruiz',         'JR010_135', 'Cliente', 'Pwd123!'),
(8,  'Karina',     'Vargas',       'KV011_136', 'Cliente', 'Pwd123!'),
(9,  'Luis',       'Medina',       'LM012_137', 'Cliente', 'Pwd123!'),
(6,  'Mar�a',      'Castillo',     'MC013_138', 'Cliente', 'Pwd123!'),
(7,  'N�stor',     'G�mez',        'NG014_139', 'Cliente', 'Pwd123!'),
(8,  'Olga',       'Dom�nguez',   'OD015_140', 'Cliente', 'Pwd123!'),
(9,  'Pablo',      'Herrera',      'PH016_141', 'Cliente', 'Pwd123!'),
(6,  'Quetzal',    'Flores',       'QF017_142', 'Cliente', 'Pwd123!'),
(7,  'Rosa',       'Jim�nez',      'RJ018_143', 'Cliente', 'Pwd123!'),
(8,  'Samuel',     'Silva',        'SS019_144', 'Cliente', 'Pwd123!'),
(9,  'Teresa',     'Maldonado',    'TM020_145', 'Cliente', 'Pwd123!'),
(6,  'Ulises',     'Pineda',       'UP021_146', 'Cliente', 'Pwd123!'),
(7,  'Valeria',    'Vargas',       'VV022_147', 'Cliente', 'Pwd123!'),
(8,  'Walter',     'Salinas',      'WS023_148', 'Cliente', 'Pwd123!'),
(9,  'Ximena',     'N��ez',        'XN024_149', 'Cliente', 'Pwd123!'),
(6,  'Yolanda',    'Reyes',        'YR025_150', 'Cliente', 'Pwd123!'),
(7,  'Zacar�as',   'Torres',       'ZT026_151', 'Cliente', 'Pwd123!'),
(8,  'Alejandra',  'Romero',       'AR027_152', 'Cliente', 'Pwd123!'),
(9,  'Benjam�n',   'Ortega',        'BO028_153', 'Cliente', 'Pwd123!'),
(6,  'Cristina',   'Guzm�n',       'CG029_154', 'Cliente', 'Pwd123!'),
(7,  'Daniel',     'Luna',         'DL030_155', 'Cliente', 'Pwd123!'),
(8,  'Estefan�a',  'Campos',       'EC031_156', 'Cliente', 'Pwd123!'),
(9,  'Felipe',     'Tapia',        'FT032_157', 'Cliente', 'Pwd123!'),
(6,  'Gloria',     'Santiago',     'GS033_158', 'Cliente', 'Pwd123!'),
(7,  'H�ctor',     'R�os',         'HR034_159', 'Cliente', 'Pwd123!'),
(8,  'Ivana',      'Fuentes',      'IF035_160', 'Cliente', 'Pwd123!'),
(9,  'Jorge',      'Alvarado',     'JA036_161', 'Cliente', 'Pwd123!'),
(6,  'Karla',      'Arias',        'KA037_162', 'Cliente', 'Pwd123!'),
(7,  'Leonardo',   'Salazar',      'LS038_163', 'Cliente', 'Pwd123!'),
(8,  'Marta',      'Mendoza',      'MM039_164', 'Cliente', 'Pwd123!'),
(9,  'Norberto',   'Fuentes',      'NF040_165', 'Cliente', 'Pwd123!'),
(6,  'Olivia',     'Cardoza',      'OC041_166', 'Cliente', 'Pwd123!'),
(7,  'Pedro',      'Gonz�lez',     'PG042_167', 'Cliente', 'Pwd123!'),
(8,  'Querida',    'Morales',      'QM043_168', 'Cliente', 'Pwd123!'),
(9,  'Rafael',     'Vega',         'RV044_169', 'Cliente', 'Pwd123!'),
(6,  'Sof�a',      'Luna',         'SL045_170', 'Cliente', 'Pwd123!'),
(7,  'Tom�s',      'Cruz',         'TC046_171', 'Cliente', 'Pwd123!'),
(8,  '�rsula',     'Hern�ndez',    'UH047_172', 'Cliente', 'Pwd123!'),
(9,  'Victor',     'Valle',        'VV048_173', 'Cliente', 'Pwd123!'),
(6,  'Wendy',      'Guti�rrez',     'WG049_174', 'Cliente', 'Pwd123!'),
(7,  'Xavier',     'Navarro',       'XN050_175', 'Cliente', 'Pwd123!'),
(8,  'Yadira',     'Espinoza',      'YE051_176', 'Cliente', 'Pwd123!'),
(9,  'Zulema',     'Castillo',      'ZC052_177', 'Cliente', 'Pwd123!'),
(6,  '�lvaro',     'Maldonado',      'AM053_178', 'Cliente', 'Pwd123!'),
(7,  'Brenda',     'Delgado',        'BD054_179', 'Cliente', 'Pwd123!'),
(8,  'C�sar',      'Quintanilla',    'CQ055_180', 'Cliente', 'Pwd123!'),
(9,  'Diana',      'Su�rez',          'DS056_181', 'Cliente', 'Pwd123!'),
(6,  'Erika',      'Ortiz',           'EO057_182', 'Cliente', 'Pwd123!'),
(7,  'Fernando',   'M�ndez',          'FM058_183', 'Cliente', 'Pwd123!'),
(8,  'Gabriela',   'Pacheco',         'GP059_184', 'Cliente', 'Pwd123!'),
(9,  'Horacio',    'Ram�rez',         'HR060_185', 'Cliente', 'Pwd123!'),
(6,  'Isabela',    'Santos',          'IS061_186', 'Cliente', 'Pwd123!'),
(7,  'Javier',     'Reyes',           'JR062_187', 'Cliente', 'Pwd123!'),
(8,  'Kenia',      'M�ndez',          'KM063_188', 'Cliente', 'Pwd123!'),
(9,  'Lorenzo',    'Rodr�guez',       'LR064_189', 'Cliente', 'Pwd123!'),
(6,  'Marina',     'Jim�nez',         'MJ065_190', 'Cliente', 'Pwd123!'),
(7,  'Nicol�s',    'Flores',          'NF066_191', 'Cliente', 'Pwd123!'),
(8,  'Olga',       'S�nchez',         'OS067_192', 'Cliente', 'Pwd123!'),
(9,  'Pablo',      'Dom�nguez',       'PD068_193', 'Cliente', 'Pwd123!'),
(6,  'Raquel',     'Vargas',          'RV069_194', 'Cliente', 'Pwd123!'),
(7,  'Santiago',   'Luna',            'SL070_195', 'Cliente', 'Pwd123!'),
(8,  'Teresa',     'Salazar',         'TS071_196', 'Cliente', 'Pwd123!'),
(9,  'Ulises',     'G�mez',           'UG072_197', 'Cliente', 'Pwd123!'),
(6,  'Valeria',    'Medina',          'VM073_198', 'Cliente', 'Pwd123!'),
(7,  'Willy',      'Pe�a',            'WP074_199', 'Cliente', 'Pwd123!'),
(8,  'Ximena',     'Campos',          'XC075_200', 'Cliente', 'Pwd123!'),
(9,  'Yuri',       'Soto',            'YS076_201', 'Cliente', 'Pwd123!'),
(6,  'Zacar�as',   'Morales',         'ZM077_202', 'Cliente', 'Pwd123!'),
(7,  'Adriana',    'Gonz�lez',        'AG078_203', 'Cliente', 'Pwd123!'),
(8,  'Blas',       'Hern�ndez',       'BH079_204', 'Cliente', 'Pwd123!'),
(9,  'Cecilia',    'Jim�nez',         'CJ080_205', 'Cliente', 'Pwd123!'),
(6,  'David',      'Navarro',          'DN081_206', 'Cliente', 'Pwd123!'),
(7,  'Estela',     'Duarte',           'ED082_207', 'Cliente', 'Pwd123!'),
(8,  'Francisco',  '�lvarez',          'FA083_208', 'Cliente', 'Pwd123!'),
(9,  'Gema',       'Rodr�guez',        'GR084_209', 'Cliente', 'Pwd123!'),
(6,  'Horacio',    'Mu�oz',            'HM085_210', 'Cliente', 'Pwd123!'),
(7,  'Irene',      'Torres',           'IT086_211', 'Cliente', 'Pwd123!'),
(8,  'Joel',       'Valle',            'JV087_212', 'Cliente', 'Pwd123!'),
(9,  'Karla',      'Vargas',           'KV088_213', 'Cliente', 'Pwd123!'),
(6,  'Leonor',     'Garc�a',           'LG089_214', 'Cliente', 'Pwd123!'),
(7,  'Mauro',      'Silva',            'MS090_215', 'Cliente', 'Pwd123!'),
(8,  'Nadia',      'R�os',             'NR091_216', 'Cliente', 'Pwd123!'),
(9,  '�scar',      'Castro',           'OC092_217', 'Cliente', 'Pwd123!'),
(6,  'Paula',      'Cruz',             'PC093_218', 'Cliente', 'Pwd123!'),
(7,  'Quintina',   'Vega',             'QV094_219', 'Cliente', 'Pwd123!'),
(8,  'Ricardo',    'Morales',          'RM095_220', 'Cliente', 'Pwd123!'),
(9,  'Sandra',     'Paredes',          'SP096_221', 'Cliente', 'Pwd123!'),
(6,  'Tom�s',      'Ortiz',            'TO097_222', 'Cliente', 'Pwd123!'),
(7,  '�rsula',     'Tapia',            'UT098_223', 'Cliente', 'Pwd123!'),
(8,  'V�ctor',     'Soto',             'VS099_224', 'Cliente', 'Pwd123!'),
(9,  'Wendy',      'Guti�rrez',        'WG100_225', 'Cliente', 'Pwd123!'),
(6,  'Xavier',     'Navarro',          'XN101_226', 'Cliente', 'Pwd123!'),
(7,  'Yadira',     'Espinoza',         'YE102_227', 'Cliente', 'Pwd123!'),
(8,  'Zulema',     'Castillo',         'ZC103_228', 'Cliente', 'Pwd123!'),
(9,  '�lvaro',     'Maldonado',         'AM104_229', 'Cliente', 'Pwd123!'),
(6,  'Brenda',     'Delgado',           'BD105_230', 'Cliente', 'Pwd123!'),
(7,  'C�sar',      'Quintanilla',       'CQ106_231', 'Cliente', 'Pwd123!'),
(8,  'Diana',      'Su�rez',             'DS107_232', 'Cliente', 'Pwd123!'),
(9,  'Erika',      'Ortiz',              'EO108_233', 'Cliente', 'Pwd123!'),
(6,  'Fernando',   'M�ndez',            'FM109_234', 'Cliente', 'Pwd123!'),
(7,  'Gabriela',   'Pacheco',           'GP110_235', 'Cliente', 'Pwd123!'),
(8,  'H�ctor',      'Ram�rez',           'HR111_236', 'Cliente', 'Pwd123!'),
(9,  'Isabela',    'Santos',            'IS112_237', 'Cliente', 'Pwd123!'),
(6,  'Javier',     'Reyes',             'JR113_238', 'Cliente', 'Pwd123!'),
(7,  'Kenia',      'M�ndez',            'KM114_239', 'Cliente', 'Pwd123!'),
(8,  'Lorenzo',    'Rodr�guez',         'LR115_240', 'Cliente', 'Pwd123!'),
(9,  'Marina',     'Jim�nez',           'MJ116_241', 'Cliente', 'Pwd123!'),
(6,  'Nicol�s',    'Flores',            'NF117_242', 'Cliente', 'Pwd123!'),
(7,  'Olga',       'S�nchez',           'OS118_243', 'Cliente', 'Pwd123!'),
(8,  'Pablo',      'Dom�nguez',         'PD119_244', 'Cliente', 'Pwd123!'),
(9,  'Raquel',     'Vargas',            'RV120_245', 'Cliente', 'Pwd123!');

--gym 3

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(10, 'Jorge',      'Ortiz',        'JO001_246', 'Entrenador',     'Pwd123!'),
(10, 'Ana',        'Rivera',       'AR002_247', 'Recepcionista',  'Pwd123!'),
(10, 'Carlos',     'Salinas',      'CS003_248', 'Limpieza',       'Pwd123!'),
(10, 'Mar�a',      'G�mez',        'MG004_249', 'Administrador',  'Pwd123!'),
(10, 'Fernando',   'Pacheco',      'FP005_250', 'Entrenador',     'Pwd123!'),
(10, 'Luc�a',      'Vargas',       'LV006_251', 'Nutricionista',  'Pwd123!'),
(10, 'Andr�s',     'M�ndez',       'AM007_252', 'Mantenimiento',  'Pwd123!'),
(10, 'Patricia',   'N��ez',        'PN008_253', 'Recepcionista',  'Pwd123!'),
(10, 'Ricardo',    'Morales',      'RM009_254', 'Entrenador',     'Pwd123!'),
(10, 'Sof�a',      'R�os',         'SR010_255', 'Administrativo','Pwd123!'),
(10, 'Diego',      'Torres',       'DT011_256', 'Mantenimiento',  'Pwd123!'),
(10, 'Carolina',   'Castillo',     'CC012_257', 'Nutricionista',  'Pwd123!');


INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(10, 'Ana',        'Garc�a',       'AG001_258', 'Cliente', 'Pwd123!'),
(11, 'Bruno',      'M�ndez',       'BM002_259', 'Cliente', 'Pwd123!'),
(12, 'Carla',      'Ramos',        'CR003_260', 'Cliente', 'Pwd123!'),
(13, 'Diego',      'Ortiz',        'DO004_261', 'Cliente', 'Pwd123!'),
(14, 'Elena',      'P�rez',        'EP005_262', 'Cliente', 'Pwd123!'),
(10, 'Fernando',   'Lozano',       'FL006_263', 'Cliente', 'Pwd123!'),
(11, 'Gabriela',   'Vega',         'GV007_264', 'Cliente', 'Pwd123!'),
(12, 'Hugo',       'Ram�rez',      'HR008_265', 'Cliente', 'Pwd123!'),
(13, 'Isabel',     'Soto',         'IS009_266', 'Cliente', 'Pwd123!'),
(14, 'Javier',     'Ruiz',         'JR010_267', 'Cliente', 'Pwd123!'),
(10, 'Karina',     'Vargas',       'KV011_268', 'Cliente', 'Pwd123!'),
(11, 'Luis',       'Medina',       'LM012_269', 'Cliente', 'Pwd123!'),
(12, 'Mar�a',      'Castillo',     'MC013_270', 'Cliente', 'Pwd123!'),
(13, 'N�stor',     'G�mez',        'NG014_271', 'Cliente', 'Pwd123!'),
(14, 'Olga',       'Dom�nguez',    'OD015_272', 'Cliente', 'Pwd123!'),
(10, 'Pablo',      'Herrera',      'PH016_273', 'Cliente', 'Pwd123!'),
(11, 'Quetzal',    'Flores',       'QF017_274', 'Cliente', 'Pwd123!'),
(12, 'Rosa',       'Jim�nez',      'RJ018_275', 'Cliente', 'Pwd123!'),
(13, 'Samuel',     'Silva',        'SS019_276', 'Cliente', 'Pwd123!'),
(14, 'Teresa',     'Maldonado',    'TM020_277', 'Cliente', 'Pwd123!'),
(10, 'Ulises',     'Pineda',       'UP021_278', 'Cliente', 'Pwd123!'),
(11, 'Valeria',    'Vargas',       'VV022_279', 'Cliente', 'Pwd123!'),
(12, 'Walter',     'Salinas',      'WS023_280', 'Cliente', 'Pwd123!'),
(13, 'Ximena',     'N��ez',        'XN024_281', 'Cliente', 'Pwd123!'),
(14, 'Yolanda',    'Reyes',        'YR025_282', 'Cliente', 'Pwd123!'),
(10, 'Zacar�as',   'Torres',       'ZT026_283', 'Cliente', 'Pwd123!'),
(11, 'Alejandra',  'Romero',       'AR027_284', 'Cliente', 'Pwd123!'),
(12, 'Benjam�n',   'Ortega',       'BO028_285', 'Cliente', 'Pwd123!'),
(13, 'Cristina',   'Guzm�n',       'CG029_286', 'Cliente', 'Pwd123!'),
(14, 'Daniel',     'Luna',         'DL030_287', 'Cliente', 'Pwd123!'),
(10, 'Estefan�a',  'Campos',       'EC031_288', 'Cliente', 'Pwd123!'),
(11, 'Felipe',     'Tapia',        'FT032_289', 'Cliente', 'Pwd123!'),
(12, 'Gloria',     'Santiago',     'GS033_290', 'Cliente', 'Pwd123!'),
(13, 'H�ctor',     'R�os',         'HR034_291', 'Cliente', 'Pwd123!'),
(14, 'Ivana',      'Fuentes',      'IF035_292', 'Cliente', 'Pwd123!'),
(10, 'Jorge',      'Alvarado',     'JA036_293', 'Cliente', 'Pwd123!'),
(11, 'Karla',      'Arias',        'KA037_294', 'Cliente', 'Pwd123!'),
(12, 'Leonardo',   'Salazar',      'LS038_295', 'Cliente', 'Pwd123!'),
(13, 'Marta',      'Mendoza',      'MM039_296', 'Cliente', 'Pwd123!'),
(14, 'Norberto',   'Fuentes',      'NF040_297', 'Cliente', 'Pwd123!'),
(10, 'Olivia',     'Cardoza',      'OC041_298', 'Cliente', 'Pwd123!'),
(11, 'Pedro',      'Gonz�lez',     'PG042_299', 'Cliente', 'Pwd123!'),
(12, 'Querida',    'Morales',      'QM043_300', 'Cliente', 'Pwd123!'),
(13, 'Rafael',     'Vega',         'RV044_301', 'Cliente', 'Pwd123!'),
(14, 'Sof�a',      'Luna',         'SL045_302', 'Cliente', 'Pwd123!'),
(10, 'Tom�s',      'Cruz',         'TC046_303', 'Cliente', 'Pwd123!'),
(11, '�rsula',     'Hern�ndez',    'UH047_304', 'Cliente', 'Pwd123!'),
(12, 'V�ctor',     'Valle',        'VV048_305', 'Cliente', 'Pwd123!'),
(13, 'Wendy',      'Guti�rrez',     'WG049_306', 'Cliente', 'Pwd123!'),
(14, 'Xavier',     'Navarro',       'XN050_307', 'Cliente', 'Pwd123!'),
(10, 'Yadira',     'Espinoza',      'YE051_308', 'Cliente', 'Pwd123!'),
(11, 'Zulema',     'Castillo',      'ZC052_309', 'Cliente', 'Pwd123!'),
(12, '�lvaro',     'Maldonado',      'AM053_310', 'Cliente', 'Pwd123!'),
(13, 'Brenda',     'Delgado',       'BD054_311', 'Cliente', 'Pwd123!'),
(14, 'C�sar',      'Quintanilla',   'CQ055_312', 'Cliente', 'Pwd123!'),
(10, 'Diana',      'Su�rez',         'DS056_313', 'Cliente', 'Pwd123!'),
(11, 'Erika',      'Ortiz',          'EO057_314', 'Cliente', 'Pwd123!'),
(12, 'Fernando',   'M�ndez',         'FM058_315', 'Cliente', 'Pwd123!'),
(13, 'Gabriela',   'Pacheco',         'GP059_316', 'Cliente', 'Pwd123!'),
(14, 'Horacio',    'Ram�rez',         'HR060_317', 'Cliente', 'Pwd123!'),
(10, 'Isabela',    'Santos',          'IS061_318', 'Cliente', 'Pwd123!'),
(11, 'Javier',     'Reyes',           'JR062_319', 'Cliente', 'Pwd123!'),
(12, 'Kenia',      'M�ndez',          'KM063_320', 'Cliente', 'Pwd123!'),
(13, 'Lorenzo',    'Rodr�guez',       'LR064_321', 'Cliente', 'Pwd123!'),
(14, 'Marina',     'Jim�nez',         'MJ065_322', 'Cliente', 'Pwd123!'),
(10, 'Nicol�s',    'Flores',          'NF066_323', 'Cliente', 'Pwd123!'),
(11, 'Olga',       'S�nchez',         'OS067_324', 'Cliente', 'Pwd123!'),
(12, 'Pablo',      'Dom�nguez',       'PD068_325', 'Cliente', 'Pwd123!'),
(13, 'Raquel',     'Vargas',           'RV069_326', 'Cliente', 'Pwd123!'),
(14, 'Santiago',   'Luna',             'SL070_327', 'Cliente', 'Pwd123!'),
(10, 'Teresa',     'Salazar',         'TS071_328', 'Cliente', 'Pwd123!'),
(11, 'Ulises',     'G�mez',           'UG072_329', 'Cliente', 'Pwd123!'),
(12, 'Valeria',    'Medina',          'VM073_330', 'Cliente', 'Pwd123!'),
(13, 'Willy',      'Pe�a',            'WP074_331', 'Cliente', 'Pwd123!'),
(14, 'Ximena',     'Campos',          'XC075_332', 'Cliente', 'Pwd123!'),
(10, 'Yuri',       'Soto',             'YS076_333', 'Cliente', 'Pwd123!'),
(11, 'Zacar�as',   'Morales',          'ZM077_334', 'Cliente', 'Pwd123!'),
(12, 'Adriana',    'Gonz�lez',        'AG078_335', 'Cliente', 'Pwd123!'),
(13, 'Blas',       'Hern�ndez',       'BH079_336', 'Cliente', 'Pwd123!'),
(14, 'Cecilia',    'Jim�nez',         'CJ080_337', 'Cliente', 'Pwd123!');


--gym 4

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(15, 'Alejandro',  'Mart�nez',     'AM001_338', 'Entrenador',     'Pwd123!'),
(15, 'Beatriz',    'Garc�a',        'BG002_339', 'Recepcionista',  'Pwd123!'),
(15, 'Carlos',     'Ram�rez',       'CR003_340', 'Limpieza',       'Pwd123!'),
(15, 'Diana',      'S�nchez',       'DS004_341', 'Administrador',  'Pwd123!'),
(15, 'Eduardo',    'Vargas',        'EV005_342', 'Entrenador',     'Pwd123!'),
(15, 'Fernanda',   'Ortiz',         'FO006_343', 'Nutricionista',  'Pwd123!'),
(15, 'Gustavo',    'P�rez',         'GP007_344', 'Mantenimiento',  'Pwd123!'),
(15, 'Hilda',      'M�ndez',        'HM008_345', 'Recepcionista',  'Pwd123!'),
(15, 'Ignacio',    'Ruiz',          'IR009_346', 'Entrenador',     'Pwd123!'),
(15, 'Juliana',    'Torres',        'JT010_347', 'Entrenador',     'Pwd123!'),
(15, 'Karla',      'Silva',         'KS011_348', 'Nutricionista',  'Pwd123!'),
(15, 'Leonardo',   'N��ez',         'LN012_349', 'Mantenimiento',  'Pwd123!');


INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(15, 'Ana',        'Garc�a',       'AG001_350', 'Cliente', 'Pwd123!'),
(16, 'Bruno',      'M�ndez',       'BM002_351', 'Cliente', 'Pwd123!'),
(17, 'Carla',      'Ramos',        'CR003_352', 'Cliente', 'Pwd123!'),
(15, 'Diego',      'Ortiz',        'DO004_353', 'Cliente', 'Pwd123!'),
(16, 'Elena',      'P�rez',        'EP005_354', 'Cliente', 'Pwd123!'),
(17, 'Fernando',   'Lozano',       'FL006_355', 'Cliente', 'Pwd123!'),
(15, 'Gabriela',   'Vega',         'GV007_356', 'Cliente', 'Pwd123!'),
(16, 'Hugo',       'Ram�rez',      'HR008_357', 'Cliente', 'Pwd123!'),
(17, 'Isabel',     'Soto',         'IS009_358', 'Cliente', 'Pwd123!'),
(15, 'Javier',     'Ruiz',         'JR010_359', 'Cliente', 'Pwd123!'),
(16, 'Karina',     'Vargas',       'KV011_360', 'Cliente', 'Pwd123!'),
(17, 'Luis',       'Medina',       'LM012_361', 'Cliente', 'Pwd123!'),
(15, 'Mar�a',      'Castillo',     'MC013_362', 'Cliente', 'Pwd123!'),
(16, 'N�stor',     'G�mez',        'NG014_363', 'Cliente', 'Pwd123!'),
(17, 'Olga',       'Dom�nguez',    'OD015_364', 'Cliente', 'Pwd123!'),
(15, 'Pablo',      'Herrera',      'PH016_365', 'Cliente', 'Pwd123!'),
(16, 'Quetzal',    'Flores',       'QF017_366', 'Cliente', 'Pwd123!'),
(17, 'Rosa',       'Jim�nez',      'RJ018_367', 'Cliente', 'Pwd123!'),
(15, 'Samuel',     'Silva',        'SS019_368', 'Cliente', 'Pwd123!'),
(16, 'Teresa',     'Maldonado',    'TM020_369', 'Cliente', 'Pwd123!'),
(17, 'Ulises',     'Pineda',       'UP021_370', 'Cliente', 'Pwd123!'),
(15, 'Valeria',    'Vargas',       'VV022_371', 'Cliente', 'Pwd123!'),
(16, 'Walter',     'Salinas',      'WS023_372', 'Cliente', 'Pwd123!'),
(17, 'Ximena',     'N��ez',        'XN024_373', 'Cliente', 'Pwd123!'),
(15, 'Yolanda',    'Reyes',        'YR025_374', 'Cliente', 'Pwd123!'),
(16, 'Zacar�as',   'Torres',       'ZT026_375', 'Cliente', 'Pwd123!'),
(17, 'Alejandra',  'Romero',       'AR027_376', 'Cliente', 'Pwd123!'),
(15, 'Benjam�n',   'Ortega',       'BO028_377', 'Cliente', 'Pwd123!'),
(16, 'Cristina',   'Guzm�n',       'CG029_378', 'Cliente', 'Pwd123!'),
(17, 'Daniel',     'Luna',         'DL030_379', 'Cliente', 'Pwd123!'),
(15, 'Estefan�a',  'Campos',       'EC031_380', 'Cliente', 'Pwd123!'),
(16, 'Felipe',     'Tapia',        'FT032_381', 'Cliente', 'Pwd123!'),
(17, 'Gloria',     'Santiago',     'GS033_382', 'Cliente', 'Pwd123!'),
(15, 'H�ctor',     'R�os',         'HR034_383', 'Cliente', 'Pwd123!'),
(16, 'Ivana',      'Fuentes',      'IF035_384', 'Cliente', 'Pwd123!'),
(17, 'Jorge',      'Alvarado',     'JA036_385', 'Cliente', 'Pwd123!'),
(15, 'Karla',      'Arias',        'KA037_386', 'Cliente', 'Pwd123!'),
(16, 'Leonardo',   'Salazar',      'LS038_387', 'Cliente', 'Pwd123!'),
(17, 'Marta',      'Mendoza',      'MM039_388', 'Cliente', 'Pwd123!'),
(15, 'Norberto',   'Fuentes',      'NF040_389', 'Cliente', 'Pwd123!'),
(16, 'Olivia',     'Cardoza',      'OC041_390', 'Cliente', 'Pwd123!'),
(17, 'Pedro',      'Gonz�lez',     'PG042_391', 'Cliente', 'Pwd123!'),
(15, 'Querida',    'Morales',      'QM043_392', 'Cliente', 'Pwd123!'),
(16, 'Rafael',     'Vega',         'RV044_393', 'Cliente', 'Pwd123!'),
(17, 'Sof�a',      'Luna',         'SL045_394', 'Cliente', 'Pwd123!'),
(15, 'Tom�s',      'Cruz',         'TC046_395', 'Cliente', 'Pwd123!'),
(16, '�rsula',     'Hern�ndez',    'UH047_396', 'Cliente', 'Pwd123!'),
(17, 'V�ctor',     'Valle',        'VV048_397', 'Cliente', 'Pwd123!'),
(15, 'Wendy',      'Guti�rrez',     'WG049_398', 'Cliente', 'Pwd123!'),
(16, 'Xavier',     'Navarro',       'XN050_399', 'Cliente', 'Pwd123!'),
(17, 'Yadira',     'Espinoza',      'YE051_400', 'Cliente', 'Pwd123!'),
(15, 'Zulema',     'Castillo',      'ZC052_401', 'Cliente', 'Pwd123!'),
(16, '�lvaro',     'Maldonado',      'AM053_402', 'Cliente', 'Pwd123!'),
(17, 'Brenda',     'Delgado',       'BD054_403', 'Cliente', 'Pwd123!'),
(15, 'C�sar',      'Quintanilla',   'CQ055_404', 'Cliente', 'Pwd123!'),
(16, 'Diana',      'Su�rez',         'DS056_405', 'Cliente', 'Pwd123!'),
(17, 'Erika',      'Ortiz',          'EO057_406', 'Cliente', 'Pwd123!'),
(15, 'Fernando',   'M�ndez',         'FM058_407', 'Cliente', 'Pwd123!'),
(16, 'Gabriela',   'Pacheco',         'GP059_408', 'Cliente', 'Pwd123!'),
(17, 'Horacio',    'Ram�rez',         'HR060_409', 'Cliente', 'Pwd123!'),
(15, 'Isabela',    'Santos',          'IS061_410', 'Cliente', 'Pwd123!'),
(16, 'Javier',     'Reyes',           'JR062_411', 'Cliente', 'Pwd123!'),
(17, 'Kenia',      'M�ndez',          'KM063_412', 'Cliente', 'Pwd123!'),
(15, 'Lorenzo',    'Rodr�guez',       'LR064_413', 'Cliente', 'Pwd123!'),
(16, 'Marina',     'Jim�nez',         'MJ065_414', 'Cliente', 'Pwd123!'),
(17, 'Nicol�s',    'Flores',          'NF066_415', 'Cliente', 'Pwd123!'),
(15, 'Olga',       'S�nchez',         'OS067_416', 'Cliente', 'Pwd123!'),
(16, 'Pablo',      'Dom�nguez',       'PD068_417', 'Cliente', 'Pwd123!'),
(17, 'Raquel',     'Vargas',            'RV069_418', 'Cliente', 'Pwd123!'),
(15, 'Santiago',   'Luna',             'SL070_419', 'Cliente', 'Pwd123!'),
(16, 'Teresa',     'Salazar',         'TS071_420', 'Cliente', 'Pwd123!'),
(17, 'Ulises',     'G�mez',           'UG072_421', 'Cliente', 'Pwd123!'),
(15, 'Valeria',    'Medina',          'VM073_422', 'Cliente', 'Pwd123!'),
(16, 'Willy',      'Pe�a',            'WP074_423', 'Cliente', 'Pwd123!'),
(17, 'Ximena',     'Campos',          'XC075_424', 'Cliente', 'Pwd123!'),
(15, 'Yuri',       'Soto',             'YS076_425', 'Cliente', 'Pwd123!'),
(16, 'Zacar�as',   'Morales',          'ZM077_426', 'Cliente', 'Pwd123!'),
(17, 'Adriana',    'Gonz�lez',        'AG078_427', 'Cliente', 'Pwd123!'),
(15, 'Blas',       'Hern�ndez',       'BH079_428', 'Cliente', 'Pwd123!'),
(16, 'Cecilia',    'Jim�nez',         'CJ080_429', 'Cliente', 'Pwd123!'),
(17, 'David',      'Navarro',          'DN081_430', 'Cliente', 'Pwd123!'),
(15, 'Estela',     'Duarte',           'ED082_431', 'Cliente', 'Pwd123!'),
(16, 'Francisco',  '�lvarez',          'FA083_432', 'Cliente', 'Pwd123!'),
(17, 'Gema',       'Rodr�guez',        'GR084_433', 'Cliente', 'Pwd123!'),
(15, 'Horacio',    'Mu�oz',            'HM085_434', 'Cliente', 'Pwd123!'),
(16, 'Irene',      'Torres',           'IT086_435', 'Cliente', 'Pwd123!'),
(17, 'Joel',       'Valle',            'JV087_436', 'Cliente', 'Pwd123!'),
(15, 'Karla',      'Vargas',           'KV088_437', 'Cliente', 'Pwd123!'),
(16, 'Leonor',     'Garc�a',           'LG089_438', 'Cliente', 'Pwd123!'),
(17, 'Mauro',      'Silva',            'MS090_439', 'Cliente', 'Pwd123!'),
(15, 'Nadia',      'R�os',             'NR091_440', 'Cliente', 'Pwd123!'),
(16, '�scar',      'Castro',           'OC092_441', 'Cliente', 'Pwd123!'),
(17, 'Paula',      'Cruz',             'PC093_442', 'Cliente', 'Pwd123!'),
(15, 'Quintina',   'Vega',             'QV094_443', 'Cliente', 'Pwd123!'),
(16, 'Ricardo',    'Morales',          'RM095_444', 'Cliente', 'Pwd123!'),
(17, 'Sandra',     'Paredes',          'SP096_445', 'Cliente', 'Pwd123!'),
(15, 'Tom�s',      'Ortiz',            'TO097_446', 'Cliente', 'Pwd123!'),
(16, '�rsula',     'Tapia',            'UT098_447', 'Cliente', 'Pwd123!'),
(17, 'V�ctor',     'Soto',             'VS099_448', 'Cliente', 'Pwd123!'),
(15, 'Wendy',      'Guti�rrez',        'WG100_449', 'Cliente', 'Pwd123!');



--gym 5
INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(18, 'Andr�s',     'Mora',        'AM001_450', 'Entrenador',     'Pwd123!'),
(18, 'Beatriz',    'Castro',      'BC002_451', 'Recepcionista',  'Pwd123!'),
(18, 'Carlos',     'Jim�nez',     'CJ003_452', 'Limpieza',       'Pwd123!'),
(18, 'Diana',      'Hern�ndez',   'DH004_453', 'Administrador',  'Pwd123!'),
(18, 'Eduardo',    'Vargas',      'EV005_454', 'Entrenador',     'Pwd123!'),
(18, 'Fernanda',   'Ortega',      'FO006_455', 'Nutricionista',  'Pwd123!'),
(18, 'Gustavo',    'Pacheco',     'GP007_456', 'Mantenimiento',  'Pwd123!'),
(18, 'Hilda',      'Su�rez',      'HS008_457', 'Recepcionista',  'Pwd123!'),
(18, 'Ignacio',    'Ruiz',        'IR009_458', 'Entrenador',     'Pwd123!'),
(18, 'Juliana',    'Torres',      'JT010_459', 'Nutricionista',  'Pwd123!');

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(18, 'Ana',        'Garc�a',        'AG001_460', 'Cliente', 'Pwd123!'),
(19, 'Bruno',      'M�ndez',        'BM002_461', 'Cliente', 'Pwd123!'),
(20, 'Carla',      'Ramos',         'CR003_462', 'Cliente', 'Pwd123!'),
(21, 'Diego',      'Ortiz',         'DO004_463', 'Cliente', 'Pwd123!'),
(22, 'Elena',      'P�rez',         'EP005_464', 'Cliente', 'Pwd123!'),
(18, 'Fernando',   'Lozano',        'FL006_465', 'Cliente', 'Pwd123!'),
(19, 'Gabriela',   'Vega',          'GV007_466', 'Cliente', 'Pwd123!'),
(20, 'Hugo',       'Ram�rez',       'HR008_467', 'Cliente', 'Pwd123!'),
(21, 'Isabel',     'Soto',          'IS009_468', 'Cliente', 'Pwd123!'),
(22, 'Javier',     'Ruiz',          'JR010_469', 'Cliente', 'Pwd123!'),
(18, 'Karina',     'Vargas',        'KV011_470', 'Cliente', 'Pwd123!'),
(19, 'Luis',       'Medina',        'LM012_471', 'Cliente', 'Pwd123!'),
(20, 'Mar�a',      'Castillo',      'MC013_472', 'Cliente', 'Pwd123!'),
(21, 'N�stor',     'G�mez',         'NG014_473', 'Cliente', 'Pwd123!'),
(22, 'Olga',       'Dom�nguez',     'OD015_474', 'Cliente', 'Pwd123!'),
(18, 'Pablo',      'Herrera',       'PH016_475', 'Cliente', 'Pwd123!'),
(19, 'Quetzal',    'Flores',        'QF017_476', 'Cliente', 'Pwd123!'),
(20, 'Rosa',       'Jim�nez',       'RJ018_477', 'Cliente', 'Pwd123!'),
(21, 'Samuel',     'Silva',         'SS019_478', 'Cliente', 'Pwd123!'),
(22, 'Teresa',     'Maldonado',     'TM020_479', 'Cliente', 'Pwd123!'),
(18, 'Ulises',     'Pineda',        'UP021_480', 'Cliente', 'Pwd123!'),
(19, 'Valeria',    'Vargas',        'VV022_481', 'Cliente', 'Pwd123!'),
(20, 'Walter',     'Salinas',        'WS023_482', 'Cliente', 'Pwd123!'),
(21, 'Ximena',     'N��ez',         'XN024_483', 'Cliente', 'Pwd123!'),
(22, 'Yolanda',    'Reyes',         'YR025_484', 'Cliente', 'Pwd123!'),
(18, 'Zacar�as',   'Torres',        'ZT026_485', 'Cliente', 'Pwd123!'),
(19, 'Alejandra',  'Romero',        'AR027_486', 'Cliente', 'Pwd123!'),
(20, 'Benjam�n',   'Ortega',        'BO028_487', 'Cliente', 'Pwd123!'),
(21, 'Cristina',   'Guzm�n',        'CG029_488', 'Cliente', 'Pwd123!'),
(22, 'Daniel',     'Luna',          'DL030_489', 'Cliente', 'Pwd123!'),
(18, 'Estefan�a',  'Campos',        'EC031_490', 'Cliente', 'Pwd123!'),
(19, 'Felipe',     'Tapia',         'FT032_491', 'Cliente', 'Pwd123!'),
(20, 'Gloria',     'Santiago',      'GS033_492', 'Cliente', 'Pwd123!'),
(21, 'H�ctor',     'R�os',          'HR034_493', 'Cliente', 'Pwd123!'),
(22, 'Ivana',      'Fuentes',       'IF035_494', 'Cliente', 'Pwd123!'),
(18, 'Jorge',      'Alvarado',      'JA036_495', 'Cliente', 'Pwd123!'),
(19, 'Karla',      'Arias',         'KA037_496', 'Cliente', 'Pwd123!'),
(20, 'Leonardo',   'Salazar',       'LS038_497', 'Cliente', 'Pwd123!'),
(21, 'Marta',      'Mendoza',       'MM039_498', 'Cliente', 'Pwd123!'),
(22, 'Norberto',   'Fuentes',       'NF040_499', 'Cliente', 'Pwd123!'),
(18, 'Olivia',     'Cardoza',       'OC041_500', 'Cliente', 'Pwd123!'),
(19, 'Pedro',      'Gonz�lez',      'PG042_501', 'Cliente', 'Pwd123!'),
(20, 'Querida',    'Morales',        'QM043_502', 'Cliente', 'Pwd123!'),
(21, 'Rafael',     'Vega',           'RV044_503', 'Cliente', 'Pwd123!'),
(22, 'Sof�a',      'Luna',           'SL045_504', 'Cliente', 'Pwd123!'),
(18, 'Tom�s',      'Cruz',           'TC046_505', 'Cliente', 'Pwd123!'),
(19, '�rsula',     'Hern�ndez',       'UH047_506', 'Cliente', 'Pwd123!'),
(20, 'V�ctor',     'Valle',            'VV048_507', 'Cliente', 'Pwd123!'),
(21, 'Wendy',      'Guti�rrez',        'WG049_508', 'Cliente', 'Pwd123!'),
(22, 'Xavier',     'Navarro',           'XN050_509', 'Cliente', 'Pwd123!'),
(18, 'Yadira',     'Espinoza',          'YE051_510', 'Cliente', 'Pwd123!'),
(19, 'Zulema',     'Castillo',          'ZC052_511', 'Cliente', 'Pwd123!'),
(20, '�lvaro',     'Maldonado',          'AM053_512', 'Cliente', 'Pwd123!'),
(21, 'Brenda',     'Delgado',            'BD054_513', 'Cliente', 'Pwd123!'),
(22, 'C�sar',      'Quintanilla',        'CQ055_514', 'Cliente', 'Pwd123!'),
(18, 'Diana',      'Su�rez',              'DS056_515', 'Cliente', 'Pwd123!'),
(19, 'Erika',      'Ortiz',                'EO057_516', 'Cliente', 'Pwd123!'),
(20, 'Fernando',   'M�ndez',               'FM058_517', 'Cliente', 'Pwd123!'),
(21, 'Gabriela',   'Pacheco',               'GP059_518', 'Cliente', 'Pwd123!'),
(22, 'Horacio',    'Ram�rez',               'HR060_519', 'Cliente', 'Pwd123!'),
(18, 'Isabela',    'Santos',                  'IS061_520', 'Cliente', 'Pwd123!'),
(19, 'Javier',     'Reyes',                   'JR062_521', 'Cliente', 'Pwd123!'),
(20, 'Kenia',      'M�ndez',                  'KM063_522', 'Cliente', 'Pwd123!'),
(21, 'Lorenzo',    'Rodr�guez',               'LR064_523', 'Cliente', 'Pwd123!'),
(22, 'Marina',     'Jim�nez',                 'MJ065_524', 'Cliente', 'Pwd123!'),
(18, 'Nicol�s',    'Flores',                  'NF066_525', 'Cliente', 'Pwd123!'),
(19, 'Olga',       'S�nchez',                 'OS067_526', 'Cliente', 'Pwd123!'),
(20, 'Pablo',      'Dom�nguez',               'PD068_527', 'Cliente', 'Pwd123!'),
(21, 'Raquel',     'Vargas',                  'RV069_528', 'Cliente', 'Pwd123!'),
(22, 'Santiago',   'Luna',                    'SL070_529', 'Cliente', 'Pwd123!'),
(18, 'Teresa',     'Salazar',                 'TS071_530', 'Cliente', 'Pwd123!'),
(19, 'Ulises',     'G�mez',                   'UG072_531', 'Cliente', 'Pwd123!'),
(20, 'Valeria',    'Medina',                  'VM073_532', 'Cliente', 'Pwd123!'),
(21, 'Willy',      'Pe�a',                    'WP074_533', 'Cliente', 'Pwd123!'),
(22, 'Ximena',     'Campos',                  'XC075_534', 'Cliente', 'Pwd123!'),
(18, 'Yuri',       'Soto',                     'YS076_535', 'Cliente', 'Pwd123!'),
(19, 'Zacar�as',   'Morales',                  'ZM077_536', 'Cliente', 'Pwd123!'),
(20, 'Adriana',    'Gonz�lez',                  'AG078_537', 'Cliente', 'Pwd123!'),
(21, 'Blas',       'Hern�ndez',                 'BH079_538', 'Cliente', 'Pwd123!'),
(22, 'Cecilia',    'Jim�nez',                 'CJ080_539', 'Cliente', 'Pwd123!'),
(18, 'David',      'Navarro',                  'DN081_540', 'Cliente', 'Pwd123!'),
(19, 'Estela',     'Duarte',                   'ED082_541', 'Cliente', 'Pwd123!'),
(20, 'Francisco',  '�lvarez',                  'FA083_542', 'Cliente', 'Pwd123!'),
(21, 'Gema',       'Rodr�guez',                'GR084_543', 'Cliente', 'Pwd123!'),
(22, 'Horacio',    'Mu�oz',                    'HM085_544', 'Cliente', 'Pwd123!'),
(18, 'Irene',      'Torres',                   'IT086_545', 'Cliente', 'Pwd123!'),
(19, 'Joel',       'Valle',                    'JV087_546', 'Cliente', 'Pwd123!'),
(20, 'Karla',      'Vargas',                   'KV088_547', 'Cliente', 'Pwd123!'),
(21, 'Leonor',     'Garc�a',                   'LG089_548', 'Cliente', 'Pwd123!'),
(22, 'Mauro',      'Silva',                    'MS090_549', 'Cliente', 'Pwd123!'),
(18, 'Nadia',      'R�os',                     'NR091_550', 'Cliente', 'Pwd123!'),
(19, '�scar',      'Castro',                   'OC092_551', 'Cliente', 'Pwd123!'),
(20, 'Paula',      'Cruz',                     'PC093_552', 'Cliente', 'Pwd123!'),
(21, 'Quintina',   'Vega',                     'QV094_553', 'Cliente', 'Pwd123!'),
(22, 'Ricardo',    'Morales',                  'RM095_554', 'Cliente', 'Pwd123!'),
(18, 'Sandra',     'Paredes',                  'SP096_555', 'Cliente', 'Pwd123!'),
(19, 'Tom�s',      'Ortiz',                   'TO097_556', 'Cliente', 'Pwd123!'),
(20, '�rsula',     'Tapia',                    'UT098_557', 'Cliente', 'Pwd123!'),
(21, 'V�ctor',     'Soto',                     'VS099_558', 'Cliente', 'Pwd123!'),
(22, 'Wendy',      'Guti�rrez',                'WG100_559', 'Cliente', 'Pwd123!'),
(18, 'Xavier',     'Navarro',                   'XN101_560', 'Cliente', 'Pwd123!'),
(19, 'Yadira',     'Espinoza',                  'YE102_561', 'Cliente', 'Pwd123!'),
(20, 'Zulema',     'Castillo',                  'ZC103_562', 'Cliente', 'Pwd123!'),
(21, '�lvaro',     'Maldonado',                  'AM104_563', 'Cliente', 'Pwd123!'),
(22, 'Brenda',     'Delgado',                    'BD105_564', 'Cliente', 'Pwd123!'),
(18, 'C�sar',      'Quintanilla',              'CQ106_565', 'Cliente', 'Pwd123!'),
(19, 'Diana',      'Su�rez',                    'DS107_566', 'Cliente', 'Pwd123!'),
(20, 'Erika',      'Ortiz',                      'EO108_567', 'Cliente', 'Pwd123!'),
(21, 'Fernando',   'M�ndez',                     'FM109_568', 'Cliente', 'Pwd123!'),
(22, 'Gabriela',   'Pacheco',                   'GP110_569', 'Cliente', 'Pwd123!'),
(18, 'Horacio',    'Ram�rez',                     'HR111_570', 'Cliente', 'Pwd123!'),
(19, 'Isabela',    'Santos',                       'IS112_571', 'Cliente', 'Pwd123!'),
(20, 'Javier',     'Reyes',                          'JR113_572', 'Cliente', 'Pwd123!'),
(21, 'Kenia',      'M�ndez',                          'KM114_573', 'Cliente', 'Pwd123!'),
(22, 'Lorenzo',    'Rodr�guez',                         'LR115_574', 'Cliente', 'Pwd123!'),
(18, 'Marina',     'Jim�nez',                         'MJ116_575', 'Cliente', 'Pwd123!'),
(19, 'Nicol�s',    'Flores',                            'NF117_576', 'Cliente', 'Pwd123!'),
(20, 'Olga',       'S�nchez',                           'OS118_577', 'Cliente', 'Pwd123!'),
(21, 'Pablo',      'Dom�nguez',                         'PD119_578', 'Cliente', 'Pwd123!'),
(22, 'Raquel',     'Vargas',                              'RV120_579', 'Cliente', 'Pwd123!'),
(18, 'Santiago',   'Luna',                                 'SL121_580', 'Cliente', 'Pwd123!'),
(19, 'Teresa',     'Salazar',                             'TS122_581', 'Cliente', 'Pwd123!'),
(20, 'Ulises',     'G�mez',                               'UG123_582', 'Cliente', 'Pwd123!'),
(21, 'Valeria',    'Medina',                              'VM124_583', 'Cliente', 'Pwd123!'),
(22, 'Willy',      'Pe�a',                                  'WP125_584', 'Cliente', 'Pwd123!'),
(18, 'Ximena',     'Campos',                                'XC126_585', 'Cliente', 'Pwd123!'),
(19, 'Yuri',       'Soto',                                  'YS127_586', 'Cliente', 'Pwd123!'),
(20, 'Zacar�as',   'Morales',                              'ZM128_587', 'Cliente', 'Pwd123!'),
(21, 'Adriana',    'Gonz�lez',                            'AG129_588', 'Cliente', 'Pwd123!'),
(22, 'Blas',       'Hern�ndez',                           'BH130_589', 'Cliente', 'Pwd123!'),
(18, 'Cecilia',    'Jim�nez',                             'CJ131_590', 'Cliente', 'Pwd123!'),
(19, 'David',      'Navarro',                             'DN132_591', 'Cliente', 'Pwd123!'),
(20, 'Estela',     'Duarte',                              'ED133_592', 'Cliente', 'Pwd123!'),
(21, 'Francisco',  '�lvarez',                             'FA134_593', 'Cliente', 'Pwd123!'),
(22, 'Gema',       'Rodr�guez',                          'GR135_594', 'Cliente', 'Pwd123!'),
(18, 'Horacio',    'Mu�oz',                                  'HM136_595', 'Cliente', 'Pwd123!'),
(19, 'Irene',      'Torres',                               'IT137_596', 'Cliente', 'Pwd123!'),
(20, 'Joel',       'Valle',                                'JV138_597', 'Cliente', 'Pwd123!'),
(21, 'Karla',      'Vargas',                              'KV139_598', 'Cliente', 'Pwd123!'),
(22, 'Leonor',     'Garc�a',                              'LG140_599', 'Cliente', 'Pwd123!'),
(18, 'Mauro',      'Silva',                                'MS141_600', 'Cliente', 'Pwd123!'),
(19, 'Nadia',      'R�os',                                    'NR142_601', 'Cliente', 'Pwd123!'),
(20, '�scar',      'Castro',                                  'OC143_602', 'Cliente', 'Pwd123!'),
(21, 'Paula',      'Cruz',                                  'PC144_603', 'Cliente', 'Pwd123!'),
(22, 'Quintina',   'Vega',                                  'QV145_604', 'Cliente', 'Pwd123!'),
(18, 'Ricardo',    'Morales',                                'RM146_605', 'Cliente', 'Pwd123!'),
(19, 'Sandra',     'Paredes',                               'SP147_606', 'Cliente', 'Pwd123!'),
(20, 'Tom�s',      'Ortiz',                                  'TO148_607', 'Cliente', 'Pwd123!'),
(21, '�rsula',     'Tapia',                                  'UT149_608', 'Cliente', 'Pwd123!'),
(22, 'V�ctor',     'Soto',                                   'VS150_609', 'Cliente', 'Pwd123!');

--gym6

--gym 6

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(23, 'Andr�s',      'L�pez',       'AL001_610', 'Entrenador',     'Pwd123!'),
(23, 'Beatriz',     'Mart�nez',    'BM002_611', 'Recepcionista',  'Pwd123!'),
(23, 'Carlos',      'Ram�rez',     'CR003_612', 'Limpieza',       'Pwd123!'),
(23, 'Diana',       'Santos',      'DS004_613', 'Administrador',  'Pwd123!'),
(23, 'Eduardo',     'Vargas',      'EV005_614', 'Entrenador',     'Pwd123!'),
(23, 'Fernanda',    'Ortega',      'FO006_615', 'Nutricionista',  'Pwd123!'),
(23, 'Gustavo',     'Pacheco',     'GP007_616', 'Mantenimiento',  'Pwd123!'),
(23, 'Hilda',       'Su�rez',      'HS008_617', 'Recepcionista',  'Pwd123!'),
(23, 'Ignacio',     'Ruiz',        'IR009_618', 'Entrenador',     'Pwd123!'),
(23, 'Juliana',     'Torres',      'JT010_619', 'Nutricionista',  'Pwd123!');
 

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(23, 'Ana',        'Garc�a',       'AG001_620', 'Cliente', 'Pwd123!'),
(24, 'Bruno',      'M�ndez',       'BM002_621', 'Cliente', 'Pwd123!'),
(25, 'Carla',      'Ramos',        'CR003_622', 'Cliente', 'Pwd123!'),
(26, 'Diego',      'Ortiz',        'DO004_623', 'Cliente', 'Pwd123!'),
(23, 'Elena',      'P�rez',        'EP005_624', 'Cliente', 'Pwd123!'),
(24, 'Fernando',   'Lozano',       'FL006_625', 'Cliente', 'Pwd123!'),
(25, 'Gabriela',   'Vega',         'GV007_626', 'Cliente', 'Pwd123!'),
(26, 'Hugo',       'Ram�rez',      'HR008_627', 'Cliente', 'Pwd123!'),
(23, 'Isabel',     'Soto',         'IS009_628', 'Cliente', 'Pwd123!'),
(24, 'Javier',     'Ruiz',         'JR010_629', 'Cliente', 'Pwd123!'),
(25, 'Karina',     'Vargas',       'KV011_630', 'Cliente', 'Pwd123!'),
(26, 'Luis',       'Medina',       'LM012_631', 'Cliente', 'Pwd123!'),
(23, 'Mar�a',      'Castillo',     'MC013_632', 'Cliente', 'Pwd123!'),
(24, 'N�stor',     'G�mez',        'NG014_633', 'Cliente', 'Pwd123!'),
(25, 'Olga',       'Dom�nguez',    'OD015_634', 'Cliente', 'Pwd123!'),
(26, 'Pablo',      'Herrera',      'PH016_635', 'Cliente', 'Pwd123!'),
(23, 'Quetzal',    'Flores',       'QF017_636', 'Cliente', 'Pwd123!'),
(24, 'Rosa',       'Jim�nez',      'RJ018_637', 'Cliente', 'Pwd123!'),
(25, 'Samuel',     'Silva',        'SS019_638', 'Cliente', 'Pwd123!'),
(26, 'Teresa',     'Maldonado',    'TM020_639', 'Cliente', 'Pwd123!'),
(23, 'Ulises',     'Pineda',       'UP021_640', 'Cliente', 'Pwd123!'),
(24, 'Valeria',    'Vargas',       'VV022_641', 'Cliente', 'Pwd123!'),
(25, 'Walter',     'Salinas',      'WS023_642', 'Cliente', 'Pwd123!'),
(26, 'Ximena',     'N��ez',        'XN024_643', 'Cliente', 'Pwd123!'),
(23, 'Yolanda',    'Reyes',        'YR025_644', 'Cliente', 'Pwd123!'),
(24, 'Zacar�as',   'Torres',       'ZT026_645', 'Cliente', 'Pwd123!'),
(25, 'Alejandra',  'Romero',       'AR027_646', 'Cliente', 'Pwd123!'),
(26, 'Benjam�n',   'Ortega',       'BO028_647', 'Cliente', 'Pwd123!'),
(23, 'Cristina',   'Guzm�n',       'CG029_648', 'Cliente', 'Pwd123!'),
(24, 'Daniel',     'Luna',         'DL030_649', 'Cliente', 'Pwd123!'),
(25, 'Estefan�a',  'Campos',       'EC031_650', 'Cliente', 'Pwd123!'),
(26, 'Felipe',     'Tapia',        'FT032_651', 'Cliente', 'Pwd123!'),
(23, 'Gloria',     'Santiago',     'GS033_652', 'Cliente', 'Pwd123!'),
(24, 'H�ctor',     'R�os',         'HR034_653', 'Cliente', 'Pwd123!'),
(25, 'Ivana',      'Fuentes',      'IF035_654', 'Cliente', 'Pwd123!'),
(26, 'Jorge',      'Alvarado',     'JA036_655', 'Cliente', 'Pwd123!'),
(23, 'Karla',      'Arias',        'KA037_656', 'Cliente', 'Pwd123!'),
(24, 'Leonardo',   'Salazar',      'LS038_657', 'Cliente', 'Pwd123!'),
(25, 'Marta',      'Mendoza',      'MM039_658', 'Cliente', 'Pwd123!'),
(26, 'Norberto',   'Fuentes',      'NF040_659', 'Cliente', 'Pwd123!'),
(23, 'Olivia',     'Cardoza',      'OC041_660', 'Cliente', 'Pwd123!'),
(24, 'Pedro',      'Gonz�lez',     'PG042_661', 'Cliente', 'Pwd123!'),
(25, 'Querida',    'Morales',      'QM043_662', 'Cliente', 'Pwd123!'),
(26, 'Rafael',     'Vega',         'RV044_663', 'Cliente', 'Pwd123!'),
(23, 'Sof�a',      'Luna',         'SL045_664', 'Cliente', 'Pwd123!'),
(24, 'Tom�s',      'Cruz',         'TC046_665', 'Cliente', 'Pwd123!'),
(25, '�rsula',     'Hern�ndez',    'UH047_666', 'Cliente', 'Pwd123!'),
(26, 'V�ctor',     'Valle',        'VV048_667', 'Cliente', 'Pwd123!'),
(23, 'Wendy',      'Guti�rrez',     'WG049_668', 'Cliente', 'Pwd123!'),
(24, 'Xavier',     'Navarro',       'XN050_669', 'Cliente', 'Pwd123!'),
(25, 'Yadira',     'Espinoza',      'YE051_670', 'Cliente', 'Pwd123!'),
(26, 'Zulema',     'Castillo',      'ZC052_671', 'Cliente', 'Pwd123!'),
(23, '�lvaro',     'Maldonado',      'AM053_672', 'Cliente', 'Pwd123!'),
(24, 'Brenda',     'Delgado',       'BD054_673', 'Cliente', 'Pwd123!'),
(25, 'C�sar',      'Quintanilla',   'CQ055_674', 'Cliente', 'Pwd123!'),
(26, 'Diana',      'Su�rez',         'DS056_675', 'Cliente', 'Pwd123!'),
(23, 'Erika',      'Ortiz',          'EO057_676', 'Cliente', 'Pwd123!'),
(24, 'Fernando',   'M�ndez',         'FM058_677', 'Cliente', 'Pwd123!'),
(25, 'Gabriela',   'Pacheco',         'GP059_678', 'Cliente', 'Pwd123!'),
(26, 'Horacio',    'Ram�rez',         'HR060_679', 'Cliente', 'Pwd123!'),
(23, 'Isabela',    'Santos',          'IS061_680', 'Cliente', 'Pwd123!'),
(24, 'Javier',     'Reyes',           'JR062_681', 'Cliente', 'Pwd123!'),
(25, 'Kenia',      'M�ndez',          'KM063_682', 'Cliente', 'Pwd123!'),
(26, 'Lorenzo',    'Rodr�guez',       'LR064_683', 'Cliente', 'Pwd123!'),
(23, 'Marina',     'Jim�nez',         'MJ065_684', 'Cliente', 'Pwd123!'),
(24, 'Nicol�s',    'Flores',          'NF066_685', 'Cliente', 'Pwd123!'),
(25, 'Olga',       'S�nchez',         'OS067_686', 'Cliente', 'Pwd123!'),
(26, 'Pablo',      'Dom�nguez',       'PD068_687', 'Cliente', 'Pwd123!'),
(23, 'Raquel',     'Vargas',          'RV069_688', 'Cliente', 'Pwd123!'),
(24, 'Santiago',   'Luna',             'SL070_689', 'Cliente', 'Pwd123!'),
(25, 'Teresa',     'Salazar',         'TS071_690', 'Cliente', 'Pwd123!'),
(26, 'Ulises',     'G�mez',           'UG072_691', 'Cliente', 'Pwd123!'),
(23, 'Valeria',    'Medina',          'VM073_692', 'Cliente', 'Pwd123!'),
(24, 'Willy',      'Pe�a',            'WP074_693', 'Cliente', 'Pwd123!'),
(25, 'Ximena',     'Campos',          'XC075_694', 'Cliente', 'Pwd123!'),
(26, 'Yuri',       'Soto',             'YS076_695', 'Cliente', 'Pwd123!'),
(23, 'Zacar�as',   'Morales',          'ZM077_696', 'Cliente', 'Pwd123!'),
(24, 'Adriana',    'Gonz�lez',        'AG078_697', 'Cliente', 'Pwd123!'),
(25, 'Blas',       'Hern�ndez',       'BH079_698', 'Cliente', 'Pwd123!'),
(26, 'Cecilia',    'Jim�nez',         'CJ080_699', 'Cliente', 'Pwd123!');

--gym 7

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(27, 'Andr�s',     'Flores',        'AF001_700', 'Entrenador',     'Pwd123!'),
(27, 'Beatriz',    'Morales',       'BM002_701', 'Recepcionista',  'Pwd123!'),
(27, 'Carlos',     'Ram�rez',       'CR003_702', 'Limpieza',       'Pwd123!'),
(27, 'Diana',      'Santos',        'DS004_703', 'Administrador',  'Pwd123!'),
(27, 'Eduardo',    'Vargas',        'EV005_704', 'Entrenador',     'Pwd123!'),
(27, 'Fernanda',   'Ortega',        'FO006_705', 'Nutricionista',  'Pwd123!'),
(27, 'Gustavo',    'Pacheco',       'GP007_706', 'Mantenimiento',  'Pwd123!'),
(27, 'Hilda',      'Su�rez',        'HS008_707', 'Recepcionista',  'Pwd123!'),
(27, 'Ignacio',    'Ruiz',          'IR009_708', 'Entrenador',     'Pwd123!'),
(27, 'Juliana',    'Torres',        'JT010_709', 'Nutricionista',  'Pwd123!');

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(27, 'Ana',        'Garc�a',       'AG001_710', 'Cliente', 'Pwd123!'),
(28, 'Bruno',      'M�ndez',       'BM002_711', 'Cliente', 'Pwd123!'),
(29, 'Carla',      'Ramos',        'CR003_712', 'Cliente', 'Pwd123!'),
(30, 'Diego',      'Ortiz',        'DO004_713', 'Cliente', 'Pwd123!'),
(31, 'Elena',      'P�rez',        'EP005_714', 'Cliente', 'Pwd123!'),
(27, 'Fernando',   'Lozano',       'FL006_715', 'Cliente', 'Pwd123!'),
(28, 'Gabriela',   'Vega',         'GV007_716', 'Cliente', 'Pwd123!'),
(29, 'Hugo',       'Ram�rez',      'HR008_717', 'Cliente', 'Pwd123!'),
(30, 'Isabel',     'Soto',         'IS009_718', 'Cliente', 'Pwd123!'),
(31, 'Javier',     'Ruiz',         'JR010_719', 'Cliente', 'Pwd123!'),
(27, 'Karina',     'Vargas',       'KV011_720', 'Cliente', 'Pwd123!'),
(28, 'Luis',       'Medina',       'LM012_721', 'Cliente', 'Pwd123!'),
(29, 'Mar�a',      'Castillo',     'MC013_722', 'Cliente', 'Pwd123!'),
(30, 'N�stor',     'G�mez',        'NG014_723', 'Cliente', 'Pwd123!'),
(31, 'Olga',       'Dom�nguez',    'OD015_724', 'Cliente', 'Pwd123!'),
(27, 'Pablo',      'Herrera',      'PH016_725', 'Cliente', 'Pwd123!'),
(28, 'Quetzal',    'Flores',       'QF017_726', 'Cliente', 'Pwd123!'),
(29, 'Rosa',       'Jim�nez',      'RJ018_727', 'Cliente', 'Pwd123!'),
(30, 'Samuel',     'Silva',        'SS019_728', 'Cliente', 'Pwd123!'),
(31, 'Teresa',     'Maldonado',    'TM020_729', 'Cliente', 'Pwd123!'),
(27, 'Ulises',     'Pineda',       'UP021_730', 'Cliente', 'Pwd123!'),
(28, 'Valeria',    'Vargas',       'VV022_731', 'Cliente', 'Pwd123!'),
(29, 'Walter',     'Salinas',      'WS023_732', 'Cliente', 'Pwd123!'),
(30, 'Ximena',     'N��ez',        'XN024_733', 'Cliente', 'Pwd123!'),
(31, 'Yolanda',    'Reyes',        'YR025_734', 'Cliente', 'Pwd123!'),
(27, 'Zacar�as',   'Torres',       'ZT026_735', 'Cliente', 'Pwd123!'),
(28, 'Alejandra',  'Romero',       'AR027_736', 'Cliente', 'Pwd123!'),
(29, 'Benjam�n',   'Ortega',       'BO028_737', 'Cliente', 'Pwd123!'),
(30, 'Cristina',   'Guzm�n',       'CG029_738', 'Cliente', 'Pwd123!'),
(31, 'Daniel',     'Luna',         'DL030_739', 'Cliente', 'Pwd123!'),
(27, 'Estefan�a',  'Campos',       'EC031_740', 'Cliente', 'Pwd123!'),
(28, 'Felipe',     'Tapia',        'FT032_741', 'Cliente', 'Pwd123!'),
(29, 'Gloria',     'Santiago',     'GS033_742', 'Cliente', 'Pwd123!'),
(30, 'H�ctor',     'R�os',         'HR034_743', 'Cliente', 'Pwd123!'),
(31, 'Ivana',      'Fuentes',      'IF035_744', 'Cliente', 'Pwd123!'),
(27, 'Jorge',      'Alvarado',     'JA036_745', 'Cliente', 'Pwd123!'),
(28, 'Karla',      'Arias',        'KA037_746', 'Cliente', 'Pwd123!'),
(29, 'Leonardo',   'Salazar',      'LS038_747', 'Cliente', 'Pwd123!'),
(30, 'Marta',      'Mendoza',      'MM039_748', 'Cliente', 'Pwd123!'),
(31, 'Norberto',   'Fuentes',      'NF040_749', 'Cliente', 'Pwd123!'),
(27, 'Olivia',     'Cardoza',      'OC041_750', 'Cliente', 'Pwd123!'),
(28, 'Pedro',      'Gonz�lez',     'PG042_751', 'Cliente', 'Pwd123!'),
(29, 'Querida',    'Morales',      'QM043_752', 'Cliente', 'Pwd123!'),
(30, 'Rafael',     'Vega',         'RV044_753', 'Cliente', 'Pwd123!'),
(31, 'Sof�a',      'Luna',         'SL045_754', 'Cliente', 'Pwd123!'),
(27, 'Tom�s',      'Cruz',         'TC046_755', 'Cliente', 'Pwd123!'),
(28, '�rsula',     'Hern�ndez',    'UH047_756', 'Cliente', 'Pwd123!'),
(29, 'V�ctor',     'Valle',        'VV048_757', 'Cliente', 'Pwd123!'),
(30, 'Wendy',      'Guti�rrez',     'WG049_758', 'Cliente', 'Pwd123!'),
(31, 'Xavier',     'Navarro',       'XN050_759', 'Cliente', 'Pwd123!'),
(27, 'Yadira',     'Espinoza',      'YE051_760', 'Cliente', 'Pwd123!'),
(28, 'Zulema',     'Castillo',      'ZC052_761', 'Cliente', 'Pwd123!'),
(29, '�lvaro',     'Maldonado',      'AM053_762', 'Cliente', 'Pwd123!'),
(30, 'Brenda',     'Delgado',       'BD054_763', 'Cliente', 'Pwd123!'),
(31, 'C�sar',      'Quintanilla',   'CQ055_764', 'Cliente', 'Pwd123!'),
(27, 'Diana',      'Su�rez',         'DS056_765', 'Cliente', 'Pwd123!'),
(28, 'Erika',      'Ortiz',          'EO057_766', 'Cliente', 'Pwd123!'),
(29, 'Fernando',   'M�ndez',         'FM058_767', 'Cliente', 'Pwd123!'),
(30, 'Gabriela',   'Pacheco',         'GP059_768', 'Cliente', 'Pwd123!'),
(31, 'Horacio',    'Ram�rez',         'HR060_769', 'Cliente', 'Pwd123!'),
(27, 'Isabela',    'Santos',          'IS061_770', 'Cliente', 'Pwd123!'),
(28, 'Javier',     'Reyes',           'JR062_771', 'Cliente', 'Pwd123!'),
(29, 'Kenia',      'M�ndez',          'KM063_772', 'Cliente', 'Pwd123!'),
(30, 'Lorenzo',    'Rodr�guez',       'LR064_773', 'Cliente', 'Pwd123!'),
(31, 'Marina',     'Jim�nez',         'MJ065_774', 'Cliente', 'Pwd123!'),
(27, 'Nicol�s',    'Flores',          'NF066_775', 'Cliente', 'Pwd123!'),
(28, 'Olga',       'S�nchez',         'OS067_776', 'Cliente', 'Pwd123!'),
(29, 'Pablo',      'Dom�nguez',       'PD068_777', 'Cliente', 'Pwd123!'),
(30, 'Raquel',     'Vargas',          'RV069_778', 'Cliente', 'Pwd123!'),
(31, 'Santiago',   'Luna',             'SL070_779', 'Cliente', 'Pwd123!'),
(27, 'Teresa',     'Salazar',         'TS071_780', 'Cliente', 'Pwd123!'),
(28, 'Ulises',     'G�mez',           'UG072_781', 'Cliente', 'Pwd123!'),
(29, 'Valeria',    'Medina',          'VM073_782', 'Cliente', 'Pwd123!'),
(30, 'Willy',      'Pe�a',            'WP074_783', 'Cliente', 'Pwd123!'),
(31, 'Ximena',     'Campos',          'XC075_784', 'Cliente', 'Pwd123!'),
(27, 'Yuri',       'Soto',             'YS076_785', 'Cliente', 'Pwd123!'),
(28, 'Zacar�as',   'Morales',          'ZM077_786', 'Cliente', 'Pwd123!'),
(29, 'Adriana',    'Gonz�lez',        'AG078_787', 'Cliente', 'Pwd123!'),
(30, 'Blas',       'Hern�ndez',       'BH079_788', 'Cliente', 'Pwd123!'),
(31, 'Cecilia',    'Jim�nez',         'CJ080_789', 'Cliente', 'Pwd123!');


--gym 8
INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(32, 'Alejandro',  'S�nchez',     'AS001_790', 'Entrenador',     'Pwd123!'),
(32, 'Beatriz',    'G�mez',        'BG002_791', 'Recepcionista',  'Pwd123!'),
(32, 'Carlos',     'Ram�rez',      'CR003_792', 'Limpieza',       'Pwd123!'),
(32, 'Diana',      'Torres',       'DT004_793', 'Administrador',  'Pwd123!'),
(32, 'Eduardo',    'Vargas',       'EV005_794', 'Entrenador',     'Pwd123!'),
(32, 'Fernanda',   'Ortiz',        'FO006_795', 'Nutricionista',  'Pwd123!'),
(32, 'Gustavo',    'M�ndez',       'GM007_796', 'Mantenimiento',  'Pwd123!'),
(32, 'Hilda',      'Su�rez',       'HS008_797', 'Recepcionista',  'Pwd123!'),
(32, 'Ignacio',    'Ruiz',         'IR009_798', 'Entrenador',     'Pwd123!'),
(32, 'Juliana',    'Luna',         'JL010_799', 'Nutricionista',  'Pwd123!');


INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(32, 'Ana',        'Garc�a',       'AG001_800', 'Cliente', 'Pwd123!'),
(33, 'Bruno',      'M�ndez',       'BM002_801', 'Cliente', 'Pwd123!'),
(34, 'Carla',      'Ramos',        'CR003_802', 'Cliente', 'Pwd123!'),
(32, 'Diego',      'Ortiz',        'DO004_803', 'Cliente', 'Pwd123!'),
(33, 'Elena',      'P�rez',        'EP005_804', 'Cliente', 'Pwd123!'),
(34, 'Fernando',   'Lozano',       'FL006_805', 'Cliente', 'Pwd123!'),
(32, 'Gabriela',   'Vega',         'GV007_806', 'Cliente', 'Pwd123!'),
(33, 'Hugo',       'Ram�rez',      'HR008_807', 'Cliente', 'Pwd123!'),
(34, 'Isabel',     'Soto',         'IS009_808', 'Cliente', 'Pwd123!'),
(32, 'Javier',     'Ruiz',         'JR010_809', 'Cliente', 'Pwd123!'),
(33, 'Karina',     'Vargas',       'KV011_810', 'Cliente', 'Pwd123!'),
(34, 'Luis',       'Medina',       'LM012_811', 'Cliente', 'Pwd123!'),
(32, 'Mar�a',      'Castillo',     'MC013_812', 'Cliente', 'Pwd123!'),
(33, 'N�stor',     'G�mez',        'NG014_813', 'Cliente', 'Pwd123!'),
(34, 'Olga',       'Dom�nguez',    'OD015_814', 'Cliente', 'Pwd123!'),
(32, 'Pablo',      'Herrera',      'PH016_815', 'Cliente', 'Pwd123!'),
(33, 'Quetzal',    'Flores',       'QF017_816', 'Cliente', 'Pwd123!'),
(34, 'Rosa',       'Jim�nez',      'RJ018_817', 'Cliente', 'Pwd123!'),
(32, 'Samuel',     'Silva',        'SS019_818', 'Cliente', 'Pwd123!'),
(33, 'Teresa',     'Maldonado',    'TM020_819', 'Cliente', 'Pwd123!'),
(34, 'Ulises',     'Pineda',       'UP021_820', 'Cliente', 'Pwd123!'),
(32, 'Valeria',    'Vargas',       'VV022_821', 'Cliente', 'Pwd123!'),
(33, 'Walter',     'Salinas',      'WS023_822', 'Cliente', 'Pwd123!'),
(34, 'Ximena',     'N��ez',        'XN024_823', 'Cliente', 'Pwd123!'),
(32, 'Yolanda',    'Reyes',        'YR025_824', 'Cliente', 'Pwd123!'),
(33, 'Zacar�as',   'Torres',       'ZT026_825', 'Cliente', 'Pwd123!'),
(34, 'Alejandra',  'Romero',       'AR027_826', 'Cliente', 'Pwd123!'),
(32, 'Benjam�n',   'Ortega',       'BO028_827', 'Cliente', 'Pwd123!'),
(33, 'Cristina',   'Guzm�n',       'CG029_828', 'Cliente', 'Pwd123!'),
(34, 'Daniel',     'Luna',         'DL030_829', 'Cliente', 'Pwd123!'),
(32, 'Estefan�a',  'Campos',        'EC031_830', 'Cliente', 'Pwd123!'),
(33, 'Felipe',     'Tapia',         'FT032_831', 'Cliente', 'Pwd123!'),
(34, 'Gloria',     'Santiago',      'GS033_832', 'Cliente', 'Pwd123!'),
(32, 'H�ctor',     'R�os',         'HR034_833', 'Cliente', 'Pwd123!'),
(33, 'Ivana',      'Fuentes',      'IF035_834', 'Cliente', 'Pwd123!'),
(34, 'Jorge',      'Alvarado',     'JA036_835', 'Cliente', 'Pwd123!'),
(32, 'Karla',      'Arias',        'KA037_836', 'Cliente', 'Pwd123!'),
(33, 'Leonardo',   'Salazar',      'LS038_837', 'Cliente', 'Pwd123!'),
(34, 'Marta',      'Mendoza',      'MM039_838', 'Cliente', 'Pwd123!'),
(32, 'Norberto',   'Fuentes',      'NF040_839', 'Cliente', 'Pwd123!'),
(33, 'Olivia',     'Cardoza',      'OC041_840', 'Cliente', 'Pwd123!'),
(34, 'Pedro',      'Gonz�lez',     'PG042_841', 'Cliente', 'Pwd123!'),
(32, 'Querida',    'Morales',      'QM043_842', 'Cliente', 'Pwd123!'),
(33, 'Rafael',     'Vega',         'RV044_843', 'Cliente', 'Pwd123!'),
(34, 'Sof�a',      'Luna',         'SL045_844', 'Cliente', 'Pwd123!'),
(32, 'Tom�s',      'Cruz',         'TC046_845', 'Cliente', 'Pwd123!'),
(33, '�rsula',     'Hern�ndez',    'UH047_846', 'Cliente', 'Pwd123!'),
(34, 'V�ctor',     'Valle',        'VV048_847', 'Cliente', 'Pwd123!'),
(32, 'Wendy',      'Guti�rrez',     'WG049_848', 'Cliente', 'Pwd123!'),
(33, 'Xavier',     'Navarro',       'XN050_849', 'Cliente', 'Pwd123!'),
(34, 'Yadira',     'Espinoza',      'YE051_850', 'Cliente', 'Pwd123!'),
(32, 'Zulema',     'Castillo',      'ZC052_851', 'Cliente', 'Pwd123!'),
(33, '�lvaro',     'Maldonado',      'AM053_852', 'Cliente', 'Pwd123!'),
(34, 'Brenda',     'Delgado',       'BD054_853', 'Cliente', 'Pwd123!'),
(32, 'C�sar',      'Quintanilla',   'CQ055_854', 'Cliente', 'Pwd123!'),
(33, 'Diana',      'Su�rez',         'DS056_855', 'Cliente', 'Pwd123!'),
(34, 'Erika',      'Ortiz',          'EO057_856', 'Cliente', 'Pwd123!'),
(32, 'Fernando',   'M�ndez',         'FM058_857', 'Cliente', 'Pwd123!'),
(33, 'Gabriela',   'Pacheco',         'GP059_858', 'Cliente', 'Pwd123!'),
(34, 'Horacio',    'Ram�rez',         'HR060_859', 'Cliente', 'Pwd123!'),
(32, 'Isabela',    'Santos',          'IS061_860', 'Cliente', 'Pwd123!'),
(33, 'Javier',     'Reyes',           'JR062_861', 'Cliente', 'Pwd123!'),
(34, 'Kenia',      'M�ndez',          'KM063_862', 'Cliente', 'Pwd123!'),
(32, 'Lorenzo',    'Rodr�guez',       'LR064_863', 'Cliente', 'Pwd123!'),
(33, 'Marina',     'Jim�nez',         'MJ065_864', 'Cliente', 'Pwd123!'),
(34, 'Nicol�s',    'Flores',         'NF066_865', 'Cliente', 'Pwd123!'),
(32, 'Olga',       'S�nchez',         'OS067_866', 'Cliente', 'Pwd123!'),
(33, 'Pablo',      'Dom�nguez',       'PD068_867', 'Cliente', 'Pwd123!'),
(34, 'Raquel',     'Vargas',          'RV069_868', 'Cliente', 'Pwd123!'),
(32, 'Santiago',   'Luna',             'SL070_869', 'Cliente', 'Pwd123!'),
(33, 'Teresa',     'Salazar',         'TS071_870', 'Cliente', 'Pwd123!'),
(34, 'Ulises',     'G�mez',           'UG072_871', 'Cliente', 'Pwd123!'),
(32, 'Valeria',    'Medina',          'VM073_872', 'Cliente', 'Pwd123!'),
(33, 'Willy',      'Pe�a',            'WP074_873', 'Cliente', 'Pwd123!'),
(34, 'Ximena',     'Campos',          'XC075_874', 'Cliente', 'Pwd123!'),
(32, 'Yuri',       'Soto',             'YS076_875', 'Cliente', 'Pwd123!'),
(33, 'Zacar�as',   'Morales',          'ZM077_876', 'Cliente', 'Pwd123!'),
(34, 'Adriana',    'Gonz�lez',        'AG078_877', 'Cliente', 'Pwd123!'),
(32, 'Blas',       'Hern�ndez',       'BH079_878', 'Cliente', 'Pwd123!'),
(33, 'Cecilia',    'Jim�nez',         'CJ080_879', 'Cliente', 'Pwd123!'),
(34, 'David',      'Navarro',          'DN081_880', 'Cliente', 'Pwd123!'),
(32, 'Estela',     'Duarte',           'ED082_881', 'Cliente', 'Pwd123!'),
(33, 'Francisco',  '�lvarez',          'FA083_882', 'Cliente', 'Pwd123!'),
(34, 'Gema',       'Rodr�guez',        'GR084_883', 'Cliente', 'Pwd123!'),
(32, 'Horacio',    'Mu�oz',            'HM085_884', 'Cliente', 'Pwd123!'),
(33, 'Irene',      'Torres',           'IT086_885', 'Cliente', 'Pwd123!'),
(34, 'Joel',       'Valle',            'JV087_886', 'Cliente', 'Pwd123!'),
(32, 'Karla',      'Vargas',           'KV088_887', 'Cliente', 'Pwd123!'),
(33, 'Leonor',     'Garc�a',           'LG089_888', 'Cliente', 'Pwd123!'),
(34, 'Mauro',      'Silva',            'MS090_889', 'Cliente', 'Pwd123!');


--gym 9

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(35, 'Andr�s',     'G�mez',        'AG001_890', 'Entrenador',     'Pwd123!'),
(35, 'Beatriz',    'Castillo',     'BC002_891', 'Recepcionista',  'Pwd123!'),
(35, 'Carlos',     'Ortiz',        'CO003_892', 'Limpieza',       'Pwd123!'),
(35, 'Diana',      'R�os',         'DR004_893', 'Administrador',  'Pwd123!'),
(35, 'Eduardo',    'Vargas',       'EV005_894', 'Entrenador',     'Pwd123!'),
(35, 'Fernanda',   'Pacheco',      'FP006_895', 'Nutricionista',  'Pwd123!'),
(35, 'Gustavo',    'Maldonado',    'GM007_896', 'Mantenimiento',  'Pwd123!'),
(35, 'Hilda',      'Su�rez',       'HS008_897', 'Recepcionista',  'Pwd123!'),
(35, 'Ignacio',    'Ruiz',         'IR009_898', 'Entrenador',     'Pwd123!'),
(35, 'Juliana',    'Torres',       'JT010_899', 'Nutricionista',  'Pwd123!');

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(35, 'Ana',        'Garc�a',        'AG001_900', 'Cliente', 'Pwd123!'),
(36, 'Bruno',      'M�ndez',        'BM002_901', 'Cliente', 'Pwd123!'),
(37, 'Carla',      'Ramos',         'CR003_902', 'Cliente', 'Pwd123!'),
(38, 'Diego',      'Ortiz',         'DO004_903', 'Cliente', 'Pwd123!'),
(39, 'Elena',      'P�rez',         'EP005_904', 'Cliente', 'Pwd123!'),
(35, 'Fernando',   'Lozano',        'FL006_905', 'Cliente', 'Pwd123!'),
(36, 'Gabriela',   'Vega',          'GV007_906', 'Cliente', 'Pwd123!'),
(37, 'Hugo',       'Ram�rez',       'HR008_907', 'Cliente', 'Pwd123!'),
(38, 'Isabel',     'Soto',          'IS009_908', 'Cliente', 'Pwd123!'),
(39, 'Javier',     'Ruiz',          'JR010_909', 'Cliente', 'Pwd123!'),
(35, 'Karina',     'Vargas',        'KV011_910', 'Cliente', 'Pwd123!'),
(36, 'Luis',       'Medina',        'LM012_911', 'Cliente', 'Pwd123!'),
(37, 'Mar�a',      'Castillo',      'MC013_912', 'Cliente', 'Pwd123!'),
(38, 'N�stor',     'G�mez',         'NG014_913', 'Cliente', 'Pwd123!'),
(39, 'Olga',       'Dom�nguez',     'OD015_914', 'Cliente', 'Pwd123!'),
(35, 'Pablo',      'Herrera',       'PH016_915', 'Cliente', 'Pwd123!'),
(36, 'Quetzal',    'Flores',        'QF017_916', 'Cliente', 'Pwd123!'),
(37, 'Rosa',       'Jim�nez',       'RJ018_917', 'Cliente', 'Pwd123!'),
(38, 'Samuel',     'Silva',         'SS019_918', 'Cliente', 'Pwd123!'),
(39, 'Teresa',     'Maldonado',     'TM020_919', 'Cliente', 'Pwd123!'),
(35, 'Ulises',     'Pineda',        'UP021_920', 'Cliente', 'Pwd123!'),
(36, 'Valeria',    'Vargas',        'VV022_921', 'Cliente', 'Pwd123!'),
(37, 'Walter',     'Salinas',       'WS023_922', 'Cliente', 'Pwd123!'),
(38, 'Ximena',     'N��ez',         'XN024_923', 'Cliente', 'Pwd123!'),
(39, 'Yolanda',    'Reyes',         'YR025_924', 'Cliente', 'Pwd123!'),
(35, 'Zacar�as',   'Torres',        'ZT026_925', 'Cliente', 'Pwd123!'),
(36, 'Alejandra',  'Romero',        'AR027_926', 'Cliente', 'Pwd123!'),
(37, 'Benjam�n',   'Ortega',        'BO028_927', 'Cliente', 'Pwd123!'),
(38, 'Cristina',   'Guzm�n',        'CG029_928', 'Cliente', 'Pwd123!'),
(39, 'Daniel',     'Luna',          'DL030_929', 'Cliente', 'Pwd123!'),
(35, 'Estefan�a',  'Campos',        'EC031_930', 'Cliente', 'Pwd123!'),
(36, 'Felipe',     'Tapia',         'FT032_931', 'Cliente', 'Pwd123!'),
(37, 'Gloria',     'Santiago',      'GS033_932', 'Cliente', 'Pwd123!'),
(38, 'H�ctor',     'R�os',          'HR034_933', 'Cliente', 'Pwd123!'),
(39, 'Ivana',      'Fuentes',       'IF035_934', 'Cliente', 'Pwd123!'),
(35, 'Jorge',      'Alvarado',      'JA036_935', 'Cliente', 'Pwd123!'),
(36, 'Karla',      'Arias',         'KA037_936', 'Cliente', 'Pwd123!'),
(37, 'Leonardo',   'Salazar',       'LS038_937', 'Cliente', 'Pwd123!'),
(38, 'Marta',      'Mendoza',       'MM039_938', 'Cliente', 'Pwd123!'),
(39, 'Norberto',   'Fuentes',       'NF040_939', 'Cliente', 'Pwd123!'),
(35, 'Olivia',     'Cardoza',       'OC041_940', 'Cliente', 'Pwd123!'),
(36, 'Pedro',      'Gonz�lez',      'PG042_941', 'Cliente', 'Pwd123!'),
(37, 'Querida',    'Morales',       'QM043_942', 'Cliente', 'Pwd123!'),
(38, 'Rafael',     'Vega',          'RV044_943', 'Cliente', 'Pwd123!'),
(39, 'Sof�a',      'Luna',          'SL045_944', 'Cliente', 'Pwd123!'),
(35, 'Tom�s',      'Cruz',          'TC046_945', 'Cliente', 'Pwd123!'),
(36, '�rsula',     'Hern�ndez',     'UH047_946', 'Cliente', 'Pwd123!'),
(37, 'V�ctor',     'Valle',         'VV048_947', 'Cliente', 'Pwd123!'),
(38, 'Wendy',      'Guti�rrez',      'WG049_948', 'Cliente', 'Pwd123!'),
(39, 'Xavier',     'Navarro',        'XN050_949', 'Cliente', 'Pwd123!'),
(35, 'Yadira',     'Espinoza',       'YE051_950', 'Cliente', 'Pwd123!'),
(36, 'Zulema',     'Castillo',       'ZC052_951', 'Cliente', 'Pwd123!'),
(37, '�lvaro',     'Maldonado',       'AM053_952', 'Cliente', 'Pwd123!'),
(38, 'Brenda',     'Delgado',        'BD054_953', 'Cliente', 'Pwd123!'),
(39, 'C�sar',      'Quintanilla',    'CQ055_954', 'Cliente', 'Pwd123!'),
(35, 'Diana',      'Su�rez',          'DS056_955', 'Cliente', 'Pwd123!'),
(36, 'Erika',      'Ortiz',            'EO057_956', 'Cliente', 'Pwd123!'),
(37, 'Fernando',   'M�ndez',          'FM058_957', 'Cliente', 'Pwd123!'),
(38, 'Gabriela',   'Pacheco',          'GP059_958', 'Cliente', 'Pwd123!'),
(39, 'Horacio',    'Ram�rez',          'HR060_959', 'Cliente', 'Pwd123!'),
(35, 'Isabela',    'Santos',           'IS061_960', 'Cliente', 'Pwd123!'),
(36, 'Javier',     'Reyes',            'JR062_961', 'Cliente', 'Pwd123!'),
(37, 'Kenia',      'M�ndez',           'KM063_962', 'Cliente', 'Pwd123!'),
(38, 'Lorenzo',    'Rodr�guez',        'LR064_963', 'Cliente', 'Pwd123!'),
(39, 'Marina',     'Jim�nez',          'MJ065_964', 'Cliente', 'Pwd123!'),
(35, 'Nicol�s',    'Flores',           'NF066_965', 'Cliente', 'Pwd123!'),
(36, 'Olga',       'S�nchez',           'OS067_966', 'Cliente', 'Pwd123!'),
(37, 'Pablo',      'Dom�nguez',         'PD068_967', 'Cliente', 'Pwd123!'),
(38, 'Raquel',     'Vargas',           'RV069_968', 'Cliente', 'Pwd123!'),
(39, 'Santiago',   'Luna',             'SL070_969', 'Cliente', 'Pwd123!'),
(35, 'Teresa',     'Salazar',          'TS071_970', 'Cliente', 'Pwd123!'),
(36, 'Ulises',     'G�mez',            'UG072_971', 'Cliente', 'Pwd123!'),
(37, 'Valeria',    'Medina',           'VM073_972', 'Cliente', 'Pwd123!'),
(38, 'Willy',      'Pe�a',              'WP074_973', 'Cliente', 'Pwd123!'),
(39, 'Ximena',     'Campos',           'XC075_974', 'Cliente', 'Pwd123!'),
(35, 'Yuri',       'Soto',              'YS076_975', 'Cliente', 'Pwd123!'),
(36, 'Zacar�as',   'Morales',           'ZM077_976', 'Cliente', 'Pwd123!'),
(37, 'Adriana',    'Gonz�lez',         'AG078_977', 'Cliente', 'Pwd123!'),
(38, 'Blas',       'Hern�ndez',        'BH079_978', 'Cliente', 'Pwd123!'),
(39, 'Cecilia',    'Jim�nez',          'CJ080_979', 'Cliente', 'Pwd123!'),
(35, 'David',      'Navarro',           'DN081_980', 'Cliente', 'Pwd123!'),
(36, 'Estela',     'Duarte',            'ED082_981', 'Cliente', 'Pwd123!'),
(37, 'Francisco',  '�lvarez',           'FA083_982', 'Cliente', 'Pwd123!'),
(38, 'Gema',       'Rodr�guez',         'GR084_983', 'Cliente', 'Pwd123!'),
(39, 'Horacio',    'Mu�oz',             'HM085_984', 'Cliente', 'Pwd123!'),
(35, 'Irene',      'Torres',            'IT086_985', 'Cliente', 'Pwd123!'),
(36, 'Joel',       'Valle',             'JV087_986', 'Cliente', 'Pwd123!'),
(37, 'Karla',      'Vargas',            'KV088_987', 'Cliente', 'Pwd123!'),
(38, 'Leonor',     'Garc�a',            'LG089_988', 'Cliente', 'Pwd123!'),
(39, 'Mauro',      'Silva',             'MS090_989', 'Cliente', 'Pwd123!'),
(35, 'Nadia',      'R�os',              'NR091_990', 'Cliente', 'Pwd123!'),
(36, '�scar',      'Castro',            'OC092_991', 'Cliente', 'Pwd123!'),
(37, 'Paula',      'Cruz',              'PC093_992', 'Cliente', 'Pwd123!'),
(38, 'Quintina',   'Vega',              'QV094_993', 'Cliente', 'Pwd123!'),
(39, 'Ricardo',    'Morales',            'RM095_994', 'Cliente', 'Pwd123!'),
(35, 'Sandra',     'Paredes',           'SP096_995', 'Cliente', 'Pwd123!'),
(36, 'Tom�s',      'Ortiz',            'TO097_996', 'Cliente', 'Pwd123!'),
(37, '�rsula',     'Tapia',            'UT098_997', 'Cliente', 'Pwd123!'),
(38, 'V�ctor',     'Soto',               'VS099_998', 'Cliente', 'Pwd123!'),
(39, 'Wendy',      'Guti�rrez',           'WG100_999', 'Cliente', 'Pwd123!');




--gym 10

INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(40, 'Adri�n',     'L�pez',        'AL001_1000', 'Entrenador',     'Pwd123!'),
(40, 'Beatriz',    'Mora',         'BM002_1001', 'Recepcionista',  'Pwd123!'),
(40, 'Carlos',     'Ram�rez',      'CR003_1002', 'Limpieza',       'Pwd123!'),
(40, 'Diana',      'P�rez',        'DP004_1003', 'Administrador',  'Pwd123!'),
(40, 'Eduardo',    'Guti�rrez',    'EG005_1004', 'Entrenador',     'Pwd123!'),
(40, 'Fernanda',   'Ortiz',        'FO006_1005', 'Nutricionista',  'Pwd123!'),
(40, 'Gustavo',    'Santos',       'GS007_1006', 'Mantenimiento',  'Pwd123!'),
(40, 'Hilda',      'Su�rez',       'HS008_1007', 'Recepcionista',  'Pwd123!'),
(40, 'Ignacio',    'Ruiz',         'IR009_1008', 'Entrenador',     'Pwd123!'),
(40, 'Juliana',    'Torres',       'JT010_1009', 'Nutricionista',  'Pwd123!'),
(40, 'Karla',      'Vargas',       'KV011_1010', 'Mantenimiento',  'Pwd123!');
 
INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
VALUES
(40, 'Ana',        'Garc�a',       'AG001_1011', 'Cliente', 'Pwd123!'),
(41, 'Bruno',      'M�ndez',       'BM002_1012', 'Cliente', 'Pwd123!'),
(42, 'Carla',      'Ramos',        'CR003_1013', 'Cliente', 'Pwd123!'),
(43, 'Diego',      'Ortiz',        'DO004_1014', 'Cliente', 'Pwd123!'),
(40, 'Elena',      'P�rez',        'EP005_1015', 'Cliente', 'Pwd123!'),
(41, 'Fernando',   'Lozano',       'FL006_1016', 'Cliente', 'Pwd123!'),
(42, 'Gabriela',   'Vega',         'GV007_1017', 'Cliente', 'Pwd123!'),
(43, 'Hugo',       'Ram�rez',      'HR008_1018', 'Cliente', 'Pwd123!'),
(40, 'Isabel',     'Soto',         'IS009_1019', 'Cliente', 'Pwd123!'),
(41, 'Javier',     'Ruiz',         'JR010_1020', 'Cliente', 'Pwd123!'),
(42, 'Karina',     'Vargas',       'KV011_1021', 'Cliente', 'Pwd123!'),
(43, 'Luis',       'Medina',       'LM012_1022', 'Cliente', 'Pwd123!'),
(40, 'Mar�a',      'Castillo',     'MC013_1023', 'Cliente', 'Pwd123!'),
(41, 'N�stor',     'G�mez',        'NG014_1024', 'Cliente', 'Pwd123!'),
(42, 'Olga',       'Dom�nguez',    'OD015_1025', 'Cliente', 'Pwd123!'),
(43, 'Pablo',      'Herrera',      'PH016_1026', 'Cliente', 'Pwd123!'),
(40, 'Quetzal',    'Flores',       'QF017_1027', 'Cliente', 'Pwd123!'),
(41, 'Rosa',       'Jim�nez',      'RJ018_1028', 'Cliente', 'Pwd123!'),
(42, 'Samuel',     'Silva',        'SS019_1029', 'Cliente', 'Pwd123!'),
(43, 'Teresa',     'Maldonado',    'TM020_1030', 'Cliente', 'Pwd123!'),
(40, 'Ulises',     'Pineda',       'UP021_1031', 'Cliente', 'Pwd123!'),
(41, 'Valeria',    'Vargas',       'VV022_1032', 'Cliente', 'Pwd123!'),
(42, 'Walter',     'Salinas',      'WS023_1033', 'Cliente', 'Pwd123!'),
(43, 'Ximena',     'N��ez',        'XN024_1034', 'Cliente', 'Pwd123!'),
(40, 'Yolanda',    'Reyes',        'YR025_1035', 'Cliente', 'Pwd123!'),
(41, 'Zacar�as',   'Torres',       'ZT026_1036', 'Cliente', 'Pwd123!'),
(42, 'Alejandra',  'Romero',       'AR027_1037', 'Cliente', 'Pwd123!'),
(43, 'Benjam�n',   'Ortega',       'BO028_1038', 'Cliente', 'Pwd123!'),
(40, 'Cristina',   'Guzm�n',       'CG029_1039', 'Cliente', 'Pwd123!'),
(41, 'Daniel',     'Luna',         'DL030_1040', 'Cliente', 'Pwd123!'),
(42, 'Estefan�a',  'Campos',       'EC031_1041', 'Cliente', 'Pwd123!'),
(43, 'Felipe',     'Tapia',        'FT032_1042', 'Cliente', 'Pwd123!'),
(40, 'Gloria',     'Santiago',     'GS033_1043', 'Cliente', 'Pwd123!'),
(41, 'H�ctor',     'R�os',         'HR034_1044', 'Cliente', 'Pwd123!'),
(42, 'Ivana',      'Fuentes',      'IF035_1045', 'Cliente', 'Pwd123!'),
(43, 'Jorge',      'Alvarado',     'JA036_1046', 'Cliente', 'Pwd123!'),
(40, 'Karla',      'Arias',        'KA037_1047', 'Cliente', 'Pwd123!'),
(41, 'Leonardo',   'Salazar',      'LS038_1048', 'Cliente', 'Pwd123!'),
(42, 'Marta',      'Mendoza',      'MM039_1049', 'Cliente', 'Pwd123!'),
(43, 'Norberto',   'Fuentes',      'NF040_1050', 'Cliente', 'Pwd123!'),
(40, 'Olivia',     'Cardoza',      'OC041_1051', 'Cliente', 'Pwd123!'),
(41, 'Pedro',      'Gonz�lez',     'PG042_1052', 'Cliente', 'Pwd123!'),
(42, 'Querida',    'Morales',      'QM043_1053', 'Cliente', 'Pwd123!'),
(43, 'Rafael',     'Vega',         'RV044_1054', 'Cliente', 'Pwd123!'),
(40, 'Sof�a',      'Luna',         'SL045_1055', 'Cliente', 'Pwd123!'),
(41, 'Tom�s',      'Cruz',         'TC046_1056', 'Cliente', 'Pwd123!'),
(42, '�rsula',     'Hern�ndez',    'UH047_1057', 'Cliente', 'Pwd123!'),
(43, 'V�ctor',     'Valle',        'VV048_1058', 'Cliente', 'Pwd123!'),
(40, 'Wendy',      'Guti�rrez',     'WG049_1059', 'Cliente', 'Pwd123!'),
(41, 'Xavier',     'Navarro',       'XN050_1060', 'Cliente', 'Pwd123!'),
(42, 'Yadira',     'Espinoza',      'YE051_1061', 'Cliente', 'Pwd123!'),
(43, 'Zulema',     'Castillo',      'ZC052_1062', 'Cliente', 'Pwd123!'),
(40, '�lvaro',     'Maldonado',      'AM053_1063', 'Cliente', 'Pwd123!'),
(41, 'Brenda',     'Delgado',       'BD054_1064', 'Cliente', 'Pwd123!'),
(42, 'C�sar',      'Quintanilla',   'CQ055_1065', 'Cliente', 'Pwd123!'),
(43, 'Diana',      'Su�rez',         'DS056_1066', 'Cliente', 'Pwd123!'),
(40, 'Erika',      'Ortiz',          'EO057_1067', 'Cliente', 'Pwd123!'),
(41, 'Fernando',   'M�ndez',         'FM058_1068', 'Cliente', 'Pwd123!'),
(42, 'Gabriela',   'Pacheco',         'GP059_1069', 'Cliente', 'Pwd123!'),
(43, 'Horacio',    'Ram�rez',         'HR060_1070', 'Cliente', 'Pwd123!'),
(40, 'Isabela',    'Santos',          'IS061_1071', 'Cliente', 'Pwd123!'),
(41, 'Javier',     'Reyes',           'JR062_1072', 'Cliente', 'Pwd123!'),
(42, 'Kenia',      'M�ndez',          'KM063_1073', 'Cliente', 'Pwd123!'),
(43, 'Lorenzo',    'Rodr�guez',       'LR064_1074', 'Cliente', 'Pwd123!'),
(40, 'Marina',     'Jim�nez',         'MJ065_1075', 'Cliente', 'Pwd123!'),
(41, 'Nicol�s',    'Flores',          'NF066_1076', 'Cliente', 'Pwd123!'),
(42, 'Olga',       'S�nchez',         'OS067_1077', 'Cliente', 'Pwd123!'),
(43, 'Pablo',      'Dom�nguez',       'PD068_1078', 'Cliente', 'Pwd123!'),
(40, 'Raquel',     'Vargas',          'RV069_1079', 'Cliente', 'Pwd123!'),
(41, 'Santiago',   'Luna',             'SL070_1080', 'Cliente', 'Pwd123!'),
(42, 'Teresa',     'Salazar',         'TS071_1081', 'Cliente', 'Pwd123!'),
(43, 'Ulises',     'G�mez',           'UG072_1082', 'Cliente', 'Pwd123!'),
(40, 'Valeria',    'Medina',          'VM073_1083', 'Cliente', 'Pwd123!'),
(41, 'Willy',      'Pe�a',            'WP074_1084', 'Cliente', 'Pwd123!'),
(42, 'Ximena',     'Campos',          'XC075_1085', 'Cliente', 'Pwd123!'),
(43, 'Yuri',       'Soto',             'YS076_1086', 'Cliente', 'Pwd123!'),
(40, 'Zacar�as',   'Morales',          'ZM077_1087', 'Cliente', 'Pwd123!'),
(41, 'Adriana',    'Gonz�lez',        'AG078_1088', 'Cliente', 'Pwd123!'),
(42, 'Blas',       'Hern�ndez',       'BH079_1089', 'Cliente', 'Pwd123!'),
(43, 'Cecilia',    'Jim�nez',         'CJ080_1090', 'Cliente', 'Pwd123!'),
(40, 'David',      'Navarro',           'DN081_1091', 'Cliente', 'Pwd123!'),
(41, 'Estela',     'Duarte',            'ED082_1092', 'Cliente', 'Pwd123!'),
(42, 'Francisco',  '�lvarez',           'FA083_1093', 'Cliente', 'Pwd123!'),
(43, 'Gema',       'Rodr�guez',         'GR084_1094', 'Cliente', 'Pwd123!'),
(40, 'Horacio',    'Mu�oz',             'HM085_1095', 'Cliente', 'Pwd123!'),
(41, 'Irene',      'Torres',            'IT086_1096', 'Cliente', 'Pwd123!'),
(42, 'Joel',       'Valle',             'JV087_1097', 'Cliente', 'Pwd123!'),
(43, 'Karla',      'Vargas',           'KV088_1098', 'Cliente', 'Pwd123!'),
(40, 'Leonor',     'Garc�a',             'LG089_1099', 'Cliente', 'Pwd123!'),
(41, 'Mauro',      'Silva',              'MS090_1100', 'Cliente', 'Pwd123!');


-- Contactos para Gym 1 (Usuarios 1-115)
INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(1, '555-1001', 'jorge.santos@email.com'),
(2, '555-1002', 'elena.peralta@email.com'),
(3, '555-1003', 'marco.villalobos@email.com'),
(4, '555-1004', 'claudia.nunez@email.com'),
(5, '555-1005', 'pedro.campos@email.com'),
(6, '555-1006', 'veronica.mendez@email.com'),
(7, '555-1007', 'diego.ramos@email.com'),
(8, '555-1008', 'laura.gonzalez@email.com'),
(9, '555-1009', 'andres.perez@email.com'),
(10, '555-1010', 'marisol.ortiz@email.com'),
(11, '555-1011', 'ricardo.morales@email.com'),
(12, '555-1012', 'patricia.hernandez@email.com'),
(13, '555-1013', 'fernando.gutierrez@email.com'),
(14, '555-1014', 'carolina.ruiz@email.com'),
(15, '555-1015', 'julian.salazar@email.com'),
(16, '555-1016', 'alejandro.vargas@email.com'),
(17, '555-1017', 'mariana.lozano@email.com'),
(18, '555-1018', 'ricardo.navarro@email.com'),
(19, '555-1019', 'patricia.castillo@email.com'),
(20, '555-1020', 'jorge.molina@email.com'),
(21, '555-1021', 'lucia.sanchez@email.com'),
(22, '555-1022', 'fernando.gomez@email.com'),
(23, '555-1023', 'veronica.paredes@email.com'),
(24, '555-1024', 'andres.flores@email.com'),
(25, '555-1025', 'natalia.rojas@email.com'),
(26, '555-1026', 'david.martinez@email.com'),
(27, '555-1027', 'sandra.dominguez@email.com'),
(28, '555-1028', 'carlos.herrera@email.com'),
(29, '555-1029', 'monica.perez@email.com'),
(30, '555-1030', 'javier.ruiz@email.com'),
(31, '555-1031', 'andrea.cruz@email.com'),
(32, '555-1032', 'luis.ortiz@email.com'),
(33, '555-1033', 'gabriela.vega@email.com'),
(34, '555-1034', 'mauricio.fernandez@email.com'),
(35, '555-1035', 'elena.soto@email.com'),
(36, '555-1036', 'hugo.medina@email.com'),
(37, '555-1037', 'isabel.morales@email.com'),
(38, '555-1038', 'oscar.castro@email.com'),
(39, '555-1039', 'karina.reyes@email.com'),
(40, '555-1040', 'rafael.guerra@email.com'),
(41, '555-1041', 'camila.valle@email.com'),
(42, '555-1042', 'manuel.salinas@email.com'),
(43, '555-1043', 'patricia.nunez@email.com'),
(44, '555-1044', 'diego.rivas@email.com'),
(45, '555-1045', 'maritza.ayala@email.com'),
(46, '555-1046', 'sebastian.gonzalez@email.com'),
(47, '555-1047', 'yolanda.chavez@email.com'),
(48, '555-1048', 'eduardo.mendez@email.com'),
(49, '555-1049', 'denise.castellanos@email.com'),
(50, '555-1050', 'oscar.medrano@email.com'),
(51, '555-1051', 'lorena.vargas@email.com'),
(52, '555-1052', 'mario.barrios@email.com'),
(53, '555-1053', 'claudia.juarez@email.com'),
(54, '555-1054', 'ramon.pineda@email.com'),
(55, '555-1055', 'liliana.ramos@email.com'),
(56, '555-1056', 'joaquin.sandoval@email.com'),
(57, '555-1057', 'viviana.lopez@email.com'),
(58, '555-1058', 'felipe.tapia@email.com'),
(59, '555-1059', 'adriana.gomez@email.com'),
(60, '555-1060', 'ricardo.silva@email.com'),
(61, '555-1061', 'raquel.rios@email.com'),
(62, '555-1062', 'gustavo.fuentes@email.com'),
(63, '555-1063', 'veronica.pacheco@email.com'),
(64, '555-1064', 'alejandra.romero@email.com'),
(65, '555-1065', 'sergio.ortega@email.com'),
(66, '555-1066', 'brenda.luna@email.com'),
(67, '555-1067', 'hector.silva@email.com'),
(68, '555-1068', 'elisa.duarte@email.com'),
(69, '555-1069', 'andres.ramirez@email.com'),
(70, '555-1070', 'sofia.vargas@email.com'),
(71, '555-1071', 'victor.acosta@email.com'),
(72, '555-1072', 'paola.herrera@email.com'),
(73, '555-1073', 'ivan.garcia@email.com'),
(74, '555-1074', 'daniela.reyes@email.com'),
(75, '555-1075', 'alberto.molina@email.com'),
(76, '555-1076', 'pamela.carrillo@email.com'),
(77, '555-1077', 'esteban.ortiz@email.com'),
(78, '555-1078', 'melissa.vargas@email.com'),
(79, '555-1079', 'hugo.pena@email.com'),
(80, '555-1080', 'yessica.campos@email.com'),
(81, '555-1081', 'mauricio.lopez@email.com'),
(82, '555-1082', 'carolina.vazquez@email.com'),
(83, '555-1083', 'rodrigo.dominguez@email.com'),
(84, '555-1084', 'fernanda.rojas@email.com'),
(85, '555-1085', 'diego.hernandez@email.com'),
(86, '555-1086', 'nora.castillo@email.com'),
(87, '555-1087', 'christian.sanchez@email.com'),
(88, '555-1088', 'sandra.ruiz@email.com'),
(89, '555-1089', 'ignacio.maldonado@email.com'),
(90, '555-1090', 'alicia.flores@email.com'),
(91, '555-1091', 'marco.perez@email.com'),
(92, '555-1092', 'karina.gomez@email.com'),
(93, '555-1093', 'roberto.jimenez@email.com'),
(94, '555-1094', 'miranda.quintero@email.com'),
(95, '555-1095', 'pablo.osorio@email.com'),
(96, '555-1096', 'gabriela.lopez@email.com'),
(97, '555-1097', 'rodolfo.salazar@email.com'),
(98, '555-1098', 'yolanda.mendez@email.com'),
(99, '555-1099', 'orlando.torres@email.com'),
(100, '555-1100', 'veronica.martinez@email.com'),
(101, '555-1101', 'diego.gonzalez@email.com'),
(102, '555-1102', 'clara.hernandez@email.com'),
(103, '555-1103', 'luis.rivas@email.com'),
(104, '555-1104', 'natalia.mendoza@email.com'),
(105, '555-1105', 'ernesto.fuentes@email.com'),
(106, '555-1106', 'viviana.cardoza@email.com'),
(107, '555-1107', 'jorge.alvarado@email.com'),
(108, '555-1108', 'lucia.arias@email.com'),
(109, '555-1109', 'sebastian.ramirez@email.com'),
(110, '555-1110', 'melissa.guzman@email.com'),
(111, '555-1111', 'hector.vargas@email.com'),
(112, '555-1112', 'adriana.moran@email.com'),
(113, '555-1113', 'fernando.ortiz@email.com'),
(114, '555-1114', 'ariana.delgado@email.com'),
(115, '555-1115', 'jesus.dominguez@email.com');

-- Contactos para Gym 2 (Usuarios 116-245)
INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(116, '555-1116', 'alejandro.miranda@email.com'),
(117, '555-1117', 'beatriz.carrera@email.com'),
(118, '555-1118', 'carlos.diaz@email.com'),
(119, '555-1119', 'diana.rivera@email.com'),
(120, '555-1120', 'eduardo.pacheco@email.com'),
(121, '555-1121', 'fernanda.ortega@email.com'),
(122, '555-1122', 'gustavo.quintana@email.com'),
(123, '555-1123', 'hilda.suarez@email.com'),
(124, '555-1124', 'ignacio.vega@email.com'),
(125, '555-1125', 'juliana.zamora@email.com'),
(126, '555-1126', 'ana.garcia2@email.com'),
(127, '555-1127', 'bruno.mendez2@email.com'),
(128, '555-1128', 'carla.ramos2@email.com'),
(129, '555-1129', 'diego.ortiz2@email.com'),
(130, '555-1130', 'elena.perez2@email.com'),
(131, '555-1131', 'fernando.lozano2@email.com'),
(132, '555-1132', 'gabriela.vega2@email.com'),
(133, '555-1133', 'hugo.ramirez2@email.com'),
(134, '555-1134', 'isabel.soto2@email.com'),
(135, '555-1135', 'javier.ruiz2@email.com'),
(136, '555-1136', 'karina.vargas2@email.com'),
(137, '555-1137', 'luis.medina2@email.com'),
(138, '555-1138', 'maria.castillo2@email.com'),
(139, '555-1139', 'nestor.gomez2@email.com'),
(140, '555-1140', 'olga.dominguez2@email.com'),
(141, '555-1141', 'pablo.herrera2@email.com'),
(142, '555-1142', 'quetzal.flores2@email.com'),
(143, '555-1143', 'rosa.jimenez2@email.com'),
(144, '555-1144', 'samuel.silva2@email.com'),
(145, '555-1145', 'teresa.maldonado2@email.com'),
(146, '555-1146', 'ulises.pineda2@email.com'),
(147, '555-1147', 'valeria.vargas2@email.com'),
(148, '555-1148', 'walter.salinas2@email.com'),
(149, '555-1149', 'ximena.nunez2@email.com'),
(150, '555-1150', 'yolanda.reyes2@email.com'),
(151, '555-1151', 'zacarias.torres2@email.com'),
(152, '555-1152', 'alejandra.romero2@email.com'),
(153, '555-1153', 'benjamin.ortega2@email.com'),
(154, '555-1154', 'cristina.guzman2@email.com'),
(155, '555-1155', 'daniel.luna2@email.com'),
(156, '555-1156', 'estefania.campos2@email.com'),
(157, '555-1157', 'felipe.tapia2@email.com'),
(158, '555-1158', 'gloria.santiago2@email.com'),
(159, '555-1159', 'hector.rios2@email.com'),
(160, '555-1160', 'ivana.fuentes2@email.com'),
(161, '555-1161', 'jorge.alvarado2@email.com'),
(162, '555-1162', 'karla.arias2@email.com'),
(163, '555-1163', 'leonardo.salazar2@email.com'),
(164, '555-1164', 'marta.mendoza2@email.com'),
(165, '555-1165', 'norberto.fuentes2@email.com'),
(166, '555-1166', 'olivia.cardoza2@email.com'),
(167, '555-1167', 'pedro.gonzalez2@email.com'),
(168, '555-1168', 'querida.morales2@email.com'),
(169, '555-1169', 'rafael.vega2@email.com'),
(170, '555-1170', 'sofia.luna2@email.com'),
(171, '555-1171', 'tomas.cruz2@email.com'),
(172, '555-1172', 'ursula.hernandez2@email.com'),
(173, '555-1173', 'victor.valle2@email.com'),
(174, '555-1174', 'wendy.gutierrez2@email.com'),
(175, '555-1175', 'xavier.navarro2@email.com'),
(176, '555-1176', 'yadira.espinoza2@email.com'),
(177, '555-1177', 'zulema.castillo2@email.com'),
(178, '555-1178', 'alvaro.maldonado2@email.com'),
(179, '555-1179', 'brenda.delgado2@email.com'),
(180, '555-1180', 'cesar.quintanilla2@email.com'),
(181, '555-1181', 'diana.suarez2@email.com'),
(182, '555-1182', 'erika.ortiz2@email.com'),
(183, '555-1183', 'fernando.mendez2@email.com'),
(184, '555-1184', 'gabriela.pacheco2@email.com'),
(185, '555-1185', 'horacio.ramirez2@email.com'),
(186, '555-1186', 'isabela.santos2@email.com'),
(187, '555-1187', 'javier.reyes2@email.com'),
(188, '555-1188', 'kenia.mendez2@email.com'),
(189, '555-1189', 'lorenzo.rodriguez2@email.com'),
(190, '555-1190', 'marina.jimenez2@email.com'),
(191, '555-1191', 'nicolas.flores2@email.com'),
(192, '555-1192', 'olga.sanchez2@email.com'),
(193, '555-1193', 'pablo.dominguez2@email.com'),
(194, '555-1194', 'raquel.vargas2@email.com'),
(195, '555-1195', 'santiago.luna2@email.com'),
(196, '555-1196', 'teresa.salazar2@email.com'),
(197, '555-1197', 'ulises.gomez2@email.com'),
(198, '555-1198', 'valeria.medina2@email.com'),
(199, '555-1199', 'willy.pena2@email.com'),
(200, '555-1200', 'ximena.campos2@email.com'),
(201, '555-1201', 'yuri.soto2@email.com'),
(202, '555-1202', 'zacarias.morales2@email.com'),
(203, '555-1203', 'adriana.gonzalez2@email.com'),
(204, '555-1204', 'blas.hernandez2@email.com'),
(205, '555-1205', 'cecilia.jimenez2@email.com'),
(206, '555-1206', 'david.navarro2@email.com'),
(207, '555-1207', 'estela.duarte2@email.com'),
(208, '555-1208', 'francisco.alvarez2@email.com'),
(209, '555-1209', 'gema.rodriguez2@email.com'),
(210, '555-1210', 'horacio.munoz2@email.com'),
(211, '555-1211', 'irene.torres2@email.com'),
(212, '555-1212', 'joel.valle2@email.com'),
(213, '555-1213', 'karla.vargas2@email.com'),
(214, '555-1214', 'leonor.garcia2@email.com'),
(215, '555-1215', 'mauro.silva2@email.com'),
(216, '555-1216', 'nadia.rios2@email.com'),
(217, '555-1217', 'oscar.castro2@email.com'),
(218, '555-1218', 'paula.cruz2@email.com'),
(219, '555-1219', 'quintina.vega2@email.com'),
(220, '555-1220', 'ricardo.morales2@email.com'),
(221, '555-1221', 'sandra.paredes2@email.com'),
(222, '555-1222', 'tomas.ortiz2@email.com'),
(223, '555-1223', 'ursula.tapia2@email.com'),
(224, '555-1224', 'victor.soto2@email.com'),
(225, '555-1225', 'wendy.gutierrez3@email.com'),
(226, '555-1226', 'xavier.navarro3@email.com'),
(227, '555-1227', 'yadira.espinoza3@email.com'),
(228, '555-1228', 'zulema.castillo3@email.com'),
(229, '555-1229', 'alvaro.maldonado3@email.com'),
(230, '555-1230', 'brenda.delgado3@email.com'),
(231, '555-1231', 'cesar.quintanilla3@email.com'),
(232, '555-1232', 'diana.suarez3@email.com'),
(233, '555-1233', 'erika.ortiz3@email.com'),
(234, '555-1234', 'fernando.mendez3@email.com'),
(235, '555-1235', 'gabriela.pacheco3@email.com'),
(236, '555-1236', 'hector.ramirez3@email.com'),
(237, '555-1237', 'isabela.santos3@email.com'),
(238, '555-1238', 'javier.reyes3@email.com'),
(239, '555-1239', 'kenia.mendez3@email.com'),
(240, '555-1240', 'lorenzo.rodriguez3@email.com'),
(241, '555-1241', 'marina.jimenez3@email.com'),
(242, '555-1242', 'nicolas.flores3@email.com'),
(243, '555-1243', 'olga.sanchez3@email.com'),
(244, '555-1244', 'pablo.dominguez3@email.com'),
(245, '555-1245', 'raquel.vargas3@email.com');


-- Contactos para Gym 3 (Usuarios 246-337)
INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(246, '555-1246', 'jorge.ortiz3@email.com'),
(247, '555-1247', 'ana.rivera3@email.com'),
(248, '555-1248', 'carlos.salinas3@email.com'),
(249, '555-1249', 'maria.gomez3@email.com'),
(250, '555-1250', 'fernando.pacheco3@email.com'),
(251, '555-1251', 'lucia.vargas3@email.com'),
(252, '555-1252', 'andres.mendez3@email.com'),
(253, '555-1253', 'patricia.nunez3@email.com'),
(254, '555-1254', 'ricardo.morales3@email.com'),
(255, '555-1255', 'sofia.rios3@email.com'),
(256, '555-1256', 'diego.torres3@email.com'),
(257, '555-1257', 'carolina.castillo3@email.com'),
(258, '555-1258', 'ana.garcia3@email.com'),
(259, '555-1259', 'bruno.mendez3@email.com'),
(260, '555-1260', 'carla.ramos3@email.com'),
(261, '555-1261', 'diego.ortiz3@email.com'),
(262, '555-1262', 'elena.perez3@email.com'),
(263, '555-1263', 'fernando.lozano3@email.com'),
(264, '555-1264', 'gabriela.vega3@email.com'),
(265, '555-1265', 'hugo.ramirez3@email.com'),
(266, '555-1266', 'isabel.soto3@email.com'),
(267, '555-1267', 'javier.ruiz3@email.com'),
(268, '555-1268', 'karina.vargas3@email.com'),
(269, '555-1269', 'luis.medina3@email.com'),
(270, '555-1270', 'maria.castillo3@email.com'),
(271, '555-1271', 'nestor.gomez3@email.com'),
(272, '555-1272', 'olga.dominguez3@email.com'),
(273, '555-1273', 'pablo.herrera3@email.com'),
(274, '555-1274', 'quetzal.flores3@email.com'),
(275, '555-1275', 'rosa.jimenez3@email.com'),
(276, '555-1276', 'samuel.silva3@email.com'),
(277, '555-1277', 'teresa.maldonado3@email.com'),
(278, '555-1278', 'ulises.pineda3@email.com'),
(279, '555-1279', 'valeria.vargas3@email.com'),
(280, '555-1280', 'walter.salinas3@email.com'),
(281, '555-1281', 'ximena.nunez3@email.com'),
(282, '555-1282', 'yolanda.reyes3@email.com'),
(283, '555-1283', 'zacarias.torres3@email.com'),
(284, '555-1284', 'alejandra.romero3@email.com'),
(285, '555-1285', 'benjamin.ortega3@email.com'),
(286, '555-1286', 'cristina.guzman3@email.com'),
(287, '555-1287', 'daniel.luna3@email.com'),
(288, '555-1288', 'estefania.campos3@email.com'),
(289, '555-1289', 'felipe.tapia3@email.com'),
(290, '555-1290', 'gloria.santiago3@email.com'),
(291, '555-1291', 'hector.rios3@email.com'),
(292, '555-1292', 'ivana.fuentes3@email.com'),
(293, '555-1293', 'jorge.alvarado3@email.com'),
(294, '555-1294', 'karla.arias3@email.com'),
(295, '555-1295', 'leonardo.salazar3@email.com'),
(296, '555-1296', 'marta.mendoza3@email.com'),
(297, '555-1297', 'norberto.fuentes3@email.com'),
(298, '555-1298', 'olivia.cardoza3@email.com'),
(299, '555-1299', 'pedro.gonzalez3@email.com'),
(300, '555-1300', 'querida.morales3@email.com'),
(301, '555-1301', 'rafael.vega3@email.com'),
(302, '555-1302', 'sofia.luna3@email.com'),
(303, '555-1303', 'tomas.cruz3@email.com'),
(304, '555-1304', 'ursula.hernandez3@email.com'),
(305, '555-1305', 'victor.valle3@email.com'),
(306, '555-1306', 'wendy.gutierrez4@email.com'),
(307, '555-1307', 'xavier.navarro4@email.com'),
(308, '555-1308', 'yadira.espinoza4@email.com'),
(309, '555-1309', 'zulema.castillo4@email.com'),
(310, '555-1310', 'alvaro.maldonado4@email.com'),
(311, '555-1311', 'brenda.delgado4@email.com'),
(312, '555-1312', 'cesar.quintanilla4@email.com'),
(313, '555-1313', 'diana.suarez4@email.com'),
(314, '555-1314', 'erika.ortiz4@email.com'),
(315, '555-1315', 'fernando.mendez4@email.com'),
(316, '555-1316', 'gabriela.pacheco4@email.com'),
(317, '555-1317', 'horacio.ramirez4@email.com'),
(318, '555-1318', 'isabela.santos4@email.com'),
(319, '555-1319', 'javier.reyes4@email.com'),
(320, '555-1320', 'kenia.mendez4@email.com'),
(321, '555-1321', 'lorenzo.rodriguez4@email.com'),
(322, '555-1322', 'marina.jimenez4@email.com'),
(323, '555-1323', 'nicolas.flores4@email.com'),
(324, '555-1324', 'olga.sanchez4@email.com'),
(325, '555-1325', 'pablo.dominguez4@email.com'),
(326, '555-1326', 'raquel.vargas4@email.com'),
(327, '555-1327', 'santiago.luna4@email.com'),
(328, '555-1328', 'teresa.salazar4@email.com'),
(329, '555-1329', 'ulises.gomez4@email.com'),
(330, '555-1330', 'valeria.medina4@email.com'),
(331, '555-1331', 'willy.pena4@email.com'),
(332, '555-1332', 'ximena.campos4@email.com'),
(333, '555-1333', 'yuri.soto4@email.com'),
(334, '555-1334', 'zacarias.morales4@email.com'),
(335, '555-1335', 'adriana.gonzalez4@email.com'),
(336, '555-1336', 'blas.hernandez4@email.com'),
(337, '555-1337', 'cecilia.jimenez4@email.com');

-- Contactos para Gym 4 (Usuarios 338-449)
INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(338, '555-1338', 'alejandro.martinez4@email.com'),
(339, '555-1339', 'beatriz.garcia4@email.com'),
(340, '555-1340', 'carlos.ramirez4@email.com'),
(341, '555-1341', 'diana.sanchez4@email.com'),
(342, '555-1342', 'eduardo.vargas4@email.com'),
(343, '555-1343', 'fernanda.ortiz4@email.com'),
(344, '555-1344', 'gustavo.perez4@email.com'),
(345, '555-1345', 'hilda.mendez4@email.com'),
(346, '555-1346', 'ignacio.ruiz4@email.com'),
(347, '555-1347', 'juliana.torres4@email.com'),
(348, '555-1348', 'karla.silva4@email.com'),
(349, '555-1349', 'leonardo.nunez4@email.com'),
(350, '555-1350', 'ana.garcia4@email.com'),
(351, '555-1351', 'bruno.mendez4@email.com'),
(352, '555-1352', 'carla.ramos4@email.com'),
(353, '555-1353', 'diego.ortiz4@email.com'),
(354, '555-1354', 'elena.perez4@email.com'),
(355, '555-1355', 'fernando.lozano4@email.com'),
(356, '555-1356', 'gabriela.vega4@email.com'),
(357, '555-1357', 'hugo.ramirez4@email.com'),
(358, '555-1358', 'isabel.soto4@email.com'),
(359, '555-1359', 'javier.ruiz4@email.com'),
(360, '555-1360', 'karina.vargas4@email.com'),
(361, '555-1361', 'luis.medina4@email.com'),
(362, '555-1362', 'maria.castillo4@email.com'),
(363, '555-1363', 'nestor.gomez4@email.com'),
(364, '555-1364', 'olga.dominguez4@email.com'),
(365, '555-1365', 'pablo.herrera4@email.com'),
(366, '555-1366', 'quetzal.flores4@email.com'),
(367, '555-1367', 'rosa.jimenez4@email.com'),
(368, '555-1368', 'samuel.silva4@email.com'),
(369, '555-1369', 'teresa.maldonado4@email.com'),
(370, '555-1370', 'ulises.pineda4@email.com'),
(371, '555-1371', 'valeria.vargas4@email.com'),
(372, '555-1372', 'walter.salinas4@email.com'),
(373, '555-1373', 'ximena.nunez4@email.com'),
(374, '555-1374', 'yolanda.reyes4@email.com'),
(375, '555-1375', 'zacarias.torres4@email.com'),
(376, '555-1376', 'alejandra.romero4@email.com'),
(377, '555-1377', 'benjamin.ortega4@email.com'),
(378, '555-1378', 'cristina.guzman4@email.com'),
(379, '555-1379', 'daniel.luna4@email.com'),
(380, '555-1380', 'estefania.campos4@email.com'),
(381, '555-1381', 'felipe.tapia4@email.com'),
(382, '555-1382', 'gloria.santiago4@email.com'),
(383, '555-1383', 'hector.rios4@email.com'),
(384, '555-1384', 'ivana.fuentes4@email.com'),
(385, '555-1385', 'jorge.alvarado4@email.com'),
(386, '555-1386', 'karla.arias4@email.com'),
(387, '555-1387', 'leonardo.salazar4@email.com'),
(388, '555-1388', 'marta.mendoza4@email.com'),
(389, '555-1389', 'norberto.fuentes4@email.com'),
(390, '555-1390', 'olivia.cardoza4@email.com'),
(391, '555-1391', 'pedro.gonzalez4@email.com'),
(392, '555-1392', 'querida.morales4@email.com'),
(393, '555-1393', 'rafael.vega4@email.com'),
(394, '555-1394', 'sofia.luna4@email.com'),
(395, '555-1395', 'tomas.cruz4@email.com'),
(396, '555-1396', 'ursula.hernandez4@email.com'),
(397, '555-1397', 'victor.valle4@email.com'),
(398, '555-1398', 'wendy.gutierrez5@email.com'),
(399, '555-1399', 'xavier.navarro5@email.com'),
(400, '555-1400', 'yadira.espinoza5@email.com'),
(401, '555-1401', 'zulema.castillo5@email.com'),
(402, '555-1402', 'alvaro.maldonado5@email.com'),
(403, '555-1403', 'brenda.delgado5@email.com'),
(404, '555-1404', 'cesar.quintanilla5@email.com'),
(405, '555-1405', 'diana.suarez5@email.com'),
(406, '555-1406', 'erika.ortiz5@email.com'),
(407, '555-1407', 'fernando.mendez5@email.com'),
(408, '555-1408', 'gabriela.pacheco5@email.com'),
(409, '555-1409', 'horacio.ramirez5@email.com'),
(410, '555-1410', 'isabela.santos5@email.com'),
(411, '555-1411', 'javier.reyes5@email.com'),
(412, '555-1412', 'kenia.mendez5@email.com'),
(413, '555-1413', 'lorenzo.rodriguez5@email.com'),
(414, '555-1414', 'marina.jimenez5@email.com'),
(415, '555-1415', 'nicolas.flores5@email.com'),
(416, '555-1416', 'olga.sanchez5@email.com'),
(417, '555-1417', 'pablo.dominguez5@email.com'),
(418, '555-1418', 'raquel.vargas5@email.com'),
(419, '555-1419', 'santiago.luna5@email.com'),
(420, '555-1420', 'teresa.salazar5@email.com'),
(421, '555-1421', 'ulises.gomez5@email.com'),
(422, '555-1422', 'valeria.medina5@email.com'),
(423, '555-1423', 'willy.pena5@email.com'),
(424, '555-1424', 'ximena.campos5@email.com'),
(425, '555-1425', 'yuri.soto5@email.com'),
(426, '555-1426', 'zacarias.morales5@email.com'),
(427, '555-1427', 'adriana.gonzalez5@email.com'),
(428, '555-1428', 'blas.hernandez5@email.com'),
(429, '555-1429', 'cecilia.jimenez5@email.com'),
(430, '555-1430', 'david.navarro5@email.com'),
(431, '555-1431', 'estela.duarte5@email.com'),
(432, '555-1432', 'francisco.alvarez5@email.com'),
(433, '555-1433', 'gema.rodriguez5@email.com'),
(434, '555-1434', 'horacio.munoz5@email.com'),
(435, '555-1435', 'irene.torres5@email.com'),
(436, '555-1436', 'joel.valle5@email.com'),
(437, '555-1437', 'karla.vargas5@email.com'),
(438, '555-1438', 'leonor.garcia5@email.com'),
(439, '555-1439', 'mauro.silva5@email.com'),
(440, '555-1440', 'nadia.rios5@email.com'),
(441, '555-1441', 'oscar.castro5@email.com'),
(442, '555-1442', 'paula.cruz5@email.com'),
(443, '555-1443', 'quintina.vega5@email.com'),
(444, '555-1444', 'ricardo.morales5@email.com'),
(445, '555-1445', 'sandra.paredes5@email.com'),
(446, '555-1446', 'tomas.ortiz5@email.com'),
(447, '555-1447', 'ursula.tapia5@email.com'),
(448, '555-1448', 'victor.soto5@email.com'),
(449, '555-1449', 'wendy.gutierrez6@email.com');

-- Contactos para Gym 5 (Usuarios 450-609)
INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(450, '555-1450', 'andres.mora5@email.com'),
(451, '555-1451', 'beatriz.castro5@email.com'),
(452, '555-1452', 'carlos.jimenez5@email.com'),
(453, '555-1453', 'diana.hernandez5@email.com'),
(454, '555-1454', 'eduardo.vargas5@email.com'),
(455, '555-1455', 'fernanda.ortega5@email.com'),
(456, '555-1456', 'gustavo.pacheco5@email.com'),
(457, '555-1457', 'hilda.suarez5@email.com'),
(458, '555-1458', 'ignacio.ruiz5@email.com'),
(459, '555-1459', 'juliana.torres5@email.com'),
(460, '555-1460', 'ana.garcia5@email.com'),
(461, '555-1461', 'bruno.mendez5@email.com'),
(462, '555-1462', 'carla.ramos5@email.com'),
(463, '555-1463', 'diego.ortiz5@email.com'),
(464, '555-1464', 'elena.perez5@email.com'),
(465, '555-1465', 'fernando.lozano5@email.com'),
(466, '555-1466', 'gabriela.vega5@email.com'),
(467, '555-1467', 'hugo.ramirez5@email.com'),
(468, '555-1468', 'isabel.soto5@email.com'),
(469, '555-1469', 'javier.ruiz5@email.com'),
(470, '555-1470', 'karina.vargas5@email.com'),
(471, '555-1471', 'luis.medina5@email.com'),
(472, '555-1472', 'maria.castillo5@email.com'),
(473, '555-1473', 'nestor.gomez5@email.com'),
(474, '555-1474', 'olga.dominguez5@email.com'),
(475, '555-1475', 'pablo.herrera5@email.com'),
(476, '555-1476', 'quetzal.flores5@email.com'),
(477, '555-1477', 'rosa.jimenez5@email.com'),
(478, '555-1478', 'samuel.silva5@email.com'),
(479, '555-1479', 'teresa.maldonado5@email.com'),
(480, '555-1480', 'ulises.pineda5@email.com'),
(481, '555-1481', 'valeria.vargas5@email.com'),
(482, '555-1482', 'walter.salinas5@email.com'),
(483, '555-1483', 'ximena.nunez5@email.com'),
(484, '555-1484', 'yolanda.reyes5@email.com'),
(485, '555-1485', 'zacarias.torres5@email.com'),
(486, '555-1486', 'alejandra.romero5@email.com'),
(487, '555-1487', 'benjamin.ortega5@email.com'),
(488, '555-1488', 'cristina.guzman5@email.com'),
(489, '555-1489', 'daniel.luna5@email.com'),
(490, '555-1490', 'estefania.campos5@email.com'),
(491, '555-1491', 'felipe.tapia5@email.com'),
(492, '555-1492', 'gloria.santiago5@email.com'),
(493, '555-1493', 'hector.rios5@email.com'),
(494, '555-1494', 'ivana.fuentes5@email.com'),
(495, '555-1495', 'jorge.alvarado5@email.com'),
(496, '555-1496', 'karla.arias5@email.com'),
(497, '555-1497', 'leonardo.salazar5@email.com'),
(498, '555-1498', 'marta.mendoza5@email.com'),
(499, '555-1499', 'norberto.fuentes5@email.com'),
(500, '555-1500', 'olivia.cardoza5@email.com'),
(501, '555-1501', 'pedro.gonzalez5@email.com'),
(502, '555-1502', 'querida.morales5@email.com'),
(503, '555-1503', 'rafael.vega5@email.com'),
(504, '555-1504', 'sofia.luna5@email.com'),
(505, '555-1505', 'tomas.cruz5@email.com'),
(506, '555-1506', 'ursula.hernandez5@email.com'),
(507, '555-1507', 'victor.valle5@email.com'),
(508, '555-1508', 'wendy.gutierrez7@email.com'),
(509, '555-1509', 'xavier.navarro6@email.com'),
(510, '555-1510', 'yadira.espinoza6@email.com'),
(511, '555-1511', 'zulema.castillo6@email.com'),
(512, '555-1512', 'alvaro.maldonado6@email.com'),
(513, '555-1513', 'brenda.delgado6@email.com'),
(514, '555-1514', 'cesar.quintanilla6@email.com'),
(515, '555-1515', 'diana.suarez6@email.com'),
(516, '555-1516', 'erika.ortiz6@email.com'),
(517, '555-1517', 'fernando.mendez6@email.com'),
(518, '555-1518', 'gabriela.pacheco6@email.com'),
(519, '555-1519', 'horacio.ramirez6@email.com'),
(520, '555-1520', 'isabela.santos6@email.com'),
(521, '555-1521', 'javier.reyes6@email.com'),
(522, '555-1522', 'kenia.mendez6@email.com'),
(523, '555-1523', 'lorenzo.rodriguez6@email.com'),
(524, '555-1524', 'marina.jimenez6@email.com'),
(525, '555-1525', 'nicolas.flores6@email.com'),
(526, '555-1526', 'olga.sanchez6@email.com'),
(527, '555-1527', 'pablo.dominguez6@email.com'),
(528, '555-1528', 'raquel.vargas6@email.com'),
(529, '555-1529', 'santiago.luna6@email.com'),
(530, '555-1530', 'teresa.salazar6@email.com'),
(531, '555-1531', 'ulises.gomez6@email.com'),
(532, '555-1532', 'valeria.medina6@email.com'),
(533, '555-1533', 'willy.pena6@email.com'),
(534, '555-1534', 'ximena.campos6@email.com'),
(535, '555-1535', 'yuri.soto6@email.com'),
(536, '555-1536', 'zacarias.morales6@email.com'),
(537, '555-1537', 'adriana.gonzalez6@email.com'),
(538, '555-1538', 'blas.hernandez6@email.com'),
(539, '555-1539', 'cecilia.jimenez6@email.com'),
(540, '555-1540', 'david.navarro6@email.com'),
(541, '555-1541', 'estela.duarte6@email.com'),
(542, '555-1542', 'francisco.alvarez6@email.com'),
(543, '555-1543', 'gema.rodriguez6@email.com'),
(544, '555-1544', 'horacio.munoz6@email.com'),
(545, '555-1545', 'irene.torres6@email.com'),
(546, '555-1546', 'joel.valle6@email.com'),
(547, '555-1547', 'karla.vargas6@email.com'),
(548, '555-1548', 'leonor.garcia6@email.com'),
(549, '555-1549', 'mauro.silva6@email.com'),
(550, '555-1550', 'nadia.rios6@email.com'),
(551, '555-1551', 'oscar.castro6@email.com'),
(552, '555-1552', 'paula.cruz6@email.com'),
(553, '555-1553', 'quintina.vega6@email.com'),
(554, '555-1554', 'ricardo.morales6@email.com'),
(555, '555-1555', 'sandra.paredes6@email.com'),
(556, '555-1556', 'tomas.ortiz6@email.com'),
(557, '555-1557', 'ursula.tapia6@email.com'),
(558, '555-1558', 'victor.soto6@email.com'),
(559, '555-1559', 'wendy.gutierrez8@email.com'),
(560, '555-1560', 'xavier.navarro7@email.com'),
(561, '555-1561', 'yadira.espinoza7@email.com'),
(562, '555-1562', 'zulema.castillo7@email.com'),
(563, '555-1563', 'alvaro.maldonado7@email.com'),
(564, '555-1564', 'brenda.delgado7@email.com'),
(565, '555-1565', 'cesar.quintanilla7@email.com'),
(566, '555-1566', 'diana.suarez7@email.com'),
(567, '555-1567', 'erika.ortiz7@email.com'),
(568, '555-1568', 'fernando.mendez7@email.com'),
(569, '555-1569', 'gabriela.pacheco7@email.com'),
(570, '555-1570', 'horacio.ramirez7@email.com'),
(571, '555-1571', 'isabela.santos7@email.com'),
(572, '555-1572', 'javier.reyes7@email.com'),
(573, '555-1573', 'kenia.mendez7@email.com'),
(574, '555-1574', 'lorenzo.rodriguez7@email.com'),
(575, '555-1575', 'marina.jimenez7@email.com'),
(576, '555-1576', 'nicolas.flores7@email.com'),
(577, '555-1577', 'olga.sanchez7@email.com'),
(578, '555-1578', 'pablo.dominguez7@email.com'),
(579, '555-1579', 'raquel.vargas7@email.com'),
(580, '555-1580', 'santiago.luna7@email.com'),
(581, '555-1581', 'teresa.salazar7@email.com'),
(582, '555-1582', 'ulises.gomez7@email.com'),
(583, '555-1583', 'valeria.medina7@email.com'),
(584, '555-1584', 'willy.pena7@email.com'),
(585, '555-1585', 'ximena.campos7@email.com'),
(586, '555-1586', 'yuri.soto7@email.com'),
(587, '555-1587', 'zacarias.morales7@email.com'),
(588, '555-1588', 'adriana.gonzalez7@email.com'),
(589, '555-1589', 'blas.hernandez7@email.com'),
(590, '555-1590', 'cecilia.jimenez7@email.com'),
(591, '555-1591', 'david.navarro7@email.com'),
(592, '555-1592', 'estela.duarte7@email.com'),
(593, '555-1593', 'francisco.alvarez7@email.com'),
(594, '555-1594', 'gema.rodriguez7@email.com'),
(595, '555-1595', 'horacio.munoz7@email.com'),
(596, '555-1596', 'irene.torres7@email.com'),
(597, '555-1597', 'joel.valle7@email.com'),
(598, '555-1598', 'karla.vargas7@email.com'),
(599, '555-1599', 'leonor.garcia7@email.com'),
(600, '555-1600', 'mauro.silva7@email.com'),
(601, '555-1601', 'nadia.rios7@email.com'),
(602, '555-1602', 'oscar.castro7@email.com'),
(603, '555-1603', 'paula.cruz7@email.com'),
(604, '555-1604', 'quintina.vega7@email.com'),
(605, '555-1605', 'ricardo.morales7@email.com'),
(606, '555-1606', 'sandra.paredes7@email.com'),
(607, '555-1607', 'tomas.ortiz7@email.com'),
(608, '555-1608', 'ursula.tapia7@email.com'),
(609, '555-1609', 'victor.soto7@email.com');


INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(610, '555-1610', 'andres.lopez6@email.com'),
(611, '555-1611', 'beatriz.martinez6@email.com'),
(612, '555-1612', 'carlos.ramirez6@email.com'),
(613, '555-1613', 'diana.santos6@email.com'),
(614, '555-1614', 'eduardo.vargas6@email.com'),
(615, '555-1615', 'fernanda.ortega6@email.com'),
(616, '555-1616', 'gustavo.pacheco6@email.com'),
(617, '555-1617', 'hilda.suarez6@email.com'),
(618, '555-1618', 'ignacio.ruiz6@email.com'),
(619, '555-1619', 'juliana.torres6@email.com'),
(620, '555-1620', 'ana.garcia6@email.com'),
(621, '555-1621', 'bruno.mendez6@email.com'),
(622, '555-1622', 'carla.ramos6@email.com'),
(623, '555-1623', 'diego.ortiz6@email.com'),
(624, '555-1624', 'elena.perez6@email.com'),
(625, '555-1625', 'fernando.lozano6@email.com'),
(626, '555-1626', 'gabriela.vega6@email.com'),
(627, '555-1627', 'hugo.ramirez6@email.com'),
(628, '555-1628', 'isabel.soto6@email.com'),
(629, '555-1629', 'javier.ruiz6@email.com'),
(630, '555-1630', 'karina.vargas6@email.com'),
(631, '555-1631', 'luis.medina6@email.com'),
(632, '555-1632', 'maria.castillo6@email.com'),
(633, '555-1633', 'nestor.gomez6@email.com'),
(634, '555-1634', 'olga.dominguez6@email.com'),
(635, '555-1635', 'pablo.herrera6@email.com'),
(636, '555-1636', 'quetzal.flores6@email.com'),
(637, '555-1637', 'rosa.jimenez6@email.com'),
(638, '555-1638', 'samuel.silva6@email.com'),
(639, '555-1639', 'teresa.maldonado6@email.com'),
(640, '555-1640', 'ulises.pineda6@email.com'),
(641, '555-1641', 'valeria.vargas6@email.com'),
(642, '555-1642', 'walter.salinas6@email.com'),
(643, '555-1643', 'ximena.nunez6@email.com'),
(644, '555-1644', 'yolanda.reyes6@email.com'),
(645, '555-1645', 'zacarias.torres6@email.com'),
(646, '555-1646', 'alejandra.romero6@email.com'),
(647, '555-1647', 'benjamin.ortega6@email.com'),
(648, '555-1648', 'cristina.guzman6@email.com'),
(649, '555-1649', 'daniel.luna6@email.com'),
(650, '555-1650', 'estefania.campos6@email.com'),
(651, '555-1651', 'felipe.tapia6@email.com'),
(652, '555-1652', 'gloria.santiago6@email.com'),
(653, '555-1653', 'hector.rios6@email.com'),
(654, '555-1654', 'ivana.fuentes6@email.com'),
(655, '555-1655', 'jorge.alvarado6@email.com'),
(656, '555-1656', 'karla.arias6@email.com'),
(657, '555-1657', 'leonardo.salazar6@email.com'),
(658, '555-1658', 'marta.mendoza6@email.com'),
(659, '555-1659', 'norberto.fuentes6@email.com'),
(660, '555-1660', 'olivia.cardoza6@email.com'),
(661, '555-1661', 'pedro.gonzalez6@email.com'),
(662, '555-1662', 'querida.morales6@email.com'),
(663, '555-1663', 'rafael.vega6@email.com'),
(664, '555-1664', 'sofia.luna6@email.com'),
(665, '555-1665', 'tomas.cruz6@email.com'),
(666, '555-1666', 'ursula.hernandez6@email.com'),
(667, '555-1667', 'victor.valle6@email.com'),
(668, '555-1668', 'wendy.gutierrez9@email.com'),
(669, '555-1669', 'xavier.navarro8@email.com'),
(670, '555-1670', 'yadira.espinoza8@email.com'),
(671, '555-1671', 'zulema.castillo8@email.com'),
(672, '555-1672', 'alvaro.maldonado8@email.com'),
(673, '555-1673', 'brenda.delgado8@email.com'),
(674, '555-1674', 'cesar.quintanilla8@email.com'),
(675, '555-1675', 'diana.suarez8@email.com'),
(676, '555-1676', 'erika.ortiz8@email.com'),
(677, '555-1677', 'fernando.mendez8@email.com'),
(678, '555-1678', 'gabriela.pacheco8@email.com'),
(679, '555-1679', 'horacio.ramirez8@email.com'),
(680, '555-1680', 'isabela.santos8@email.com'),
(681, '555-1681', 'javier.reyes8@email.com'),
(682, '555-1682', 'kenia.mendez8@email.com'),
(683, '555-1683', 'lorenzo.rodriguez8@email.com'),
(684, '555-1684', 'marina.jimenez8@email.com'),
(685, '555-1685', 'nicolas.flores8@email.com'),
(686, '555-1686', 'olga.sanchez8@email.com'),
(687, '555-1687', 'pablo.dominguez8@email.com'),
(688, '555-1688', 'raquel.vargas8@email.com'),
(689, '555-1689', 'santiago.luna8@email.com'),
(690, '555-1690', 'teresa.salazar8@email.com'),
(691, '555-1691', 'ulises.gomez8@email.com'),
(692, '555-1692', 'valeria.medina8@email.com'),
(693, '555-1693', 'willy.pena8@email.com'),
(694, '555-1694', 'ximena.campos8@email.com'),
(695, '555-1695', 'yuri.soto8@email.com'),
(696, '555-1696', 'zacarias.morales8@email.com'),
(697, '555-1697', 'adriana.gonzalez8@email.com'),
(698, '555-1698', 'blas.hernandez8@email.com'),
(699, '555-1699', 'cecilia.jimenez8@email.com');

-- Contactos para Gym 7 (Usuarios 700-789)
INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(700, '555-1700', 'andres.flores7@email.com'),
(701, '555-1701', 'beatriz.morales7@email.com'),
(702, '555-1702', 'carlos.ramirez7@email.com'),
(703, '555-1703', 'diana.santos7@email.com'),
(704, '555-1704', 'eduardo.vargas7@email.com'),
(705, '555-1705', 'fernanda.ortega7@email.com'),
(706, '555-1706', 'gustavo.pacheco7@email.com'),
(707, '555-1707', 'hilda.suarez7@email.com'),
(708, '555-1708', 'ignacio.ruiz7@email.com'),
(709, '555-1709', 'juliana.torres7@email.com'),
(710, '555-1710', 'ana.garcia7@email.com'),
(711, '555-1711', 'bruno.mendez7@email.com'),
(712, '555-1712', 'carla.ramos7@email.com'),
(713, '555-1713', 'diego.ortiz7@email.com'),
(714, '555-1714', 'elena.perez7@email.com'),
(715, '555-1715', 'fernando.lozano7@email.com'),
(716, '555-1716', 'gabriela.vega7@email.com'),
(717, '555-1717', 'hugo.ramirez7@email.com'),
(718, '555-1718', 'isabel.soto7@email.com'),
(719, '555-1719', 'javier.ruiz7@email.com'),
(720, '555-1720', 'karina.vargas7@email.com'),
(721, '555-1721', 'luis.medina7@email.com'),
(722, '555-1722', 'maria.castillo7@email.com'),
(723, '555-1723', 'nestor.gomez7@email.com'),
(724, '555-1724', 'olga.dominguez7@email.com'),
(725, '555-1725', 'pablo.herrera7@email.com'),
(726, '555-1726', 'quetzal.flores7@email.com'),
(727, '555-1727', 'rosa.jimenez7@email.com'),
(728, '555-1728', 'samuel.silva7@email.com'),
(729, '555-1729', 'teresa.maldonado7@email.com'),
(730, '555-1730', 'ulises.pineda7@email.com'),
(731, '555-1731', 'valeria.vargas7@email.com'),
(732, '555-1732', 'walter.salinas7@email.com'),
(733, '555-1733', 'ximena.nunez7@email.com'),
(734, '555-1734', 'yolanda.reyes7@email.com'),
(735, '555-1735', 'zacarias.torres7@email.com'),
(736, '555-1736', 'alejandra.romero7@email.com'),
(737, '555-1737', 'benjamin.ortega7@email.com'),
(738, '555-1738', 'cristina.guzman7@email.com'),
(739, '555-1739', 'daniel.luna7@email.com'),
(740, '555-1740', 'estefania.campos7@email.com'),
(741, '555-1741', 'felipe.tapia7@email.com'),
(742, '555-1742', 'gloria.santiago7@email.com'),
(743, '555-1743', 'hector.rios7@email.com'),
(744, '555-1744', 'ivana.fuentes7@email.com'),
(745, '555-1745', 'jorge.alvarado7@email.com'),
(746, '555-1746', 'karla.arias7@email.com'),
(747, '555-1747', 'leonardo.salazar7@email.com'),
(748, '555-1748', 'marta.mendoza7@email.com'),
(749, '555-1749', 'norberto.fuentes7@email.com'),
(750, '555-1750', 'olivia.cardoza7@email.com'),
(751, '555-1751', 'pedro.gonzalez7@email.com'),
(752, '555-1752', 'querida.morales7@email.com'),
(753, '555-1753', 'rafael.vega7@email.com'),
(754, '555-1754', 'sofia.luna7@email.com'),
(755, '555-1755', 'tomas.cruz7@email.com'),
(756, '555-1756', 'ursula.hernandez7@email.com'),
(757, '555-1757', 'victor.valle7@email.com'),
(758, '555-1758', 'wendy.gutierrez10@email.com'),
(759, '555-1759', 'xavier.navarro9@email.com'),
(760, '555-1760', 'yadira.espinoza9@email.com'),
(761, '555-1761', 'zulema.castillo9@email.com'),
(762, '555-1762', 'alvaro.maldonado9@email.com'),
(763, '555-1763', 'brenda.delgado9@email.com'),
(764, '555-1764', 'cesar.quintanilla9@email.com'),
(765, '555-1765', 'diana.suarez9@email.com'),
(766, '555-1766', 'erika.ortiz9@email.com'),
(767, '555-1767', 'fernando.mendez9@email.com'),
(768, '555-1768', 'gabriela.pacheco9@email.com'),
(769, '555-1769', 'horacio.ramirez9@email.com'),
(770, '555-1770', 'isabela.santos9@email.com'),
(771, '555-1771', 'javier.reyes9@email.com'),
(772, '555-1772', 'kenia.mendez9@email.com'),
(773, '555-1773', 'lorenzo.rodriguez9@email.com'),
(774, '555-1774', 'marina.jimenez9@email.com'),
(775, '555-1775', 'nicolas.flores9@email.com'),
(776, '555-1776', 'olga.sanchez9@email.com'),
(777, '555-1777', 'pablo.dominguez9@email.com'),
(778, '555-1778', 'raquel.vargas9@email.com'),
(779, '555-1779', 'santiago.luna9@email.com'),
(780, '555-1780', 'teresa.salazar9@email.com'),
(781, '555-1781', 'ulises.gomez9@email.com'),
(782, '555-1782', 'valeria.medina9@email.com'),
(783, '555-1783', 'willy.pena9@email.com'),
(784, '555-1784', 'ximena.campos9@email.com'),
(785, '555-1785', 'yuri.soto9@email.com'),
(786, '555-1786', 'zacarias.morales9@email.com'),
(787, '555-1787', 'adriana.gonzalez9@email.com'),
(788, '555-1788', 'blas.hernandez9@email.com'),
(789, '555-1789', 'cecilia.jimenez9@email.com');

-- Contactos para Gym 8 (Usuarios 790-889)
INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(790, '555-1790', 'alejandro.sanchez8@email.com'),
(791, '555-1791', 'beatriz.gomez8@email.com'),
(792, '555-1792', 'carlos.ramirez8@email.com'),
(793, '555-1793', 'diana.torres8@email.com'),
(794, '555-1794', 'eduardo.vargas8@email.com'),
(795, '555-1795', 'fernanda.ortiz8@email.com'),
(796, '555-1796', 'gustavo.mendez8@email.com'),
(797, '555-1797', 'hilda.suarez8@email.com'),
(798, '555-1798', 'ignacio.ruiz8@email.com'),
(799, '555-1799', 'juliana.luna8@email.com'),
(800, '555-1800', 'ana.garcia8@email.com'),
(801, '555-1801', 'bruno.mendez8@email.com'),
(802, '555-1802', 'carla.ramos8@email.com'),
(803, '555-1803', 'diego.ortiz8@email.com'),
(804, '555-1804', 'elena.perez8@email.com'),
(805, '555-1805', 'fernando.lozano8@email.com'),
(806, '555-1806', 'gabriela.vega8@email.com'),
(807, '555-1807', 'hugo.ramirez8@email.com'),
(808, '555-1808', 'isabel.soto8@email.com'),
(809, '555-1809', 'javier.ruiz8@email.com'),
(810, '555-1810', 'karina.vargas8@email.com'),
(811, '555-1811', 'luis.medina8@email.com'),
(812, '555-1812', 'maria.castillo8@email.com'),
(813, '555-1813', 'nestor.gomez8@email.com'),
(814, '555-1814', 'olga.dominguez8@email.com'),
(815, '555-1815', 'pablo.herrera8@email.com'),
(816, '555-1816', 'quetzal.flores8@email.com'),
(817, '555-1817', 'rosa.jimenez8@email.com'),
(818, '555-1818', 'samuel.silva8@email.com'),
(819, '555-1819', 'teresa.maldonado8@email.com'),
(820, '555-1820', 'ulises.pineda8@email.com'),
(821, '555-1821', 'valeria.vargas8@email.com'),
(822, '555-1822', 'walter.salinas8@email.com'),
(823, '555-1823', 'ximena.nunez8@email.com'),
(824, '555-1824', 'yolanda.reyes8@email.com'),
(825, '555-1825', 'zacarias.torres8@email.com'),
(826, '555-1826', 'alejandra.romero8@email.com'),
(827, '555-1827', 'benjamin.ortega8@email.com'),
(828, '555-1828', 'cristina.guzman8@email.com'),
(829, '555-1829', 'daniel.luna8@email.com'),
(830, '555-1830', 'estefania.campos8@email.com'),
(831, '555-1831', 'felipe.tapia8@email.com'),
(832, '555-1832', 'gloria.santiago8@email.com'),
(833, '555-1833', 'hector.rios8@email.com'),
(834, '555-1834', 'ivana.fuentes8@email.com'),
(835, '555-1835', 'jorge.alvarado8@email.com'),
(836, '555-1836', 'karla.arias8@email.com'),
(837, '555-1837', 'leonardo.salazar8@email.com'),
(838, '555-1838', 'marta.mendoza8@email.com'),
(839, '555-1839', 'norberto.fuentes8@email.com'),
(840, '555-1840', 'olivia.cardoza8@email.com'),
(841, '555-1841', 'pedro.gonzalez8@email.com'),
(842, '555-1842', 'querida.morales8@email.com'),
(843, '555-1843', 'rafael.vega8@email.com'),
(844, '555-1844', 'sofia.luna8@email.com'),
(845, '555-1845', 'tomas.cruz8@email.com'),
(846, '555-1846', 'ursula.hernandez8@email.com'),
(847, '555-1847', 'victor.valle8@email.com'),
(848, '555-1848', 'wendy.gutierrez11@email.com'),
(849, '555-1849', 'xavier.navarro10@email.com'),
(850, '555-1850', 'yadira.espinoza10@email.com'),
(851, '555-1851', 'zulema.castillo10@email.com'),
(852, '555-1852', 'alvaro.maldonado10@email.com'),
(853, '555-1853', 'brenda.delgado10@email.com'),
(854, '555-1854', 'cesar.quintanilla10@email.com'),
(855, '555-1855', 'diana.suarez10@email.com'),
(856, '555-1856', 'erika.ortiz10@email.com'),
(857, '555-1857', 'fernando.mendez10@email.com'),
(858, '555-1858', 'gabriela.pacheco10@email.com'),
(859, '555-1859', 'horacio.ramirez10@email.com'),
(860, '555-1860', 'isabela.santos10@email.com'),
(861, '555-1861', 'javier.reyes10@email.com'),
(862, '555-1862', 'kenia.mendez10@email.com'),
(863, '555-1863', 'lorenzo.rodriguez10@email.com'),
(864, '555-1864', 'marina.jimenez10@email.com'),
(865, '555-1865', 'nicolas.flores10@email.com'),
(866, '555-1866', 'olga.sanchez10@email.com'),
(867, '555-1867', 'pablo.dominguez10@email.com'),
(868, '555-1868', 'raquel.vargas10@email.com'),
(869, '555-1869', 'santiago.luna10@email.com'),
(870, '555-1870', 'teresa.salazar10@email.com'),
(871, '555-1871', 'ulises.gomez10@email.com'),
(872, '555-1872', 'valeria.medina10@email.com'),
(873, '555-1873', 'willy.pena10@email.com'),
(874, '555-1874', 'ximena.campos10@email.com'),
(875, '555-1875', 'yuri.soto10@email.com'),
(876, '555-1876', 'zacarias.morales10@email.com'),
(877, '555-1877', 'adriana.gonzalez10@email.com'),
(878, '555-1878', 'blas.hernandez10@email.com'),
(879, '555-1879', 'cecilia.jimenez10@email.com'),
(880, '555-1880', 'david.navarro10@email.com'),
(881, '555-1881', 'estela.duarte10@email.com'),
(882, '555-1882', 'francisco.alvarez10@email.com'),
(883, '555-1883', 'gema.rodriguez10@email.com'),
(884, '555-1884', 'horacio.munoz10@email.com'),
(885, '555-1885', 'irene.torres10@email.com'),
(886, '555-1886', 'joel.valle10@email.com'),
(887, '555-1887', 'karla.vargas10@email.com'),
(888, '555-1888', 'leonor.garcia10@email.com'),
(889, '555-1889', 'mauro.silva10@email.com');

-- Contactos para Gym 9 (Usuarios 890-999)
INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(890, '555-1890', 'andres.gomez9@email.com'),
(891, '555-1891', 'beatriz.castillo9@email.com'),
(892, '555-1892', 'carlos.ortiz9@email.com'),
(893, '555-1893', 'diana.rios9@email.com'),
(894, '555-1894', 'eduardo.vargas9@email.com'),
(895, '555-1895', 'fernanda.pacheco9@email.com'),
(896, '555-1896', 'gustavo.maldonado9@email.com'),
(897, '555-1897', 'hilda.suarez9@email.com'),
(898, '555-1898', 'ignacio.ruiz9@email.com'),
(899, '555-1899', 'juliana.torres9@email.com'),
(900, '555-1900', 'ana.garcia9@email.com'),
(901, '555-1901', 'bruno.mendez9@email.com'),
(902, '555-1902', 'carla.ramos9@email.com'),
(903, '555-1903', 'diego.ortiz9@email.com'),
(904, '555-1904', 'elena.perez9@email.com'),
(905, '555-1905', 'fernando.lozano9@email.com'),
(906, '555-1906', 'gabriela.vega9@email.com'),
(907, '555-1907', 'hugo.ramirez9@email.com'),
(908, '555-1908', 'isabel.soto9@email.com'),
(909, '555-1909', 'javier.ruiz9@email.com'),
(910, '555-1910', 'karina.vargas9@email.com'),
(911, '555-1911', 'luis.medina9@email.com'),
(912, '555-1912', 'maria.castillo9@email.com'),
(913, '555-1913', 'nestor.gomez9@email.com'),
(914, '555-1914', 'olga.dominguez9@email.com'),
(915, '555-1915', 'pablo.herrera9@email.com'),
(916, '555-1916', 'quetzal.flores9@email.com'),
(917, '555-1917', 'rosa.jimenez9@email.com'),
(918, '555-1918', 'samuel.silva9@email.com'),
(919, '555-1919', 'teresa.maldonado9@email.com'),
(920, '555-1920', 'ulises.pineda9@email.com'),
(921, '555-1921', 'valeria.vargas9@email.com'),
(922, '555-1922', 'walter.salinas9@email.com'),
(923, '555-1923', 'ximena.nunez9@email.com'),
(924, '555-1924', 'yolanda.reyes9@email.com'),
(925, '555-1925', 'zacarias.torres9@email.com'),
(926, '555-1926', 'alejandra.romero9@email.com'),
(927, '555-1927', 'benjamin.ortega9@email.com'),
(928, '555-1928', 'cristina.guzman9@email.com'),
(929, '555-1929', 'daniel.luna9@email.com'),
(930, '555-1930', 'estefania.campos9@email.com'),
(931, '555-1931', 'felipe.tapia9@email.com'),
(932, '555-1932', 'gloria.santiago9@email.com'),
(933, '555-1933', 'hector.rios9@email.com'),
(934, '555-1934', 'ivana.fuentes9@email.com'),
(935, '555-1935', 'jorge.alvarado9@email.com'),
(936, '555-1936', 'karla.arias9@email.com'),
(937, '555-1937', 'leonardo.salazar9@email.com'),
(938, '555-1938', 'marta.mendoza9@email.com'),
(939, '555-1939', 'norberto.fuentes9@email.com'),
(940, '555-1940', 'olivia.cardoza9@email.com'),
(941, '555-1941', 'pedro.gonzalez9@email.com'),
(942, '555-1942', 'querida.morales9@email.com'),
(943, '555-1943', 'rafael.vega9@email.com'),
(944, '555-1944', 'sofia.luna9@email.com'),
(945, '555-1945', 'tomas.cruz9@email.com'),
(946, '555-1946', 'ursula.hernandez9@email.com'),
(947, '555-1947', 'victor.valle9@email.com'),
(948, '555-1948', 'wendy.gutierrez12@email.com'),
(949, '555-1949', 'xavier.navarro11@email.com'),
(950, '555-1950', 'yadira.espinoza11@email.com'),
(951, '555-1951', 'zulema.castillo11@email.com'),
(952, '555-1952', 'alvaro.maldonado11@email.com'),
(953, '555-1953', 'brenda.delgado11@email.com'),
(954, '555-1954', 'cesar.quintanilla11@email.com'),
(955, '555-1955', 'diana.suarez11@email.com'),
(956, '555-1956', 'erika.ortiz11@email.com'),
(957, '555-1957', 'fernando.mendez11@email.com'),
(958, '555-1958', 'gabriela.pacheco11@email.com'),
(959, '555-1959', 'horacio.ramirez11@email.com'),
(960, '555-1960', 'isabela.santos11@email.com'),
(961, '555-1961', 'javier.reyes11@email.com'),
(962, '555-1962', 'kenia.mendez11@email.com'),
(963, '555-1963', 'lorenzo.rodriguez11@email.com'),
(964, '555-1964', 'marina.jimenez11@email.com'),
(965, '555-1965', 'nicolas.flores11@email.com'),
(966, '555-1966', 'olga.sanchez11@email.com'),
(967, '555-1967', 'pablo.dominguez11@email.com'),
(968, '555-1968', 'raquel.vargas11@email.com'),
(969, '555-1969', 'santiago.luna11@email.com'),
(970, '555-1970', 'teresa.salazar11@email.com'),
(971, '555-1971', 'ulises.gomez11@email.com'),
(972, '555-1972', 'valeria.medina11@email.com'),
(973, '555-1973', 'willy.pena11@email.com'),
(974, '555-1974', 'ximena.campos11@email.com'),
(975, '555-1975', 'yuri.soto11@email.com'),
(976, '555-1976', 'zacarias.morales11@email.com'),
(977, '555-1977', 'adriana.gonzalez11@email.com'),
(978, '555-1978', 'blas.hernandez11@email.com'),
(979, '555-1979', 'cecilia.jimenez11@email.com'),
(980, '555-1980', 'david.navarro11@email.com'),
(981, '555-1981', 'estela.duarte11@email.com'),
(982, '555-1982', 'francisco.alvarez11@email.com'),
(983, '555-1983', 'gema.rodriguez11@email.com'),
(984, '555-1984', 'horacio.munoz11@email.com'),
(985, '555-1985', 'irene.torres11@email.com'),
(986, '555-1986', 'joel.valle11@email.com'),
(987, '555-1987', 'karla.vargas11@email.com'),
(988, '555-1988', 'leonor.garcia11@email.com'),
(989, '555-1989', 'mauro.silva11@email.com'),
(990, '555-1990', 'nadia.rios11@email.com'),
(991, '555-1991', 'oscar.castro11@email.com'),
(992, '555-1992', 'paula.cruz11@email.com'),
(993, '555-1993', 'quintina.vega11@email.com'),
(994, '555-1994', 'ricardo.morales11@email.com'),
(995, '555-1995', 'sandra.paredes11@email.com'),
(996, '555-1996', 'tomas.ortiz11@email.com'),
(997, '555-1997', 'ursula.tapia11@email.com'),
(998, '555-1998', 'victor.soto11@email.com'),
(999, '555-1999', 'wendy.gutierrez13@email.com');

-- Contactos para Gym 10 (Usuarios 1000-1100)
INSERT INTO Contacto_usuario (id_usuario, telefono, email) VALUES
(1000, '555-2000', 'adrian.lopez10@email.com'),
(1001, '555-2001', 'beatriz.mora10@email.com'),
(1002, '555-2002', 'carlos.ramirez10@email.com'),
(1003, '555-2003', 'diana.perez10@email.com'),
(1004, '555-2004', 'eduardo.gutierrez10@email.com'),
(1005, '555-2005', 'fernanda.ortiz10@email.com'),
(1006, '555-2006', 'gustavo.santos10@email.com'),
(1007, '555-2007', 'hilda.suarez10@email.com'),
(1008, '555-2008', 'ignacio.ruiz10@email.com'),
(1009, '555-2009', 'juliana.torres10@email.com'),
(1010, '555-2010', 'karla.vargas10@email.com'),
(1011, '555-2011', 'ana.garcia10@email.com'),
(1012, '555-2012', 'bruno.mendez10@email.com'),
(1013, '555-2013', 'carla.ramos10@email.com'),
(1014, '555-2014', 'diego.ortiz10@email.com'),
(1015, '555-2015', 'elena.perez10@email.com'),
(1016, '555-2016', 'fernando.lozano10@email.com'),
(1017, '555-2017', 'gabriela.vega10@email.com'),
(1018, '555-2018', 'hugo.ramirez10@email.com'),
(1019, '555-2019', 'isabel.soto10@email.com'),
(1020, '555-2020', 'javier.ruiz10@email.com'),
(1021, '555-2021', 'karina.vargas10@email.com'),
(1022, '555-2022', 'luis.medina10@email.com'),
(1023, '555-2023', 'maria.castillo10@email.com'),
(1024, '555-2024', 'nestor.gomez10@email.com'),
(1025, '555-2025', 'olga.dominguez10@email.com'),
(1026, '555-2026', 'pablo.herrera10@email.com'),
(1027, '555-2027', 'quetzal.flores10@email.com'),
(1028, '555-2028', 'rosa.jimenez10@email.com'),
(1029, '555-2029', 'samuel.silva10@email.com'),
(1030, '555-2030', 'teresa.maldonado10@email.com'),
(1031, '555-2031', 'ulises.pineda10@email.com'),
(1032, '555-2032', 'valeria.vargas10@email.com'),
(1033, '555-2033', 'walter.salinas10@email.com'),
(1034, '555-2034', 'ximena.nunez10@email.com'),
(1035, '555-2035', 'yolanda.reyes10@email.com'),
(1036, '555-2036', 'zacarias.torres10@email.com'),
(1037, '555-2037', 'alejandra.romero10@email.com'),
(1038, '555-2038', 'benjamin.ortega10@email.com'),
(1039, '555-2039', 'cristina.guzman10@email.com'),
(1040, '555-2040', 'daniel.luna10@email.com'),
(1041, '555-2041', 'estefania.campos10@email.com'),
(1042, '555-2042', 'felipe.tapia10@email.com'),
(1043, '555-2043', 'gloria.santiago10@email.com'),
(1044, '555-2044', 'hector.rios10@email.com'),
(1045, '555-2045', 'ivana.fuentes10@email.com'),
(1046, '555-2046', 'jorge.alvarado10@email.com'),
(1047, '555-2047', 'karla.arias10@email.com'),
(1048, '555-2048', 'leonardo.salazar10@email.com'),
(1049, '555-2049', 'marta.mendoza10@email.com'),
(1050, '555-2050', 'norberto.fuentes10@email.com'),
(1051, '555-2051', 'olivia.cardoza10@email.com'),
(1052, '555-2052', 'pedro.gonzalez10@email.com'),
(1053, '555-2053', 'querida.morales10@email.com'),
(1054, '555-2054', 'rafael.vega10@email.com'),
(1055, '555-2055', 'sofia.luna10@email.com'),
(1056, '555-2056', 'tomas.cruz10@email.com'),
(1057, '555-2057', 'ursula.hernandez10@email.com'),
(1058, '555-2058', 'victor.valle10@email.com'),
(1059, '555-2059', 'wendy.gutierrez14@email.com'),
(1060, '555-2060', 'xavier.navarro12@email.com'),
(1061, '555-2061', 'yadira.espinoza12@email.com'),
(1062, '555-2062', 'zulema.castillo12@email.com'),
(1063, '555-2063', 'alvaro.maldonado12@email.com'),
(1064, '555-2064', 'brenda.delgado12@email.com'),
(1065, '555-2065', 'cesar.quintanilla12@email.com'),
(1066, '555-2066', 'diana.suarez12@email.com'),
(1067, '555-2067', 'erika.ortiz12@email.com'),
(1068, '555-2068', 'fernando.mendez12@email.com'),
(1069, '555-2069', 'gabriela.pacheco12@email.com'),
(1070, '555-2070', 'horacio.ramirez12@email.com'),
(1071, '555-2071', 'isabela.santos12@email.com'),
(1072, '555-2072', 'javier.reyes12@email.com'),
(1073, '555-2073', 'kenia.mendez12@email.com'),
(1074, '555-2074', 'lorenzo.rodriguez12@email.com'),
(1075, '555-2075', 'marina.jimenez12@email.com'),
(1076, '555-2076', 'nicolas.flores12@email.com'),
(1077, '555-2077', 'olga.sanchez12@email.com'),
(1078, '555-2078', 'pablo.dominguez12@email.com'),
(1079, '555-2079', 'raquel.vargas12@email.com'),
(1080, '555-2080', 'santiago.luna12@email.com'),
(1081, '555-2081', 'teresa.salazar12@email.com'),
(1082, '555-2082', 'ulises.gomez12@email.com'),
(1083, '555-2083', 'valeria.medina12@email.com'),
(1084, '555-2084', 'willy.pena12@email.com'),
(1085, '555-2085', 'ximena.campos12@email.com'),
(1086, '555-2086', 'yuri.soto12@email.com'),
(1087, '555-2087', 'zacarias.morales12@email.com'),
(1088, '555-2088', 'adriana.gonzalez12@email.com'),
(1089, '555-2089', 'blas.hernandez12@email.com'),
(1090, '555-2090', 'cecilia.jimenez12@email.com'),
(1091, '555-2091', 'david.navarro12@email.com'),
(1092, '555-2092', 'estela.duarte12@email.com'),
(1093, '555-2093', 'francisco.alvarez12@email.com'),
(1094, '555-2094', 'gema.rodriguez12@email.com'),
(1095, '555-2095', 'horacio.munoz12@email.com'),
(1096, '555-2096', 'irene.torres12@email.com'),
(1097, '555-2097', 'joel.valle12@email.com'),
(1098, '555-2098', 'karla.vargas12@email.com'),
(1099, '555-2099', 'leonor.garcia12@email.com'),
(1100, '555-2100', 'mauro.silva12@email.com');


INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(101, 1, 'Muy buen ambiente y atentos los entrenadores.', 5),
(102, 1, 'Las clases grupales podr�an empezar a tiempo.', 4),
(103, 1, 'El equipo de pesas est� en buen estado.', 5),
(104, 1, 'El vestuario necesita limpieza m�s frecuente.', 3),
(105, 1, 'Buena ubicaci�n, pero muy concurrido en horas pico.', 4),
(106, 1, 'Me gusta la variedad de m�quinas de cardio.', 5),
(107, 1, 'Los entrenadores personales deber�an tener m�s disponibilidad.', 4),
(108, 1, 'Excelente trato al cliente y explicaci�n de rutinas.', 5);

-- Comentarios para Gym id = 2
INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(201, 2, 'Buen precio y acceso f�cil.', 4),
(202, 2, 'El aire acondicionado a veces falla.', 3),
(203, 2, 'La limpieza general es aceptable.', 4),
(204, 2, 'Clases funcionales muy divertidas.', 5),
(205, 2, 'La m�quina de remo estaba fuera de servicio.', 2),
(206, 2, 'Recepci�n muy amable y r�pida.', 5),
(207, 2, 'Necesitan m�s espacio para estiramiento libre.', 3),
(208, 2, 'Horario amplio y conveniente.', 4),
(209, 2, 'Los ba�os podr�an mejorarse en iluminaci�n.', 3);

-- Comentarios para Gym id = 3
INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(301, 3, 'Rutinas personalizadas muy buenas.', 5),
(302, 3, 'El spa privado del nivel ejecutivo es ideal.', 5),
(303, 3, 'Sala privada un poco peque�a.', 4),
(304, 3, 'Vale la pena la membres�a premium.', 5),
(305, 3, 'El acceso internacional no lo he usado a�n.', 4),
(306, 3, 'Muy buen ambiente general.', 5),
(307, 3, 'Algo de ruido entre m�quinas de cardio.', 3),
(308, 3, 'Entrenador personal me ayud� a mejorar bastante.', 5),
(309, 3, 'La zona VIP podr�a tener m�s m�quinas.', 4);

-- Comentarios para Gym id = 4
INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(401, 4, 'Muy buen gimnasio para fuerza.', 5),
(402, 4, 'Clases de alto rendimiento excelentes.', 5),
(403, 4, 'La membres�a internacional es muy conveniente.', 4),
(404, 4, 'Acceso completo, pero algunos equipos viejos.', 3),
(405, 4, 'Entrenadores muy proactivos.', 5),
(406, 4, 'El �rea de cardio podr�a ampliarse.', 4),
(407, 4, 'Buen horario pero en hora pico est� lleno.', 3),
(408, 4, 'Buena ubicaci�n con parqueo cercano.', 4);

-- Comentarios para Gym id = 5
INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(501, 5, 'Incluye asesor�a nutricional, excelente.', 5),
(502, 5, 'Zona restringida muy c�moda para VIP.', 5),
(503, 5, 'Plan socio gratuito para empleados es buen beneficio.', 4),
(504, 5, 'El equipo de entrenamiento quiz�s un poco caro para algunos.', 3),
(505, 5, 'Las clases grupales me encantan.', 5),
(506, 5, 'Horario de cierre podr�a extenderse.', 4),
(507, 5, 'Excelente trato al cliente.', 5),
(508, 5, 'La membres�a internacional muy �til.', 4),
(509, 5, 'El �rea VIP un poco concurrida.', 3);

-- Comentarios para Gym id = 6
INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(601, 6, 'Sauna incluida realmente suma valor.', 5),
(602, 6, 'Clases funcionales muy din�micas.', 5),
(603, 6, 'El precio est� bien para lo que ofrecen.', 4),
(604, 6, 'La limpieza de m�quinas podr�a mejorar.', 3),
(605, 6, 'Muy buena atenci�n del personal.', 5),
(606, 6, 'Acceso a gimnasios aliados muy �til.', 4),
(607, 6, '�rea de cardio siempre llena.', 3),
(608, 6, 'Ambiente agradable en general.', 5);

-- Comentarios para Gym id = 7
INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(701, 7, 'Asesor�a personalizada muy buena.', 5),
(702, 7, 'Sala privada para ejecutivos estupenda.', 5),
(703, 7, 'Spa incluido es un plus.', 4),
(704, 7, 'El gym est� muy bien ubicado.', 4),
(705, 7, 'El plan socio gratificado es una gran ventaja.', 4),
(706, 7, 'La zona VIP podr�a tener m�s m�quinas.', 3),
(707, 7, 'Entrenadores muy motivadores.', 5),
(708, 7, 'Muy buen trato en recepci�n.', 5);

-- Comentarios para Gym id = 8
INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(801, 8, 'Clases funcionales, box y entrenamiento personalizado, genial.', 5),
(802, 8, 'Acceso a sedes afiliadas �til para viajar.', 4),
(803, 8, 'La zona de pesas muy completa.', 5),
(804, 8, 'M�quinas un poco antiguas.', 3),
(805, 8, 'Muy buen equipo de entrenadores.', 5),
(806, 8, 'La membres�a internacional vale la pena.', 4),
(807, 8, 'Ambiente limpio y organizado.', 5);
  
-- Comentarios para Gym id = 9
INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(901, 9, 'Acceso internacional en todos los gimnasios TotalBody fant�stico.', 5),
(902, 9, 'Plan ejecutivo con beneficios exclusivos muy bueno.', 5),
(903, 9, 'La membres�a normal es bastante asequible.', 4),
(904, 9, 'Sala VIP podr�a estar m�s equipada.', 3),
(905, 9, 'Clases ilimitadas me encantan.', 5),
(906, 9, 'El trato del personal excelente.', 5),
(907, 9, 'El gym est� siempre limpio.', 5);

-- Comentarios para Gym id = 10
INSERT INTO Comentarios (id_usuario, id_gym, comentario, clasificacion) VALUES
(1001, 10, 'Acceso completo y clases ilimitadas, excelente.', 5),
(1002, 10, 'La membres�a internacional muy buena para quienes viajan.', 4),
(1003, 10, 'El plan ejecutivo con servicios adicionales ideal.', 5),
(1004, 10, 'La ubicaci�n en Torre Ocean Business Plaza es muy conveniente.', 4),
(1005, 10, 'Entrenamientos personalizados de alta calidad.', 5),
(1006, 10, '�rea restringida podr�a tener m�s ventilaci�n.', 3),
(1007, 10, 'Buena cantidad de m�quinas y servicio completo.', 5),
(1008, 10, 'Muy buen ambiente general.', 5);



--generacion de pagos ---------------------------------------------------------------------------------------
-- Generar pagos recurrentes para los �ltimos 3 meses
DECLARE @meses_atras INT = 3;
DECLARE @contador INT = 1;

WHILE @contador <= @meses_atras
BEGIN
    INSERT INTO Pago (id_usuario, id_gym, id_membresia, fecha_pago, monto_pagado, fecha_inicio_vigencia, fecha_fin_vigencia, estado_pago)
    SELECT 
        u.id_usuario,
        m.id_gym,
        u.id_membresia,
        DATEADD(MONTH, -@contador, GETDATE()) as fecha_pago,
        CASE WHEN m.precio = 0 THEN 0 ELSE m.precio END as monto_pagado,
        DATEADD(MONTH, -@contador, GETDATE()) as fecha_inicio_vigencia,
        DATEADD(DAY, m.duracion, DATEADD(MONTH, -@contador, GETDATE())) as fecha_fin_vigencia,
        'Completado' as estado_pago
    FROM Usuario u
    INNER JOIN Membresia m ON u.id_membresia = m.id_membresia
    WHERE ABS(CHECKSUM(NEWID())) % 100 < 70; -- 70% de usuarios con pago mensual
    
    SET @contador = @contador + 1;
END

PRINT 'Pagos recurrentes hist�ricos insertados';


--RESERVAS-----------------------------------------------------------------------------
-- =============================================
-- GENERAR RESERVAS COMPLETAS CON EQUIPOS E HISTORIAL
-- =============================================

-- 1. GENERAR RESERVAS BASE
INSERT INTO Reserva (id_usuario, estado, descripcion, fecha_reserva)
SELECT 
    u.id_usuario,
    CASE 
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 70 THEN 'Completada'
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 85 THEN 'Pendiente'
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 95 THEN 'Activa'
        ELSE 'Cancelada'
    END as estado,
    'Reserva de equipo complementario para entrenamiento' as descripcion,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 60, GETDATE()) as fecha_reserva
FROM Usuario u
WHERE u.rol = 'Cliente'  -- Solo clientes hacen reservas
  AND ABS(CHECKSUM(NEWID())) % 100 < 40;  -- 40% de clientes hacen reservas

PRINT 'Reservas base generadas: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));

-- 2. ASIGNAR EQUIPOS A LAS RESERVAS (TABLA EXTRA)
INSERT INTO Extra (id_reserva, id_equipo)
SELECT 
    r.id_reserva,
    e.id_equipo
FROM Reserva r
CROSS APPLY (
    SELECT TOP (ABS(CHECKSUM(NEWID())) % 3 + 1) -- 1-3 equipos por reserva
        id_equipo
    FROM Equipo
    ORDER BY NEWID()
) e
WHERE r.estado IN ('Completada', 'Activa', 'Pendiente');

PRINT 'Equipos asignados a reservas: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));

-- 3. GENERAR HISTORIAL DE ACCIONES DE RESERVAS
INSERT INTO Historial (id_reserva, id_usuario, tipo_accion, descripcion, fecha_registro)
SELECT 
    r.id_reserva,
    r.id_usuario,
    CASE 
        WHEN r.estado = 'Completada' THEN 'Reserva completada'
        WHEN r.estado = 'Pendiente' THEN 'Reserva creada'
        WHEN r.estado = 'Activa' THEN 'Reserva activada'
        WHEN r.estado = 'Cancelada' THEN 'Reserva cancelada'
    END as tipo_accion,
    CASE 
        WHEN r.estado = 'Completada' THEN 'El usuario complet� el uso del equipo reservado'
        WHEN r.estado = 'Pendiente' THEN 'El usuario cre� una nueva reserva de equipo'
        WHEN r.estado = 'Activa' THEN 'El usuario est� utilizando el equipo reservado'
        WHEN r.estado = 'Cancelada' THEN 'El usuario cancel� la reserva de equipo'
    END as descripcion,
    DATEADD(HOUR, -ABS(CHECKSUM(NEWID())) % 24, r.fecha_reserva) as fecha_registro
FROM Reserva r;

PRINT 'Registros de historial generados: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));

-- 4. AGREGAR M�S ACCIONES AL HISTORIAL (CAMBIOS DE ESTADO)
INSERT INTO Historial (id_reserva, id_usuario, tipo_accion, descripcion, fecha_registro)
SELECT 
    r.id_reserva,
    r.id_usuario,
    'Cambio de estado',
    'La reserva cambi� de estado a: ' + r.estado,
    DATEADD(HOUR, ABS(CHECKSUM(NEWID())) % 48, r.fecha_reserva)
FROM Reserva r
WHERE r.estado IN ('Completada', 'Cancelada')
  AND ABS(CHECKSUM(NEWID())) % 100 < 60;  -- 60% de reservas con cambios de estado

PRINT 'Cambios de estado en historial: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));


-- Habilitar Database Mail
sp_configure 'show advanced options', 1;
RECONFIGURE;
sp_configure 'Database Mail XPs', 1;
RECONFIGURE;

-- Crear cuenta de correo
EXEC msdb.dbo.sysmail_add_account_sp
    @account_name = 'NotificacionGimnasio',
    @description = 'Cuenta para notificaciones del sistema de gimnasio',
    @email_address = 'ad.gimnasio01@gmail.com',
    @display_name = 'Sistema de Gimnasio',
    @mailserver_name = 'smtp.gmail.com',
    @port = 587,
    @enable_ssl = 1,
    @username = 'ad.gimnasio01@gmail.com',
    @password = 'zzgd wyrb osed dwkl '; 

-- Crear perfil
EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'PerfilNotificaciones',
    @description = 'Perfil para enviar notificaciones'

-- Asociar cuenta al perfil
EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'PerfilNotificaciones',
    @account_name = 'NotificacionGimnasio',
    @sequence_number = 1;

-- -- Crear trigger de notificacion Usuario
CREATE TRIGGER NotificarCambioUsuario
ON Usuario
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF @@ROWCOUNT = 0 RETURN;
    
    DECLARE @Asunto NVARCHAR(255);
    DECLARE @Cuerpo NVARCHAR(MAX);
    DECLARE @CountInsert INT, @CountDelete INT;
    DECLARE @UsuarioID INT, @Nombre NVARCHAR(100), @Rol NVARCHAR(50);

    SET @CountInsert = (SELECT COUNT(*) FROM inserted);
    SET @CountDelete = (SELECT COUNT(*) FROM deleted);

    IF @CountInsert > 0
        SELECT TOP 1 @UsuarioID = id_usuario, @Nombre = nombre, @Rol = rol FROM inserted;
    ELSE IF @CountDelete > 0
        SELECT TOP 1 @UsuarioID = id_usuario, @Nombre = nombre, @Rol = rol FROM deleted;

    IF @CountInsert > 0 AND @CountDelete = 0
        SET @Asunto = 'NUEVO USUARIO REGISTRADO';
    ELSE IF @CountInsert > 0 AND @CountDelete > 0
        SET @Asunto = 'USUARIO ACTUALIZADO';
    ELSE IF @CountDelete > 0
        SET @Asunto = 'USUARIO ELIMINADO';

    SET @Cuerpo = 'Sistema de Gimnasio - Cambio en Usuarios' + CHAR(13) + CHAR(10) +
                  'Fecha: ' + CONVERT(VARCHAR, GETDATE()) + CHAR(13) + CHAR(10) +
                  'Usuario ID: ' + ISNULL(CAST(@UsuarioID AS NVARCHAR(10)), 'N/A') + CHAR(13) + CHAR(10) +
                  'Nombre: ' + ISNULL(@Nombre, 'N/A') + CHAR(13) + CHAR(10) +
                  'Rol: ' + ISNULL(@Rol, 'N/A') + CHAR(13) + CHAR(10) +
                  'Operaci�n: ' + 
                    CASE 
                        WHEN @CountInsert > 0 AND @CountDelete = 0 THEN 'INSERT'
                        WHEN @CountInsert > 0 AND @CountDelete > 0 THEN 'UPDATE' 
                        WHEN @CountDelete > 0 THEN 'DELETE'
                    END;

    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'PerfilNotificaciones',
        @recipients = 'ad.gimnasio01@gmail.com',
        @subject = @Asunto,
        @body = @Cuerpo;
END;
GO

-- Crear trigger de notificacion Reserva
CREATE TRIGGER NotificarCambioReserva
ON Reserva
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Asunto NVARCHAR(255);
    DECLARE @Cuerpo NVARCHAR(MAX);
    DECLARE @CountInsert INT, @CountDelete INT;
    DECLARE @UsuarioID INT, @Estado NVARCHAR(50);

    SET @CountInsert = (SELECT COUNT(*) FROM inserted);
    SET @CountDelete = (SELECT COUNT(*) FROM deleted);

    IF @CountInsert > 0
    BEGIN
        SELECT TOP 1 @UsuarioID = id_usuario, @Estado = estado FROM inserted;
    END

    IF @CountInsert > 0 AND @CountDelete = 0
        SET @Asunto = 'NUEVA RESERVA REGISTRADA';
    ELSE IF @CountInsert > 0 AND @CountDelete > 0
        SET @Asunto = 'RESERVA ACTUALIZADA';
    ELSE IF @CountDelete > 0
        SET @Asunto = 'RESERVA ELIMINADA';

    SET @Cuerpo = 'Se ha realizado un cambio en el sistema de reservas:' + CHAR(13) + CHAR(10) +
                  'Fecha: ' + CONVERT(VARCHAR, GETDATE()) + CHAR(13) + CHAR(10) +
                  'Usuario ID: ' + ISNULL(CAST(@UsuarioID AS NVARCHAR(10)), 'N/A') + CHAR(13) + CHAR(10) +
                  'Estado: ' + ISNULL(@Estado, 'N/A') + CHAR(13) + CHAR(10) +
                  'Tipo de operaci�n: ' + 
                    CASE 
                        WHEN @CountInsert > 0 AND @CountDelete = 0 THEN 'INSERT'
                        WHEN @CountInsert > 0 AND @CountDelete > 0 THEN 'UPDATE' 
                        WHEN @CountDelete > 0 THEN 'DELETE'
                    END;

    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'PerfilNotificaciones',
        @recipients = 'ad.gimnasio01@gmail.com',
        @subject = @Asunto,
        @body = @Cuerpo;
END;
GO

-- Crear trigger de notificacion Pago
CREATE TRIGGER NotificarCambioPago
ON Pago
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF @@ROWCOUNT = 0 RETURN;
    
    DECLARE @Asunto NVARCHAR(255);
    DECLARE @Cuerpo NVARCHAR(MAX);
    DECLARE @CountInsert INT, @CountDelete INT;
    DECLARE @PagoID INT, @UsuarioID INT, @Monto DECIMAL(10,2), @Estado NVARCHAR(50);

    SET @CountInsert = (SELECT COUNT(*) FROM inserted);
    SET @CountDelete = (SELECT COUNT(*) FROM deleted);

    IF @CountInsert > 0
        SELECT TOP 1 @PagoID = id_pago, @UsuarioID = id_usuario, @Monto = monto_pagado, @Estado = estado_pago FROM inserted;

    IF @CountInsert > 0 AND @CountDelete = 0
        SET @Asunto = 'NUEVO PAGO REGISTRADO';
    ELSE IF @CountInsert > 0 AND @CountDelete > 0
        SET @Asunto = 'PAGO ACTUALIZADO';
    ELSE IF @CountDelete > 0
        SET @Asunto = 'PAGO ELIMINADO';

    SET @Cuerpo = 'Sistema de Gimnasio - Cambio en Pagos' + CHAR(13) + CHAR(10) +
                  'Fecha: ' + CONVERT(VARCHAR, GETDATE()) + CHAR(13) + CHAR(10) +
                  'Pago ID: ' + ISNULL(CAST(@PagoID AS NVARCHAR(10)), 'N/A') + CHAR(13) + CHAR(10) +
                  'Usuario ID: ' + ISNULL(CAST(@UsuarioID AS NVARCHAR(10)), 'N/A') + CHAR(13) + CHAR(10) +
                  'Monto: $' + ISNULL(CAST(@Monto AS NVARCHAR(20)), 'N/A') + CHAR(13) + CHAR(10) +
                  'Estado: ' + ISNULL(@Estado, 'N/A') + CHAR(13) + CHAR(10) +
                  'Operaci�n: ' + 
                    CASE 
                        WHEN @CountInsert > 0 AND @CountDelete = 0 THEN 'INSERT'
                        WHEN @CountInsert > 0 AND @CountDelete > 0 THEN 'UPDATE' 
                        WHEN @CountDelete > 0 THEN 'DELETE'
                    END;

    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'PerfilNotificaciones',
        @recipients = 'ad.gimnasio01@gmail.com',
        @subject = @Asunto,
        @body = @Cuerpo;
END;
GO

-- Crear trigger de notificacion Membresia
CREATE TRIGGER NotificarCambioMembresia
ON Membresia
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF @@ROWCOUNT = 0 RETURN;
    
    DECLARE @Asunto NVARCHAR(255);
    DECLARE @Cuerpo NVARCHAR(MAX);
    DECLARE @CountInsert INT, @CountDelete INT;
    DECLARE @MembresiaID INT, @Nombre NVARCHAR(100), @Precio DECIMAL(10,2);

    SET @CountInsert = (SELECT COUNT(*) FROM inserted);
    SET @CountDelete = (SELECT COUNT(*) FROM deleted);

    IF @CountInsert > 0
        SELECT TOP 1 @MembresiaID = id_membresia, @Nombre = nombre, @Precio = precio FROM inserted;

    IF @CountInsert > 0 AND @CountDelete = 0
        SET @Asunto = 'NUEVA MEMBRES�A CREADA';
    ELSE IF @CountInsert > 0 AND @CountDelete > 0
        SET @Asunto = 'MEMBRES�A ACTUALIZADA';
    ELSE IF @CountDelete > 0
        SET @Asunto = 'MEMBRES�A ELIMINADA';

    SET @Cuerpo = 'Sistema de Gimnasio - Cambio en Membres�as' + CHAR(13) + CHAR(10) +
                  'Fecha: ' + CONVERT(VARCHAR, GETDATE()) + CHAR(13) + CHAR(10) +
                  'Membresia ID: ' + ISNULL(CAST(@MembresiaID AS NVARCHAR(10)), 'N/A') + CHAR(13) + CHAR(10) +
                  'Nombre: ' + ISNULL(@Nombre, 'N/A') + CHAR(13) + CHAR(10) +
                  'Precio: $' + ISNULL(CAST(@Precio AS NVARCHAR(20)), 'N/A') + CHAR(13) + CHAR(10) +
                  'Operaci�n: ' + 
                    CASE 
                        WHEN @CountInsert > 0 AND @CountDelete = 0 THEN 'INSERT'
                        WHEN @CountInsert > 0 AND @CountDelete > 0 THEN 'UPDATE' 
                        WHEN @CountDelete > 0 THEN 'DELETE'
                    END;

    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'PerfilNotificaciones',
        @recipients = 'ad.gimnasio01@gmail.com',
        @subject = @Asunto,
        @body = @Cuerpo;
END;
GO

--Verificacion de triggers activos
SELECT name, OBJECT_NAME(parent_id) as tabla 
FROM sys.triggers 
WHERE name LIKE 'NotificarCambio%';

-- Inserts de prueba
-- Membres�a
INSERT INTO Membresia (id_gym, nombre, descripcion, precio, duracion)
SELECT TOP 1 id_gym, 'Membres�a Prueba', 'Para testing del sistema', 499.99, 30 
FROM Gym;

-- Usuario  
INSERT INTO Usuario (id_membresia, nombre, apellido, carnet, rol, contrasena)
SELECT TOP 1 id_membresia, 'Ana', 'Garcia', 'AGTEST001', 'cliente', 'test123'
FROM Membresia ORDER BY id_membresia DESC;

-- Reserva
INSERT INTO Reserva (id_usuario, estado, descripcion, fecha_reserva)
SELECT TOP 1 id_usuario, 'Activa', 'Reserva de prueba del sistema', GETDATE()
FROM Usuario ORDER BY id_usuario DESC;

-- Pago
INSERT INTO Pago (id_usuario, id_gym, id_membresia, monto_pagado, fecha_inicio_vigencia, fecha_fin_vigencia, estado_pago)
SELECT 
    (SELECT TOP 1 id_usuario FROM Usuario ORDER BY id_usuario DESC),
    (SELECT TOP 1 id_gym FROM Gym),
    (SELECT TOP 1 id_membresia FROM Membresia ORDER BY id_membresia DESC),
    499.99, GETDATE(), DATEADD(DAY, 30, GETDATE()), 'Completado';


-- Verificar si hay correos en cola o errores
SELECT * FROM msdb.dbo.sysmail_allitems;
SELECT * FROM msdb.dbo.sysmail_event_log;