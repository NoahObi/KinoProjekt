CREATE TABLE Zahlungsmethode (
    ZahlungsmethodeID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Methode VARCHAR(50) UNIQUE NOT NULL CHECK (Methode IN ('Kreditkarte', 'Bar', 'Debitkarte'))
);

CREATE TABLE Preis (
    PreisID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Beschreibung VARCHAR(100)
);

CREATE TABLE Rabattaktion (
    RabattID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR(100) NOT NULL,
    Prozentsatz NUMBER CHECK (Prozentsatz BETWEEN 0 AND 99),
    Startdatum DATE,
    Enddatum DATE CHECK (Enddatum >= Startdatum),
    FilmID NUMBER,
    FOREIGN KEY (GültigFürFilmID) REFERENCES Film(FilmID)
);

CREATE TABLE Film (
    FilmID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Titel VARCHAR(255) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Dauer NUMBER CHECK (Dauer > 0),
    Startjahr NUMBER CHECK (Startjahr >= 1900),
    Beschreibung TEXT,
    Regisseur VARCHAR(255) NOT NULL,
    Darsteller TEXT
);

CREATE TABLE Film_Rabattaktion (
    FilmID NUMBER,
    RabattID NUMBER,
    PRIMARY KEY (FilmID, RabattID),
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (RabattID) REFERENCES Rabattaktion(RabattID)
);

CREATE TABLE Vorstellung (
    VorstellungID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    FilmID NUMBER,
    SaalID NUMBER,
    Startzeit DATETIME NOT NULL,
    Endzeit DATETIME NOT NULL,
    PreisID NUMBER,
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (SaalID) REFERENCES Saal(SaalID),
    FOREIGN KEY (PreisID) REFERENCES Preis(PreisID),
    CONSTRAINT CHK_Zeit CHECK (Endzeit > Startzeit)
);

CREATE TABLE Saal (
    SaalID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR(255) UNIQUE NOT NULL,
    Kapazität NUMBER CHECK (Kapazität > 0),
    Typ VARCHAR(100) DEFAULT 'Standard'
);

CREATE TABLE Kunde (
    KundeID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Vorname VARCHAR(100) NOT NULL,
    Nachname VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Telefon VARCHAR(20),
    Geburtsdatum DATE CHECK (Geburtsdatum <= CURDATE()),
    Adresse TEXT
);

CREATE TABLE Reservierung (
    ReservierungID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    KundeID NUMBER,
    VorstellungID NUMBER,
    Reservierungsdatum DATE DEFAULT SYSDATE,
    Reservierungsstatus VARCHAR(50) DEFAULT 'Ausstehend',
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID)
);

CREATE TABLE Zahlung (
    ZahlungsID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Zahlungsdatum DATETIME DEFAULT CURRENT_TIMESTAMP,
    ZahlungsmethodeID NUMBER,
    KundeID NUMBER,
    FOREIGN KEY (ZahlungsmethodeID) REFERENCES Zahlungsmethode(ZahlungsmethodeID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID)
);

CREATE TABLE Ticket (
    TicketID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    VorstellungID NUMBER,
    KundeID NUMBER,
    Sitzplatz VARCHAR(10),
    PreisID NUMBER,
    ZahlungsID NUMBER,
    ReservierungID NUMBER,
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (PreisID) REFERENCES Preis(PreisID),
    FOREIGN KEY (ZahlungsID) REFERENCES Zahlung(ZahlungsID),
    FOREIGN KEY (ReservierungID) REFERENCES Reservierung(ReservierungID)
);

CREATE TABLE Snack (
    SnackID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR(100) UNIQUE NOT NULL,
    PreisID NUMBER,
    Beschreibung TEXT,
    FOREIGN KEY (PreisID) REFERENCES Preis(PreisID)
);

CREATE TABLE Ticket_Snack (
    TicketID NUMBER,
    SnackID NUMBER,
    Menge NUMBER CHECK (Menge >= 0),
    PRIMARY KEY (TicketID, SnackID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID)
);

CREATE TABLE Snack_Kauf (
    SnackKaufID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    SnackID NUMBER,
    KundeID NUMBER,
    ZahlungsID NUMBER,
    Menge NUMBER CHECK (Menge > 0),
    Kaufdatum DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (ZahlungsID) REFERENCES Zahlung(ZahlungsID)
);
