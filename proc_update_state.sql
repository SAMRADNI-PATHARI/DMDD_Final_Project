create or replace procedure UPDATE_party
(P_ID IN PARTY.PARTY_ID%TYPE , P_NAME IN PARTY.PARTY_NAME%TYPE, 
P_ADDRESS IN PARTY.PARTY_ADDRESS%TYPE , C_NUMBER IN PARTY.CONTACT_NUMBER%TYPE , E_MAIL IN PARTY.EMAIL%TYPE)
IS 
EXECP1 EXCEPTION; 
EXECP2 EXCEPTION; 
EXECP3 EXCEPTION;
EXECP4 EXCEPTION;
BEGIN
IF(PARTY_EXISTS(P_ID)=0) THEN RAISE EXECP1; 

ELSIF(PARTY_NAME_EXISTS(P_NAME)=1) THEN RAISE EXECP2 ; 
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