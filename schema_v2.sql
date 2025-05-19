-- Alte Objekte löschen (anpassen, falls nicht existieren)
BEGIN
  FOR rec IN (SELECT object_name, object_type FROM user_objects
              WHERE object_name IN (
                'TICKET_SNACK','SNACK_KAUF','TICKET','ZAHLUNG','RESERVIERUNG',
                'KUNDE','VORSTELLUNG','FILM_RABATTAKTION','RABATTAKTION','FILM',
                'SAAL','SNACK','PREIS','ZAHLUNGSMETHODE'
              ))
  LOOP
    EXECUTE IMMEDIATE 'DROP ' || rec.object_type || ' ' || rec.object_name || ' CASCADE CONSTRAINTS';
  END LOOP;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  FOR rec IN (SELECT sequence_name FROM user_sequences WHERE sequence_name LIKE 'SEQ_%')
  LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || rec.sequence_name;
  END LOOP;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Sequenzen anlegen
CREATE SEQUENCE seq_Zahlungsmethode START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Preis START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Rabattaktion START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Film START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Vorstellung START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Saal START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Kunde START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Reservierung START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Zahlung START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Ticket START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_Snack START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_SnackKauf START WITH 1 INCREMENT BY 1;

-- Tabellen anlegen

CREATE TABLE Zahlungsmethode (
    ZahlungsmethodeID NUMBER PRIMARY KEY,
    Methode VARCHAR2(50) UNIQUE NOT NULL CHECK (Methode IN ('Kreditkarte', 'Bar', 'Debitkarte'))
);

CREATE OR REPLACE TRIGGER trg_Zahlungsmethode_ID
BEFORE INSERT ON Zahlungsmethode
FOR EACH ROW
WHEN (NEW.ZahlungsmethodeID IS NULL)
BEGIN
  SELECT seq_Zahlungsmethode.NEXTVAL INTO :NEW.ZahlungsmethodeID FROM dual;
END;
/

CREATE TABLE Preis (
    PreisID NUMBER PRIMARY KEY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Beschreibung VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER trg_Preis_ID
BEFORE INSERT ON Preis
FOR EACH ROW
WHEN (NEW.PreisID IS NULL)
BEGIN
  SELECT seq_Preis.NEXTVAL INTO :NEW.PreisID FROM dual;
END;
/

CREATE TABLE Film (
    FilmID NUMBER PRIMARY KEY,
    Titel VARCHAR2(255) NOT NULL,
    Genre VARCHAR2(100) NOT NULL,
    Dauer NUMBER CHECK (Dauer > 0),
    Startjahr NUMBER(4,0) CHECK (Startjahr >= 1900),
    Beschreibung VARCHAR2(1000)
);

CREATE OR REPLACE TRIGGER trg_Film_ID
BEFORE INSERT ON Film
FOR EACH ROW
WHEN (NEW.FilmID IS NULL)
BEGIN
  SELECT seq_Film.NEXTVAL INTO :NEW.FilmID FROM dual;
END;
/

CREATE TABLE Saal (
    SaalID NUMBER PRIMARY KEY,
    SaalName VARCHAR2(255) UNIQUE NOT NULL,
    Kapazitaet NUMBER(3,0) CHECK (Kapazitaet > 0),
    Typ VARCHAR2(100) DEFAULT 'Standard'
);

CREATE OR REPLACE TRIGGER trg_Saal_ID
BEFORE INSERT ON Saal
FOR EACH ROW
WHEN (NEW.SaalID IS NULL)
BEGIN
  SELECT seq_Saal.NEXTVAL INTO :NEW.SaalID FROM dual;
END;
/

CREATE TABLE Rabattaktion (
    RabattID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Prozentsatz NUMBER(3,0) CHECK (Prozentsatz BETWEEN 0 AND 100),
    Startdatum DATE,
    Enddatum DATE,
    FilmID NUMBER,
    CONSTRAINT chk_enddatum CHECK (Enddatum >= Startdatum),
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID)
);

CREATE OR REPLACE TRIGGER trg_Rabattaktion_ID
BEFORE INSERT ON Rabattaktion
FOR EACH ROW
WHEN (NEW.RabattID IS NULL)
BEGIN
  SELECT seq_Rabattaktion.NEXTVAL INTO :NEW.RabattID FROM dual;
END;
/

CREATE TABLE Film_Rabattaktion (
    FilmID NUMBER,
    RabattID NUMBER,
    PRIMARY KEY (FilmID, RabattID),
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (RabattID) REFERENCES Rabattaktion(RabattID)
);

