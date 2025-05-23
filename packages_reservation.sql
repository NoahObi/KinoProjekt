
CREATE OR REPLACE PACKAGE cinema_reservation_pkg AS
  PROCEDURE make_reservation(
    p_kunde_id IN NUMBER,
    p_vorstellung_id IN NUMBER,
    p_sitzplatz IN VARCHAR2
  );
END cinema_reservation_pkg;
/

CREATE OR REPLACE PACKAGE BODY cinema_reservation_pkg AS


  e_doppelte_reservierung EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_doppelte_reservierung, -20001);

  PROCEDURE make_reservation(
    p_kunde_id IN NUMBER,
    p_vorstellung_id IN NUMBER,
    p_sitzplatz IN VARCHAR2
  ) IS
    v_reservierung_id Reservierung.ReservierungID%TYPE;
    v_ticket_id Ticket.TicketID%TYPE;
  BEGIN

    SAVEPOINT start_reservation;


    IF EXISTS (
      SELECT 1 FROM Ticket 
      WHERE VorstellungID = p_vorstellung_id AND Sitzplatz = p_sitzplatz
    ) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Sitzplatz bereits reserviert.');
    END IF;

    INSERT INTO Reservierung (KundeID, VorstellungID)
    VALUES (p_kunde_id, p_vorstellung_id)
    RETURNING ReservierungID INTO v_reservierung_id;


    INSERT INTO Ticket (VorstellungID, KundeID, Sitzplatz, ReservierungID)
    VALUES (p_vorstellung_id, p_kunde_id, p_sitzplatz, v_reservierung_id)
    RETURNING TicketID INTO v_ticket_id;

    COMMIT;

  EXCEPTION
    WHEN e_doppelte_reservierung THEN
      ROLLBACK TO start_reservation;
      DBMS_OUTPUT.PUT_LINE('Fehler: Sitzplatz bereits vergeben.');
    WHEN OTHERS THEN
      ROLLBACK TO start_reservation;
      DBMS_OUTPUT.PUT_LINE('Unerwarteter Fehler: ' || SQLERRM);
  END make_reservation;

END cinema_reservation_pkg;
/
