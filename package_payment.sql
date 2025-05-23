CREATE OR REPLACE PACKAGE cinema_payment_pkg AS
  PROCEDURE make_payment(
    p_kunde_id IN NUMBER,
    p_betrag IN DECIMAL,
    p_zahlungsmethode_id IN NUMBER,
    p_out_zahlung_id OUT NUMBER
  );
END cinema_payment_pkg;
/

CREATE OR REPLACE PACKAGE BODY cinema_payment_pkg AS

  PROCEDURE make_payment(
    p_kunde_id IN NUMBER,
    p_betrag IN DECIMAL,
    p_zahlungsmethode_id IN NUMBER,
    p_out_zahlung_id OUT NUMBER
  ) IS
  BEGIN

    SAVEPOINT start_payment;

    INSERT INTO Zahlung (Betrag, ZahlungsmethodeID, KundeID)
    VALUES (p_betrag, p_zahlungsmethode_id, p_kunde_id)
    RETURNING ZahlungsID INTO p_out_zahlung_id;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK TO start_payment;
      DBMS_OUTPUT.PUT_LINE('Fehler bei der Zahlung: ' || SQLERRM);
  END make_payment;

END cinema_payment_pkg;
/
