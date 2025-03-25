CREATE TABLE Film (
    FilmID INT PRIMARY KEY,
    Titel VARCHAR(255),
    Genre VARCHAR(100),
    Dauer INT,
    Startjahr INT,
    Beschreibung TEXT,
    Regisseur VARCHAR(255),
    Darsteller TEXT
);

CREATE TABLE Saal (
    SaalID INT PRIMARY KEY,
    Name VARCHAR(255),
    Kapazität INT,
    Typ VARCHAR(100)
);

CREATE TABLE Vorstellung (
    VorstellungID INT PRIMARY KEY,
    FilmID INT,
    SaalID INT,
    Startzeit DATETIME,
    Endzeit DATETIME,
    Preis DECIMAL(5,2),
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (SaalID) REFERENCES Saal(SaalID)
);

CREATE TABLE Kunde (
    KundeID INT PRIMARY KEY,
    Vorname VARCHAR(100),
    Nachname VARCHAR(100),
    Email VARCHAR(255),
    Telefon VARCHAR(20),
    Geburtsdatum DATE,
    Adresse TEXT
);

CREATE TABLE Reservierung (
    ReservierungID INT PRIMARY KEY,
    KundeID INT,
    VorstellungID INT,
    Reservierungsdatum DATETIME,
    Reservierungsstatus VARCHAR(50),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID)
);

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    VorstellungID INT,
    KundeID INT,
    Sitzplatz VARCHAR(10),
    Preis DECIMAL(5,2),
    ZahlungsID INT,
    ReservierungID INT,
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (ZahlungsID) REFERENCES Zahlung(ZahlungsID),
    FOREIGN KEY (ReservierungID) REFERENCES Reservierung(ReservierungID)
);

CREATE TABLE Zahlung (
    ZahlungsID INT PRIMARY KEY,
    Betrag DECIMAL(5,2),
    Zahlungsdatum DATETIME,
    Zahlungsmethode VARCHAR(50),
    KundeID INT,
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID)
);

CREATE TABLE Snack (
    SnackID INT PRIMARY KEY,
    Name VARCHAR(100),
    Preis DECIMAL(5,2),
    Beschreibung TEXT
);

CREATE TABLE Rabattaktion (
    RabattID INT PRIMARY KEY,
    Name VARCHAR(100),
    Prozentsatz INT,
    Startdatum DATE,
    Enddatum DATE,
    GültigFürFilmID INT,
    FOREIGN KEY (GültigFürFilmID) REFERENCES Film(FilmID)
);

CREATE TABLE Ticket_Snack (
    TicketID INT,
    SnackID INT,
    Menge INT,
    PRIMARY KEY (TicketID, SnackID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID)
);
