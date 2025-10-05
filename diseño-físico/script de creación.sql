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
	CONSTRAINT RangoGeograficoColombia CHECK (latitud BETWEEN -4.2 AND 13.5
											AND longitud BETWEEN -79.0 AND -66.0)
);

CREATE TABLE Gu�as (
	idGu�a INT,
	nombres VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	documento BIGINT NOT NULL,
	foroDePerfil VARCHAR(MAX) NOT NULL,
	email VARCHAR(254) NOT NULL,
	tel�fono VARCHAR(20) NOT NULL,
	esVerificado BIT NOT NULL,
	biograf�a VARCHAR(1000),
	idLocalizaci�n INT,
	CONSTRAINT PKGu�as PRIMARY KEY (idGu�a),
	CONSTRAINT FKLocalizaci�nGu�a FOREIGN KEY (idLocalizaci�n) REFERENCES Localizaciones(idLocalizaci�n),
	CONSTRAINT TelefonoGu�a�nico UNIQUE (tel�fono),
	CONSTRAINT DocumentoGu�a�nico UNIQUE (documento),
	CONSTRAINT documentoGu�aV�lido CHECK (LEN(CAST(documento AS VARCHAR(20))) >= 7
								   AND LEN(CAST(documento AS VARCHAR(20))) <= 18),
	CONSTRAINT NombresGu�aV�lidos CHECK (TRIM(nombres) <> ''),
	CONSTRAINT ApellidosGu�aV�lidos CHECK (TRIM(apellidos) <> ''),
	CONSTRAINT N�meroGu�aV�lido CHECK (tel�fono LIKE '+%'),
	CONSTRAINT EmailGu�aV�lido CHECK (email LIKE '_%@_%._%'),
	CONSTRAINT Biograf�aGu�aV�lida CHECK (TRIM(biograf�a) <> '')
);

CREATE TABLE Tours (
	idTour INT,
	tem�tica VARCHAR(100) NOT NULL,
	duraci�n INT NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	puntoDeEncuentro VARCHAR(150),
	puntosDeInter�s VARCHAR(1000) NOT NULL,
	disponibilidad DATETIME2 NOT NULL,
	descripci�n VARCHAR(1000) NOT NULL,
	numParticipantes INT,
	est�Activo BIT NOT NULL,
	idLocalizaci�n INT NOT NULL,
	CONSTRAINT PKTours PRIMARY KEY (idTour),
	CONSTRAINT NombreTourV�lido CHECK (TRIM(nombre) <> ''),
	CONSTRAINT Tem�ticaV�lida CHECK (TRIM(tem�tica) <> ''),
	CONSTRAINT PuntoV�lida CHECK (TRIM(puntoDeEncuentro) <> ''),
	CONSTRAINT NumeroParticipantesPositivos CHECK (numParticipantes > 0),
	CONSTRAINT Duraci�nV�lida CHECK (duraci�n > 0 AND duraci�n <= 720),
	CONSTRAINT PuntosDeInter�sV�lidos CHECK (TRIM(puntosDeInter�s) <> ''), 
	CONSTRAINT Descripci�nV�lida CHECK (TRIM(descripci�n) <> ''),
	CONSTRAINT FKLocalizaci�nTour FOREIGN KEY (idLocalizaci�n) REFERENCES Localizaciones(idLocalizaci�n)
);

CREATE TABLE Idiomas (
	idIdioma INT,
	nombre VARCHAR(30) NOT NULL,
	CONSTRAINT PKIdiomas PRIMARY KEY (idIdioma),
	CONSTRAINT nombreIdioma�nico UNIQUE (nombre),
	CONSTRAINT NombreIdiomaV�lido CHECK (TRIM(nombre) <> '') 
);

CREATE TABLE IdiomasPorTour (
	idIdioma INT,
	idGu�a INT,
	CONSTRAINT FKIdiomaTour FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKGu�aTour FOREIGN KEY (idGu�a) REFERENCES Gu�as(idGu�a),
);

CREATE TABLE Turistas (
	idTurista INT,
	nombres VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	email VARCHAR(254) NOT NULL,
	tel�fono VARCHAR(20) NOT NULL,
	fotoDePerfil VARCHAR(MAX) NOT NULL,
	documento BIGINT NOT NULL,
	perfil VARCHAR(MAX), 
	CONSTRAINT PKTurista PRIMARY KEY (idTurista),
	CONSTRAINT Tel�fonoTurista�nico UNIQUE (tel�fono),
	CONSTRAINT documentoTuristaV�lido CHECK (LEN(CAST(documento AS VARCHAR(20))) >= 7
								   AND LEN(CAST(documento AS VARCHAR(20))) <= 18),
	CONSTRAINT NombresTuristaV�lidos CHECK (TRIM(nombres) <> ''),
	CONSTRAINT ApellidosTuristaV�lidos CHECK (TRIM(apellidos) <> ''),
	CONSTRAINT N�meroTuristaV�lido CHECK (tel�fono LIKE '+%'),
	CONSTRAINT EmailTuristaV�lido CHECK (email LIKE '_%@_%._%')
);

CREATE TABLE IdiomasPorGuia (
	idIdioma INT,
	idGu�a INT,
	CONSTRAINT FKIdiomaGu�a FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKGu�a FOREIGN KEY (idGu�a) REFERENCES Gu�as(idGu�a),
);

CREATE TABLE Reservas (
	idReserva INT,
	cuposReservados INT NOT NULL,
	estadoReserva VARCHAR(20) NOT NULL,
	idTuristaReserva INT,
	idTour INT
	CONSTRAINT PKReservas PRIMARY KEY (idReserva),
	CONSTRAINT PKPositiva CHECK (idReserva > 0),
	CONSTRAINT FKTuristaReserva FOREIGN KEY (idTuristaReserva) REFERENCES Turistas(idTurista),
	CONSTRAINT FKTourReserva FOREIGN KEY (idTour) REFERENCES Tours(idTour),
	CONSTRAINT CuposPositivos CHECK (cuposReservados > 0),
	CONSTRAINT estadoV�lido CHECK (TRIM(estadoReserva) <> '')
);

CREATE TABLE IdiomasPorTurista (
	idIdioma INT,
	idTurista INT,
	CONSTRAINT FKIdiomaPorTurista FOREIGN KEY (idTurista) REFERENCES Turistas(idTurista),
	CONSTRAINT FKTuristaPorIdioma FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma)
); 