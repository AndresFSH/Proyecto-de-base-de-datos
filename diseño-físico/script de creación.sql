CREATE TABLE TiposDeLocalizaci�n (
	idTipoLocalizaci�n INT,
	nombreTipoLocalizaci�n VARCHAR(100),
	CONSTRAINT PKTiposDeLocalizaci�n PRIMARY KEY (idTipoLocalizaci�n)
);

CREATE TABLE Localizaciones (
	idLocalizaci�n INT,
	nombre VARCHAR(100) NOT NULL,
	latitud DECIMAL(8, 6) NOT NULL,
	longitud DECIMAL(9, 6) NOT NULL,
	idTipoLocalizaci�n INT NOT NULL,
	CONSTRAINT PKLocalizaciones PRIMARY KEY (idLocalizaci�n),
	CONSTRAINT FKTipoLocalizaci�n FOREIGN KEY (idTipoLocalizaci�n) REFERENCES TiposDeLocalizaci�n(idTipoLocalizaci�n),
	CONSTRAINT NombreLocalizaci�nV�lida CHECK (TRIM(nombre) <> ''),
	CONSTRAINT RangoGeogr�ficoColombia CHECK (latitud BETWEEN -4.2 AND 13.5
											AND longitud BETWEEN -79.0 AND -66.0)
);

CREATE TABLE Tours (
	idTour INT,
	tem�tica VARCHAR(100) NOT NULL,
	duraci�n INT NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	puntoDeEncuentro VARCHAR(150),
	disponibilidad DATETIME2 NOT NULL,
	descripci�n VARCHAR(1000) NOT NULL,
	maxParticipantes INT,
	est�Activo BIT NOT NULL,
	idLocalizaci�n INT NOT NULL,
	CONSTRAINT PKTours PRIMARY KEY (idTour),
	CONSTRAINT NombreTourV�lido CHECK (TRIM(nombre) <> ''),
	CONSTRAINT Tem�ticaV�lida CHECK (TRIM(tem�tica) <> ''),
	CONSTRAINT PuntoV�lida CHECK (TRIM(puntoDeEncuentro) <> ''),
	CONSTRAINT NumeroParticipantesPositivos CHECK (maxParticipantes > 0),
	CONSTRAINT Duraci�nV�lida CHECK (duraci�n > 0 AND duraci�n <= 720), 
	CONSTRAINT Descripci�nV�lida CHECK (TRIM(descripci�n) <> ''),
	CONSTRAINT FKLocalizaci�nTour FOREIGN KEY (idLocalizaci�n) REFERENCES Localizaciones(idLocalizaci�n)
);

CREATE TABLE Usuarios (
	idUsuario INT,
	nombres VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	tel�fono VARCHAR(20) NOT NULL,
	tieneEPS BIT NOT NULL,
	documentoUsuario VARCHAR(30) NOT NULL,
	idLocalizaci�n INT NOT NULL,
	CONSTRAINT PKUsuarios PRIMARY KEY (idUsuario),
	CONSTRAINT FKLocalizaci�nUsuario FOREIGN KEY (idLocalizaci�n) REFERENCES Localizaciones(idLocalizaci�n),
	CONSTRAINT NombresV�lidos CHECK (TRIM(nombres) <> '' AND nombres NOT LIKE '%[^0-9]%'),
	CONSTRAINT ApellidosV�lidos CHECK (TRIM(apellidos) <> '' AND apellidos NOT LIKE '%[^0-9]%'),
	CONSTRAINT DocumentoV�lido CHECK (TRIM(documentoUsuario) <> '' AND LEN(documentoUsuario) >= 7),
	CONSTRAINT Tel�fono�nico UNIQUE (tel�fono),
	CONSTRAINT Tel�fonoV�lido CHECK (tel�fono LIKE '+[0-9][0-9] %[0-9]%' 
									OR tel�fono LIKE '+[0-9][0-9][0-9] %[0-9]%') -- cadenas que empiezan en +n�m 
																		         -- donde n�m es un n�mero de 2 a 3 digitos
																				 -- y les sigue una cadena con almenos un n�mero en ellas
																				 -- (es lo m�s cercano que se puede hacer a validar un n�mero de tel�fono)
);

