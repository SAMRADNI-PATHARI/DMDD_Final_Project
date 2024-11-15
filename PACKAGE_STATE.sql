create or replace package pkg_state
is
    FUNCTION STATE_EXISTS(SID IN NUMBER) RETURN NUMBER;
    FUNCTION STATE_NAME_EXISTS(SNAME in varchar) RETURN NUMBER;
    PROCEDURE fe_insertnewstate (sname IN state.state_name%type ); 
    procedure update_state_name(sid IN STATE.STATE_ID%TYPE , SNAME IN STATE.STATE_NAME%TYPE) ; 
    procedure delete_state(sid in state.state_id%type);
end pkg_state;
/

create or replace package body pkg_state
is 
    -- function state_exists

    FUNCTION STATE_EXISTS(SID IN NUMBER)
    RETURN NUMBER
    AS
    ret number;
    BEGIN
    SELECT COUNT(*) INTO ret from STATE where state_id = SID;
    IF ret = 0
    THEN RETURN 0;
    ELSE
    RETURN 1;
    END IF;
    END STATE_EXISTS;

    --function state_name_exists

    FUNCTION STATE_NAME_EXISTS(SNAME in varchar)
    RETURN NUMBER
    AS
    ret number;
    BEGIN
    SELECT COUNT(*) INTO ret from STATE where state_NAME = sname;
    IF ret = 0
    THEN RETURN 0;
    ELSE
    RETURN 1;
    END IF;
    END STATE_name_EXISTS;
    
    --procedure insert state
    
    PROCEDURE fe_insertnewstate(sname IN state.state_name%type )
    IS
    same_count NUMBER;
    cnt number;
    excep1 EXCEPTION;
	excep2 EXCEPTION;
    BEGIN
    SELECT COUNT(*) iNTO cnt FROM state;
    IF ( sname IS NULL  )
	THEN RAISE excep1;
    ELSE SELECT COUNT(*) INTO same_count FROM state WHERE state_name like upper(sname);
    IF same_count = 0 
    THEN
    INSERT INTO state VALUES (cnt+1,upper(sname));
    DBMS_OUTPUT.PUT_LINE('Data successfully entered');    
    ELSE  RAISE excep2;
    END IF;
    END IF;
    EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the State');
	WHEN excep2 THEN
		dbms_output.put_line ('State already exists');
	WHEN OTHERS THEN
		dbms_output.put_line(cnt);
		dbms_output.put_line(SQLERRM);
		dbms_output.put_line('Duplicate Entry. Data Already exists');
    END fe_insertnewstate;
    
    --procedure update state

    procedure update_state_name(sid IN STATE.STATE_ID%TYPE , SNAME IN STATE.STATE_NAME%TYPE)
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
    
    --procedure delete state

    procedure delete_state(sid in state.state_id%type)
    is 
    execp1 exception; 
    execp2  exception;
    begin 
    if(sid is null) then raise execp1; 
    elsif (state_exists(sid)=0) then raise execp2; 
    else
   delete from state where state_id = sid;
    end if ; 
    exception 
    when execp1 then 
   DBMS_OUTPUT.PUT_LINE('Please enter a valid state ID');
    when execp2 then 
    DBMS_OUTPUT.PUT_LINE('That State ID doesnt exist. Enter a valid state ID!');
    end delete_state;

end pkg_state;