CREATE TABLE Vorstellung (
    VorstellungID NUMBER PRIMARY KEY,
    FilmID NUMBER,
    SaalID NUMBER,
    Startzeit TIMESTAMP NOT NULL,
    Endzeit TIMESTAMP NOT NULL,
    PreisID NUMBER,
    CONSTRAINT CHK_Zeit CHECK (Endzeit > Startzeit),
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (SaalID) REFERENCES Saal(SaalID),
    FOREIGN KEY (PreisID) REFERENCES Preis(PreisID)
);

CREATE OR REPLACE TRIGGER trg_Vorstellung_ID
BEFORE INSERT ON Vorstellung
FOR EACH ROW
WHEN (NEW.VorstellungID IS NULL)
BEGIN
  SELECT seq_Vorstellung.NEXTVAL INTO :NEW.VorstellungID FROM dual;
END;
/

CREATE TABLE Kunde (
    KundeID NUMBER PRIMARY KEY,
    Vorname VARCHAR2(100) NOT NULL,
    Nachname VARCHAR2(100) NOT NULL,
    Email VARCHAR2(255) UNIQUE NOT NULL,
    Telefon VARCHAR2(20),
    Geburtsdatum DATE,
    Adresse VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER trg_Kunde_ID
BEFORE INSERT ON Kunde
FOR EACH ROW
WHEN (NEW.KundeID IS NULL)
BEGIN
  SELECT seq_Kunde.NEXTVAL INTO :NEW.KundeID FROM dual;
END;
/

CREATE TABLE Reservierung (
    ReservierungID NUMBER PRIMARY KEY,
    KundeID NUMBER,
    VorstellungID NUMBER,
    Reservierungsdatum DATE DEFAULT SYSDATE,
    Reservierungsstatus VARCHAR2(50) DEFAULT 'Ausstehend',
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (VorstellungID) REFERENCES Vorstellung(VorstellungID)
);

CREATE OR REPLACE TRIGGER trg_Reservierung_ID
BEFORE INSERT ON Reservierung
FOR EACH ROW
WHEN (NEW.ReservierungID IS NULL)
BEGIN
  SELECT seq_Reservierung.NEXTVAL INTO :NEW.ReservierungID FROM dual;
END;
/

CREATE TABLE Zahlung (
    ZahlungsID NUMBER PRIMARY KEY,
    Betrag DECIMAL(5,2) CHECK (Betrag >= 0),
    Zahlungsdatum DATE DEFAULT SYSDATE,
    ZahlungsmethodeID NUMBER,
    KundeID NUMBER,
    FOREIGN KEY (ZahlungsmethodeID) REFERENCES Zahlungsmethode(ZahlungsmethodeID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID)
);

CREATE OR REPLACE TRIGGER trg_Zahlung_ID
BEFORE INSERT ON Zahlung
FOR EACH ROW
WHEN (NEW.ZahlungsID IS NULL)
BEGIN
  SELECT seq_Zahlung.NEXTVAL INTO :NEW.ZahlungsID FROM dual;
END;
/

CREATE TABLE Ticket (
    TicketID NUMBER PRIMARY KEY,
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

CREATE OR REPLACE TRIGGER trg_Ticket_ID
BEFORE INSERT ON Ticket
FOR EACH ROW
WHEN (NEW.TicketID IS NULL)
BEGIN
  SELECT seq_Ticket.NEXTVAL INTO :NEW.TicketID FROM dual;
END;
/

CREATE TABLE Snack (
    SnackID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) UNIQUE NOT NULL,
    PreisID NUMBER,
    Beschreibung VARCHAR2(100),
    FOREIGN KEY (PreisID) REFERENCES Preis(PreisID)
);

CREATE OR REPLACE TRIGGER trg_Snack_ID
BEFORE INSERT ON Snack
FOR EACH ROW
WHEN (NEW.SnackID IS NULL)
BEGIN
  SELECT seq_Snack.NEXTVAL INTO :NEW.SnackID FROM dual;
END;
/

CREATE TABLE Ticket_Snack (
    TicketID NUMBER,
    SnackID NUMBER,
    Menge NUMBER(3,0) CHECK (Menge >= 0),
    PRIMARY KEY (TicketID, SnackID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID)
);

CREATE TABLE Snack_Kauf (
    SnackKaufID NUMBER PRIMARY KEY,
    SnackID NUMBER,
    KundeID NUMBER,
    ZahlungsID NUMBER,
    Menge NUMBER(3,0) CHECK (Menge > 0),
    Kaufdatum DATE DEFAULT SYSDATE,
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID),
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID),
    FOREIGN KEY (ZahlungsID) REFERENCES Zahlung(ZahlungsID)
);

CREATE OR REPLACE TRIGGER trg_SnackKauf_ID
BEFORE INSERT ON Snack_Kauf
FOR EACH ROW
WHEN (NEW.SnackKaufID IS NULL)
BEGIN
  SELECT seq_SnackKauf.NEXTVAL INTO :NEW.SnackKaufID FROM dual;
END;
/
