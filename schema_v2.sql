CREATE TABLE Zahlungsmethode (
    ZahlungsmethodeID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Methode VARCHAR(50) UNIQUE NOT NULL CHECK (Methode IN ('Kreditkarte', 'PayPal', 'Bar', 'Überweisung'))
);

CREATE TABLE Preis (
    PreisID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Beschreibung VARCHAR(100)
);

CREATE TABLE Rabattaktion (
    RabattID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR(100) NOT NULL,
    Prozentsatz INT CHECK (Prozentsatz BETWEEN 0 AND 99),
    Startdatum DATE,
    Enddatum DATE CHECK (Enddatum >= Startdatum),
    GültigFürFilmID INT,
    FOREIGN KEY (GültigFürFilmID) REFERENCES Film(FilmID)
);

CREATE TABLE Film (
    FilmID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Titel VARCHAR(255) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Dauer INT CHECK (Dauer > 0),
    Startjahr INT CHECK (Startjahr >= 1900),
    Beschreibung TEXT,
    Regisseur VARCHAR(255) NOT NULL,
    Darsteller TEXT
);

CREATE TABLE Film_Rabattaktion (
    FilmID INT,
    RabattID INT,
    PRIMARY KEY (FilmID, RabattID),
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (RabattID) REFERENCES Rabattaktion(RabattID)
);

CREATE TABLE Vorstellung (
    VorstellungID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    FilmID INT,
    SaalID INT,
    Startzeit DATETIME NOT NULL,
    Endzeit DATETIME NOT NULL,
    PreisID INT,
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (SaalID) REFERENCES Saal(SaalID),
    FOREIGN KEY (PreisID) REFERENCES Preis(PreisID),
    CONSTRAINT CHK_Zeit CHECK (Endzeit > Startzeit)
);

CREATE TABLE Saal (
    SaalID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR(255) UNIQUE NOT NULL,
    Kapazität INT CHECK (Kapazität > 0),
    Typ VARCHAR(100) DEFAULT 'Standard'
);

CREATE TABLE Kunde (
    KundeID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Vorname VARCHAR(100) NOT NULL,
    Nachname VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Telefon VARCHAR(20),
    Geburtsdatum DATE CHECK (Geburtsdatum <= CURDATE()),
    Adresse TEXT
);

CREATE TABLE Reservierung (
    ReservierungID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    KundeID INT,
    VorstellungID INT,
    Reservierungsdatum DATETIME DEFAULT CURRENT_TIMESTAMP,
    Reservierungsstatus VARCHAR(50) DEFAULT 'Ausstehend',
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID)
);

CREATE TABLE Zahlung (
    ZahlungsID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Zahlungsdatum DATETIME DEFAULT CURRENT_TIMESTAMP,
    ZahlungsmethodeID INT,
    KundeID INT,
    FOREIGN KEY (ZahlungsmethodeID) REFERENCES Zahlungsmethode(ZahlungsmethodeID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID)
);

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    VorstellungID INT,
    KundeID INT,
    Sitzplatz VARCHAR(10),
    PreisID INT,
    ZahlungsID INT,
    ReservierungID INT,
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (PreisID) REFERENCES Preis(PreisID),
    FOREIGN KEY (ZahlungsID) REFERENCES Zahlung(ZahlungsID),
    FOREIGN KEY (ReservierungID) REFERENCES Reservierung(ReservierungID)
);

CREATE TABLE Snack (
    SnackID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR(100) UNIQUE NOT NULL,
    PreisID INT,
    Beschreibung TEXT,
    FOREIGN KEY (PreisID) REFERENCES Preis(PreisID)
);

CREATE TABLE Ticket_Snack (
    TicketID INT,
    SnackID INT,
    Menge INT CHECK (Menge >= 0),
    PRIMARY KEY (TicketID, SnackID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID)
);

CREATE TABLE Snack_Kauf (
    SnackKaufID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    SnackID INT,
    KundeID INT,
    ZahlungsID INT,
    Menge INT CHECK (Menge > 0),
    Kaufdatum DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (ZahlungsID) REFERENCES Zahlung(ZahlungsID)
);
