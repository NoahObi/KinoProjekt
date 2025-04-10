DROP TABLE Ticket_Snack;
DROP TABLE Ticket;
DROP TABLE Zahlung;
DROP TABLE Reservierung;
DROP TABLE Vorstellung;
DROP TABLE Rabattaktion;
DROP TABLE Film;
DROP TABLE Saal;
DROP TABLE Snack;
DROP TABLE Kunde;

CREATE TABLE Saal (
    SaalID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR2(255) UNIQUE NOT NULL,
    Kapazitaet NUMBER(3,0) CHECK (Kapazitaet > 0),
    Typ VARCHAR2(100) DEFAULT 'Standard'
);

CREATE TABLE Film (
    FilmID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Titel VARCHAR(255) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Dauer INT CHECK (Dauer > 0),
    Startjahr INT CHECK (Startjahr >= 1900),
    Beschreibung VARCHAR(100),
    Regisseur VARCHAR(255) NOT NULL
);

CREATE TABLE Kunde (
    KundeID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Vorname VARCHAR(100) NOT NULL,
    Nachname VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Telefon VARCHAR(20),
    Geburtsdatum DATE CHECK (Geburtsdatum <= SYSDATE),
    Adresse VARCHAR(100)
);

CREATE TABLE Vorstellung (
    VorstellungID INT PRIMARY KEY,
    FilmID INT,
    SaalID INT,
    Startzeit DATE NOT NULL,
    Endzeit DATE NOT NULL,
    Preis DECIMAL(5,2) CHECK (Preis >= 0),
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (SaalID) REFERENCES Saal(SaalID),
    CONSTRAINT CHK_Zeit CHECK (Endzeit > Startzeit)
);

CREATE TABLE Rabattaktion (
    RabattID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Prozentsatz INT CHECK (Prozentsatz BETWEEN 0 AND 100),
    Startdatum DATE,
    Enddatum DATE,
    FilmID INT,
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    CONSTRAINT chk_datum CHECK (Enddatum >= Startdatum)
);

CREATE TABLE Reservierung (
    ReservierungID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    KundeID INT,
    VorstellungID INT,
    Reservierungsdatum DATE DEFAULT SYSDATE,
    Reservierungsstatus VARCHAR(50) DEFAULT 'Ausstehend',
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID)
);

CREATE TABLE Zahlung (
    ZahlungsID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Zahlungsdatum DATE DEFAULT CURRENT_TIMESTAMP,
    Zahlungsmethode VARCHAR(50) CHECK (Zahlungsmethode IN ('Kreditkarte', 'PayPal', 'Bar', 'Überweisung')),
    KundeID INT,
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID)
);

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    VorstellungID INT,
    KundeID INT,
    Sitzplatz VARCHAR(10),
    Preis DECIMAL(5,2) CHECK (Preis >= 0),
    ZahlungsID INT,
    ReservierungID INT,
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (ZahlungsID) REFERENCES Zahlung(ZahlungsID),
    FOREIGN KEY (ReservierungID) REFERENCES Reservierung(ReservierungID)
);

CREATE TABLE Snack (
    SnackID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR(100) UNIQUE NOT NULL,
    Preis DECIMAL(5,2) CHECK (Preis >= 0),
    Beschreibung VARCHAR(100)
);

CREATE TABLE Ticket_Snack (
    TicketID INT,
    SnackID INT,
    Menge INT CHECK (Menge >= 0),
    PRIMARY KEY (TicketID, SnackID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID)
);
