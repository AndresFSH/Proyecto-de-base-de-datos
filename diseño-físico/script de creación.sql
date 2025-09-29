CREATE TABLE TiposDeLocalizaci�n (
	idTipoLocalizaci�n INT,
	nombreTipoLocalizaci�n VARCHAR(100),
	CONSTRAINT PKTiposDeLocalizaci�n PRIMARY KEY (idTipoLocalizaci�n)
);

CREATE TABLE Localizaciones (
	idLocalizaci�n INT,
	nombreLocalizaci�n VARCHAR(100) NOT NULL,
	idTipoLocalizaci�n INT NOT NULL,
	CONSTRAINT PKLocalizaciones PRIMARY KEY (idLocalizaci�n),
	CONSTRAINT FKTipoLocalizaci�n FOREIGN KEY (idTipoLocalizaci�n) REFERENCES TiposDeLocalizaci�n(idTipoLocalizaci�n)
);

CREATE TABLE Gu�as (
	idGu�a INT,
	nombresGu�a VARCHAR(60) NOT NULL,
	apellidosGu�a VARCHAR(60) NOT NULL,
	documentoGu�a INT NOT NULL,
	foroDePerfilGu�a VARCHAR(MAX) NOT NULL,
	emailGu�a VARCHAR(254) NOT NULL,
	telefonoGu�a VARCHAR(20) NOT NULL,
	esVerificado BIT NOT NULL,
	biografiaGuia VARCHAR(MAX),
	idLocalizaci�n INT,
	CONSTRAINT PKGu�as PRIMARY KEY (idGu�a),
	CONSTRAINT FKLocalizaci�nGu�a FOREIGN KEY (idLocalizaci�n) REFERENCES Localizaciones(idLocalizaci�n),
	CONSTRAINT TelefonoGu�a�nico UNIQUE (telefonoGu�a),
	CONSTRAINT DocumentoGu�a�nico UNIQUE (documentoGu�a)
);

CREATE TABLE Tours (
	idTour INT,
	tematicaTour VARCHAR(100) NOT NULL,
	duracionTour TIME NOT NULL,
	nombreTour VARCHAR(100) NOT NULL,
	puntoDeEncuentroTour VARCHAR(150),
	disponibilidadTour DATETIME NOT NULL,
	descripci�nTour VARCHAR(1000) NOT NULL,
	numParticipantesTour INT,
	est�Activo BIT NOT NULL,
	idLocalizaci�n INT NOT NULL,
	CONSTRAINT PKTours PRIMARY KEY (idTour),
	CONSTRAINT FKLocalizaci�nTour FOREIGN KEY (idLocalizaci�n) REFERENCES Localizaciones(idLocalizaci�n)
);

CREATE TABLE Idiomas (
	idIdioma INT,
	nombreIdioma VARCHAR(30) NOT NULL,
	CONSTRAINT PKIdiomas PRIMARY KEY (idIdioma),
	CONSTRAINT nombreIdioma�nico UNIQUE (nombreIdioma)
);

CREATE TABLE IdiomasPorTour (
	idIdioma INT,
	idGu�a INT,
	CONSTRAINT FKIdiomaTour FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKGu�aTour FOREIGN KEY (idGu�a) REFERENCES Gu�as(idGu�a),
);

CREATE TABLE Turistas (
	idTurista INT,
	nombresTurista VARCHAR(60) NOT NULL,
	apellidosTurista VARCHAR(60) NOT NULL,
	emailTurista VARCHAR(254) NOT NULL,
	telefonoTurista VARCHAR(20) NOT NULL,
	fotoDePerfilTurista VARCHAR(MAX) NOT NULL,
	perfilTurista VARCHAR(MAX) NOT NULL, 
	CONSTRAINT PKTurista PRIMARY KEY (idTurista),
	CONSTRAINT TelefonoTurista�nico UNIQUE (telefonoTurista)
);

CREATE TABLE IdiomasPorGuia (
	idIdioma INT,
	idGu�a INT,
	CONSTRAINT FKIdiomaGuia FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKGu�a FOREIGN KEY (idGu�a) REFERENCES Gu�as(idGu�a),
);

CREATE TABLE Reservas (
	idReserva INT,
	cuposReservados INT NOT NULL,
	estadoReserva VARCHAR(20) NOT NULL,
	idTuristaReserva INT,
	CONSTRAINT PKReservas PRIMARY KEY (idReserva),
	CONSTRAINT FKTuristaReserva FOREIGN KEY (idTuristaReserva) REFERENCES Turistas(idTurista)
);

CREATE TABLE IdiomasPorTurista (
	idIdioma INT,
	idTurista INT,
	CONSTRAINT FKIdiomaPorTurista FOREIGN KEY (idTurista) REFERENCES Turistas(idTurista),
	CONSTRAINT FKTuristaPorIdioma FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma)
);