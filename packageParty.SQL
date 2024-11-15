create or replace package pkg_party
IS 
   FUNCTION PARTY_EXISTS(party_id IN NUMBER) RETURN NUMBER;
   FUNCTION party_NAME_EXISTS(pNAME in varchar) RETURN NUMBER;
   FUNCTION party_ADDRESS_EXISTS(pADDRESS in varchar) RETURN NUMBER; 
   procedure insert_new_party
   (PARTY_ID IN PARTY.PARTY_ID%TYPE , PARTY_NAME IN PARTY.PARTY_NAME%TYPE, PARTY_ADDRESS IN PARTY.PARTY_ADDRESS%TYPE , CONTACT_NUMBER IN PARTY.CONTACT_NUMBER%TYPE , EMAIL IN PARTY.EMAIL%TYPE);
   PROCEDURE UPDATE_party(P_ID IN PARTY.PARTY_ID%TYPE , P_NAME IN PARTY.PARTY_NAME%TYPE, P_ADDRESS IN PARTY.PARTY_ADDRESS%TYPE , C_NUMBER IN PARTY.CONTACT_NUMBER%TYPE , E_MAIL IN PARTY.EMAIL%TYPE);
   PROCEDURE DELETE_party(P_ID IN PARTY.PARTY_ID%TYPE);

END PKG_PARTY;
/
create or replace package body pkg_party
IS 
    FUNCTION PARTY_EXISTS(party_id IN NUMBER)
    RETURN NUMBER
    AS
    ret number;
    BEGIN
    SELECT COUNT(*) INTO ret from party where party_id = party_id;
    IF ret = 0
    THEN RETURN 0;
    ELSE
    RETURN 1;
    END IF;
    END PARTY_EXISTS;
    
    FUNCTION party_NAME_EXISTS(pNAME in varchar)
    RETURN NUMBER
    AS
    ret number;
    BEGIN
    SELECT COUNT(*) INTO ret from party where party_NAME = pname;
    IF ret = 0
    THEN RETURN 0;
    ELSE
    RETURN 1;
    END IF;
    END party_name_EXISTS;
    
    FUNCTION party_ADDRESS_EXISTS(pADDRESS in varchar)
    RETURN NUMBER
    AS
    ret number;
    BEGIN
    SELECT COUNT(*) INTO ret from party where party_ADDRESS = pADDRESS;
    IF ret = 0
    THEN RETURN 0;
    ELSE
    RETURN 1;
    END IF;
    END party_ADDRESS_EXISTS;
    
    procedure insert_new_party
    (PARTY_ID IN PARTY.PARTY_ID%TYPE , PARTY_NAME IN PARTY.PARTY_NAME%TYPE, 
    PARTY_ADDRESS IN PARTY.PARTY_ADDRESS%TYPE , CONTACT_NUMBER IN PARTY.CONTACT_NUMBER%TYPE , EMAIL IN PARTY.EMAIL%TYPE)
    IS 
    EXECP1 EXCEPTION; 
    EXECP2 EXCEPTION; 
    EXECP3 EXCEPTION;
    BEGIN
    IF(PARTY_EXISTS(PARTY_ID)=1) THEN RAISE EXECP1; --if partyID already exists
    ELSIF(PARTY_NAME_EXISTS(PARTY_NAME)=1) THEN RAISE EXECP2 ; --party name already exists
    ELSIF(PARTY_ID IS NULL OR PARTY_NAME IS NULL OR PARTY_ADDRESS IS NULL OR CONTACT_NUMBER IS NULL OR EMAIL IS NULL) THEN RAISE EXECP3 ; 
    ELSE 
    INSERT INTO PARTY VALUES(PARTY_ID, PARTY_NAME, PARTY_ADDRESS, CONTACT_NUMBER, EMAIL); 
    END IF; 
    EXCEPTION 
    WHEN EXECP1 THEN 
    DBMS_OUTPUT.PUT_LINE('That party ID already exists, please enter a new party ID');
    WHEN EXECP2 THEN
    DBMS_OUTPUT.PUT_LINE('That party name already exists, please enter a new party name');
    WHEN EXECP3 THEN 
    DBMS_OUTPUT.PUT_LINE('Please enter all the fields!');
    END INSERT_NEW_PARTY;
    
    procedure UPDATE_party
    (P_ID IN PARTY.PARTY_ID%TYPE , P_NAME IN PARTY.PARTY_NAME%TYPE, 
    P_ADDRESS IN PARTY.PARTY_ADDRESS%TYPE , C_NUMBER IN PARTY.CONTACT_NUMBER%TYPE , E_MAIL IN PARTY.EMAIL%TYPE)
    IS 
    EXECP1 EXCEPTION; 
    EXECP2 EXCEPTION; 
    EXECP3 EXCEPTION;
    EXECP4 EXCEPTION;
    BEGIN
    IF(PARTY_EXISTS(P_ID)=0) THEN RAISE EXECP1; --
    ELSIF(PARTY_NAME_EXISTS(P_NAME)=1) THEN RAISE EXECP2 ; --party name already exists
    ELSIF(PARTY_ADDRESS_EXISTS(P_ADDRESS)=1) THEN RAISE EXECP4 ;
    ELSIF(P_ID IS NULL OR P_NAME IS NULL OR P_ADDRESS IS NULL OR C_NUMBER IS NULL OR E_MAIL IS NULL) THEN RAISE EXECP3 ; 
    ELSE 
    UPDATE PARTY set party_name = p_name, party_address = p_address, contact_number=c_number, email= e_mail where party_id = p_id;
    END IF; 
    EXCEPTION 
    WHEN EXECP1 THEN 
    DBMS_OUTPUT.PUT_LINE('That party ID doesnt exists, please enter a valid party ID');
    WHEN EXECP2 THEN
    DBMS_OUTPUT.PUT_LINE('That party name already exists, please enter a new party name');
    WHEN EXECP3 THEN 
    DBMS_OUTPUT.PUT_LINE('Please enter all the fields!');
    WHEN EXECP4 THEN 
    DBMS_OUTPUT.PUT_LINE('That party address already exists, please enter a new party address');
    END UPDATE_PARTY;
    
    procedure DELETE_party
    (P_ID IN PARTY.PARTY_ID%TYPE)
    IS 
    EXECP1 EXCEPTION;
    EXECP2 EXCEPTION;
    BEGIN
    IF(PARTY_EXISTS(P_ID)=0) THEN RAISE EXECP1;
    ELSIF (P_ID IS NULL) THEN RAISE EXECP2;--
    ELSE 
    DELETE FROM PARTY WHERE PARTY_ID= P_ID;
    END IF; 
    EXCEPTION 
    WHEN EXECP1 THEN 
    DBMS_OUTPUT.PUT_LINE('That party ID doesnt exists, please enter a valid party ID');
    WHEN EXECP2 THEN 
    DBMS_OUTPUT.PUT_LINE('Please enter a valid party ID');
    END DELETE_PARTY;
    
END PKG_PARTY;
