create or replace procedure deleteperson(PUID in people.u_id%type)
is
execp1 EXCEPTION;
execp2 EXCEPTION;
BEGIN 
IF(PUID IS NULL) THEN RAISE execp1;
ELSIF(PERSON_EXISTS(PUID)=0) THEN RAISE execp2 ;
ELSE 
DELETE FROM PEOPLE WHERE U_ID=PUID; 
END IF; 
EXCEPTION
   WHEN execp1 THEN 
   dbms_output.put_line ('Please enter all fields');
   WHEN execp2 THEN 
   dbms_output.put_line ('That UID doesnt exist. please enter a valid UID');
END DELETEPERSON;