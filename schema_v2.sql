SET SERVEROUTPUT ON;

CREATE TABLE Zahlungsmethode (
    ZahlungsmethodeID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Methode VARCHAR2(50) UNIQUE NOT NULL CHECK (Methode IN ('Kreditkarte', 'Bar', 'Debitkarte'))
);

CREATE TABLE Preis (
    PreisID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Beschreibung VARCHAR2(100)
);

CREATE TABLE Rabattaktion (
    RabattID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR2(100) NOT NULL,
    Prozentsatz NUMBER(3,0) CHECK (Prozentsatz BETWEEN 0 AND 100),
    Startdatum DATE,
    Enddatum DATE,
    FilmID NUMBER,
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    CONSTRAINT chk_datum CHECK (Enddatum >= Startdatum)
);

CREATE TABLE Film (
    FilmID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Titel VARCHAR2(255) NOT NULL,
    Genre VARCHAR2(100) NOT NULL,
    Dauer NUMBER CHECK (Dauer > 0),
    Startjahr NUMBER(4,0) CHECK (Startjahr >= 1900),
    Beschreibung VARCHAR2(1000)
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
    Name VARCHAR2(255) UNIQUE NOT NULL,
    Kapazitaet NUMBER(3,0) CHECK (Kapazitaet > 0),
    Typ VARCHAR2(100) DEFAULT 'Standard'
);

CREATE TABLE Kunde (
    KundeID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Vorname VARCHAR2(100) NOT NULL,
    Nachname VARCHAR2(100) NOT NULL,
    Email VARCHAR2(255) UNIQUE NOT NULL,
    Telefon VARCHAR2(20),
    Geburtsdatum DATE CHECK (Geburtsdatum <= TRUNC(SYSDATE)),
    Adresse VARCHAR2(100)
);

CREATE TABLE Reservierung (
    ReservierungID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    KundeID NUMBER,
    VorstellungID NUMBER,
    Reservierungsdatum DATE DEFAULT SYSDATE,
    Reservierungsstatus VARCHAR2(50) DEFAULT 'Ausstehend',
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID)
);

CREATE TABLE Zahlung (
    ZahlungsID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Zahlungsdatum DATE DEFAULT SYSDATE,
    ZahlungsmethodeID NUMBER,
    KundeID NUMBER,
    FOREIGN KEY (ZahlungsmethodeID) REFERENCES Zahlungsmethode(ZahlungsmethodeID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID)
);

CREATE TABLE Ticket (
    TicketID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    VorstellungID NUMBER,
    KundeID NUMBER,
    Sitzplatz VARCHAR2(10),
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
    Name VARCHAR2(100) UNIQUE NOT NULL,
    PreisID NUMBER,
    Beschreibung VARCHAR2(100),
    FOREIGN KEY (PreisID) REFERENCES Preis(PreisID)
);

CREATE TABLE Ticket_Snack (
    TicketID NUMBER,
    SnackID NUMBER,
    Menge NUMBER(3,0) CHECK (Menge >= 0),
    PRIMARY KEY (TicketID, SnackID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID)
);

CREATE TABLE Snack_Kauf (
    SnackKaufID NUMBER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    SnackID NUMBER,
    KundeID NUMBER,
    ZahlungsID NUMBER,
    Menge NUMBER(3,0) CHECK (Menge > 0),
    Kaufdatum DATE DEFAULT SYSDATE,
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (ZahlungsID) REFERENCES Zahlung(ZahlungsID)
);


--Business-Case 1: Kinoprogramm verwalten & anzeigen

BEGIN
  FOR rec IN (
    SELECT f.Titel, v.Startzeit, v.Endzeit, s.Name AS Saal
    FROM Vorstellung v
    JOIN Film f ON f.FilmID = v.FilmID
    JOIN Saal s ON s.SaalID = v.SaalID
    WHERE TRUNC(v.Startzeit) = TRUNC(SYSDATE)
    ORDER BY v.Startzeit
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Titel: ' || rec.Titel || 
                         ', Start: ' || TO_CHAR(rec.Startzeit, 'HH24:MI') || 
                         ', Ende: ' || TO_CHAR(rec.Endzeit, 'HH24:MI') || 
                         ', Saal: ' || rec.Saal);
  END LOOP;
END;
/


--Business-Case 2: Ticketverkauf inkl. Snacks und Zahlungen

BEGIN
  FOR rec IN (
    SELECT f.Titel, v.Startzeit, sn.Name AS Snack, SUM(ts.Menge) AS GesamtMenge
    FROM Ticket t
    JOIN Vorstellung v ON t.VorstellungID = v.VorstellungID
    JOIN Film f ON f.FilmID = v.FilmID
    JOIN Ticket_Snack ts ON ts.TicketID = t.TicketID
    JOIN Snack sn ON sn.SnackID = ts.SnackID
    GROUP BY f.Titel, v.Startzeit, sn.Name
    ORDER BY f.Titel, v.Startzeit
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Titel: ' || rec.Titel || 
                         ', Start: ' || TO_CHAR(rec.Startzeit, 'DD.MM.YY HH24:MI') || 
                         ', Snack: ' || rec.Snack || 
                         ', Menge: ' || rec.GesamtMenge);
  END LOOP;
END;
/


--Business-Case 3: Rabattaktionen verwalten & auswerten

BEGIN
  FOR rec IN (
    SELECT f.Titel, r.Name AS Rabattaktion, r.Prozentsatz
    FROM Rabattaktion r
    JOIN Film f ON r.FilmID = f.FilmID
    WHERE TRUNC(SYSDATE) BETWEEN TRUNC(r.Startdatum) AND TRUNC(r.Enddatum)
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Titel: ' || rec.Titel || 
                         ', Rabattaktion: ' || rec.Rabattaktion || 
                         ', Prozent: ' || rec.Prozentsatz || '%');
  END LOOP;
END;
/
