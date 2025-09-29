CREATE TABLE Paises (
	idPa�s INT,
	nombrePa�s VARCHAR(56) NOT NULL,
	CONSTRAINT PKPa�ses PRIMARY KEY (idPa�s)
);

CREATE TABLE Ciudades (
	idCiudad INT,
	nombreCiudad VARCHAR(85) NOT NULL,
	idPa�sCiudad INT NOT NULL,
	CONSTRAINT PKCiudades PRIMARY KEY (idCiudad),
	CONSTRAINT FKPa�s FOREIGN KEY (idPa�sCiudad) REFERENCES Paises(idPa�s)
);

CREATE TABLE Gu�as (
	idGu�a INT,
	nombresGu�a VARCHAR(60) NOT NULL,
	apellidosGu�a VARCHAR(60) NOT NULL,
	foroDePerfilGu�a VARCHAR(MAX) NOT NULL,
	emailGu�a VARCHAR(254) NOT NULL,
	telefonoGu�a VARCHAR(20) NOT NULL,
	esVerificado BIT NOT NULL,
	biografiaGuia VARCHAR(MAX) NOT NULL,
	idCiudadGu�a INT NOT NULL,
	CONSTRAINT PKGu�as PRIMARY KEY (idGu�a),
	CONSTRAINT FKCiudadGu�a FOREIGN KEY (idCiudadGu�a) REFERENCES Ciudades(idCiudad)
);

CREATE TABLE Tours (
	idTour INT,
	tematicaTour VARCHAR(100) NOT NULL,
	duracionTour TIME NOT NULL,
	nombreTour VARCHAR(100) NOT NULL,
	puntoDeEncuentroTour VARCHAR(MAX) NOT NULL,
	disponibilidadTour DATETIME NOT NULL,
	descripci�nTour VARCHAR(MAX) NOT NULL,
	numParticipantesTour INT NOT NULL,
	est�Activo BIT NOT NULL,
	idCiudadTour INT NOT NULL,
	CONSTRAINT PKTours PRIMARY KEY (idTour),
	CONSTRAINT FKCiudadTour FOREIGN KEY (idCiudadTour) REFERENCES Ciudades(idCiudad)
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
	CONSTRAINT PKTurista PRIMARY KEY (idTurista)
);

CREATE TABLE IdiomasPorTurista (
	idIdioma INT,
	idTurista INT,
	CONSTRAINT FKIdiomaTurista FOREIGN KEY (idIdioma) REFERENCES Idiomas(idIdioma),
	CONSTRAINT FKTurista FOREIGN KEY (idTurista) REFERENCES Turistas(idTurista),
);

CREATE TABLE Reservas (
	idReserva INT,
	cuposReservados INT NOT NULL,
	estadoReserva VARCHAR(20) NOT NULL,
	idTuristaReserva INT,
	CONSTRAINT PKReservas PRIMARY KEY (idReserva),
	CONSTRAINT FKTuristaReserva FOREIGN KEY (idTuristaReserva) REFERENCES Turistas(idTurista)
);