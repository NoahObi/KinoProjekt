CREATE TABLE Film (
    FilmID INT PRIMARY KEY,
    Titel VARCHAR(255) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Dauer INT CHECK (Dauer > 0),
    Startjahr INT CHECK (Startjahr >= 1888),
    Beschreibung TEXT,
    Regisseur VARCHAR(255) NOT NULL,
    Darsteller TEXT
);

CREATE TABLE Saal (
    SaalID INT PRIMARY KEY,
    Name VARCHAR(255) UNIQUE NOT NULL,
    Kapazität INT CHECK (Kapazität > 0),
    Typ VARCHAR(100) DEFAULT 'Standard'
);

CREATE TABLE Vorstellung (
    VorstellungID INT PRIMARY KEY,
    FilmID INT,
    SaalID INT,
    Startzeit DATETIME NOT NULL,
    Endzeit DATETIME NOT NULL,
    Preis DECIMAL(5,2) CHECK (Preis >= 0),
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (SaalID) REFERENCES Saal(SaalID),
    CONSTRAINT CHK_Zeit CHECK (Endzeit > Startzeit)
);

CREATE TABLE Kunde (
    KundeID INT PRIMARY KEY,
    Vorname VARCHAR(100) NOT NULL,
    Nachname VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Telefon VARCHAR(20),
    Geburtsdatum DATE CHECK (Geburtsdatum <= CURDATE()),
    Adresse TEXT
);

CREATE TABLE Reservierung (
    ReservierungID INT PRIMARY KEY,
    KundeID INT,
    VorstellungID INT,
    Reservierungsdatum DATETIME DEFAULT CURRENT_TIMESTAMP,
    Reservierungsstatus VARCHAR(50) DEFAULT 'Ausstehend',
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID)
);

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    VorstellungID INT,
    KundeID INT,
    Sitzplatz VARCHAR(10) CHECK (Sitzplatz REGEXP '^[A-Z][0-9]+$'),
    Preis DECIMAL(5,2) CHECK (Preis >= 0),
    ZahlungsID INT,
    ReservierungID INT,
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (ZahlungsID) REFERENCES Zahlung(ZahlungsID),
    FOREIGN KEY (ReservierungID) REFERENCES Reservierung(ReservierungID)
);

CREATE TABLE Zahlung (
    ZahlungsID INT PRIMARY KEY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Zahlungsdatum DATETIME DEFAULT CURRENT_TIMESTAMP,
    Zahlungsmethode VARCHAR(50) CHECK (Zahlungsmethode IN ('Kreditkarte', 'PayPal', 'Bar', 'Überweisung')),
    KundeID INT,
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID)
);

CREATE TABLE Snack (
    SnackID INT PRIMARY KEY,
    Name VARCHAR(100) UNIQUE NOT NULL,
    Preis DECIMAL(5,2) CHECK (Preis >= 0),
    Beschreibung TEXT
);

CREATE TABLE Rabattaktion (
    RabattID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Prozentsatz INT CHECK (Prozentsatz BETWEEN 0 AND 100),
    Startdatum DATE,
    Enddatum DATE CHECK (Enddatum >= Startdatum),
    GültigFürFilmID INT,
    FOREIGN KEY (GültigFürFilmID) REFERENCES Film(FilmID)
);

CREATE TABLE Ticket_Snack (
    TicketID INT,
    SnackID INT,
    Menge INT CHECK (Menge > 0),
    PRIMARY KEY (TicketID, SnackID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID)
);