CREATE TABLE PuntosDeInter�s (
	idPuntoDeInter�s INT,
	nombre VARCHAR(100) NOT NULL,
	descripci�n VARCHAR(1000),
	latitud DECIMAL(8, 6) NOT NULL,
	longitud DECIMAL(9, 6) NOT NULL,
	tipos VARCHAR(100) NOT NULL,
	serviciosYActividades VARCHAR(100) NOT NULL,
	estado VARCHAR(20) NOT NULL,
	CONSTRAINT PKPuntosDeInter�s PRIMARY KEY (idPuntoDeInter�s),
	CONSTRAINT NombrePuntoDeInter�sNoVac�o CHECK (TRIM(nombre) <> ''),
	CONSTRAINT Descripci�nPuntoDeInter�sV�lida CHECK (TRIM(descripci�n) <> ''),
	CONSTRAINT RangoGeogr�ficoColombiaPuntoDeInter�s CHECK (latitud BETWEEN -4.2 AND 13.5
											AND longitud BETWEEN -79.0 AND -66.0),
	CONSTRAINT TiposPuntoDeInter�sNoVac�o CHECK (TRIM(tipos) <> ''),
	CONSTRAINT ServiciosYActividadesNoVac�o CHECK (TRIM(serviciosYActividades) <> ''),
	CONSTRAINT EstadoPuntoDeInter�sNoVac�o CHECK (TRIM(estado) <> '')
);

CREATE TABLE PuntosDeInter�sDelTour (
	idTour INT,
	idPuntoDeInter�s INT,
	idPuntoTour INT,
	CONSTRAINT FKTourPorPuntosDeInter�s FOREIGN KEY (idTour) REFERENCES Tours(idTour),
	CONSTRAINT FKPuntosDeInter�sPorTour FOREIGN KEY (idPuntoDeInter�s) REFERENCES PuntosDeInter�s(idPuntoDeInter�s),
	CONSTRAINT PKPuntosDeInter�sDelTour PRIMARY KEY (idPuntoTour)
);

CREATE TABLE Idiomas (
	idIdioma INT,
	nombre VARCHAR(30) NOT NULL,
	CONSTRAINT PKIdiomas PRIMARY KEY (idIdioma),
	CONSTRAINT nombreIdioma�nico UNIQUE (nombre),
	CONSTRAINT NombreIdiomaV�lido CHECK (TRIM(nombre) <> '') 
);

CREATE TABLE Perfiles (
	idPerfil INT,
	fotoDePerfil VARCHAR(100),
	email VARCHAR(254),
	fechaCreaci�n DATETIME2,
	idIdioma INT,
	CONSTRAINT PKPerfiles PRIMARY KEY (idPerfil),
	CONSTRAINT FKPerfilesIdioma FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKPerfilesUsuario FOREIGN KEY (idPerfil) REFERENCES Usuarios(idUsuario),
	CONSTRAINT FotoDePerfilV�lida CHECK (TRIM(fotoDePerfil) <> '' AND fotoDePerfil LIKE '_%._%'),
	CONSTRAINT Email�nico UNIQUE (email),
	CONSTRAINT EmailV�lido CHECK (email LIKE '_%@_%._%'),
	CONSTRAINT FechaCreaci�nPerfilV�lida CHECK (fechaCreaci�n <= GETDATE())
);

CREATE TABLE Gu�as (
	idGu�a INT,
	esVerificado BIT NOT NULL DEFAULT 0,
	biograf�a VARCHAR(1000),
	descripci�n VARCHAR(1000) NOT NULL,
	CONSTRAINT Biograf�aGu�aV�lida CHECK (TRIM(biograf�a) <> ''),
	CONSTRAINT PKGu�a PRIMARY KEY (idGu�a),
	CONSTRAINT FKGu�aPerfil FOREIGN KEY (idGu�a) REFERENCES Perfiles(idPerfil)
);

CREATE TABLE Turistas (
	idTurista INT,
	CONSTRAINT PKTurista PRIMARY KEY (idTurista),
	CONSTRAINT FKTuristaPerfil FOREIGN KEY (idTurista) REFERENCES Perfiles(idPerfil)
);

CREATE TABLE IdiomasPorPerfil (
	idIdioma INT,
	idPerfil INT,
	CONSTRAINT FKIdiomaGu�a FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKPerfil FOREIGN KEY (idPerfil) REFERENCES Perfiles(idPerfil),
);

CREATE TABLE IdiomasPorTour (
	idIdioma INT,
	idTour INT,
	CONSTRAINT FKIdiomaTour FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKTourIdioma FOREIGN KEY (idTour) REFERENCES Tours(idTour)
);

CREATE TABLE Reservas (
	idReserva INT,
	cuposReservados INT NOT NULL,
	estadoReserva VARCHAR(20) NOT NULL,
	idTuristaReserva INT,
	idTour INT,
	CONSTRAINT PKReservas PRIMARY KEY (idReserva),
	CONSTRAINT PKPositiva CHECK (idReserva > 0),
	CONSTRAINT FKTuristaReserva FOREIGN KEY (idTuristaReserva) REFERENCES Turistas(idTurista),
	CONSTRAINT FKTourReserva FOREIGN KEY (idTour) REFERENCES Tours(idTour),
	CONSTRAINT CuposPositivos CHECK (cuposReservados > 0),
	CONSTRAINT estadoV�lido CHECK (TRIM(estadoReserva) <> '')
);