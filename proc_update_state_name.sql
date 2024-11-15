create or replace procedure update_state_name
(sid IN STATE.STATE_ID%TYPE , SNAME IN STATE.STATE_NAME%TYPE)
IS 
EXECP1 EXCEPTION ; -- if not a valid state_id
EXECP2 EXCEPTION;  -- if given state name already exists
EXECP3 EXCEPTION;  -- if given state name is null
BEGIN 
IF (SNAME IS NULL ) THEN RAISE EXECP3;
ELSIF (STATE_EXISTS(SID)=0) THEN  RAISE EXECP1 ; 
ELSIF (STATE_NAME_EXISTS(SNAME)=1) THEN RAISE EXECP2; 
ELSE 
    UPDATE STATE SET STATE_NAME = SNAME WHERE STATE_ID = SID; 
    DBMS_OUTPUT.PUT_LINE('State name updated successfully'); 

    end if; 
EXCEPTION 
   WHEN EXECP1 THEN 
    DBMS_OUTPUT.PUT_LINE('Please enter a valid state ID');
    WHEN EXECP2 THEN 
    DBMS_OUTPUT.PUT_LINE('That state name already exists, please enter a new state name');
    WHEN EXECP3 THEN
    DBMS_OUTPUT.PUT_LINE('Please enter a valid state name');
END update_state_name;

-- procedure delete state---


--