CREATE OR REPLACE PACKAGE pkg_position 
IS 
    FUNCTION POSITION_EXISTS(UID_ IN NUMBER) RETURN NUMBER; 
    PROCEDURE fe_insertnewposition(consid  IN position.constituency_id%type,pname IN position.position_name%type,prep IN position.position_resp%type,
    pstart IN varchar2,cid IN position.candidate_id%type); 
    PROCEDURE fe_updateposition ( consid IN position.constituency_id%type,posid IN position.position_id%type,pname IN position.position_name%type,
    prep  IN position.position_resp%type,pstart IN varchar2,cid  IN position.candidate_id%type); 
    PROCEDURE fe_deleteposition(posid IN position.position_id%type );

END PKG_POSITION;
/
CREATE OR REPLACE PACKAGE BODY pkg_position
IS 
    FUNCTION POSITION_EXISTS(UID_ IN NUMBER)
    RETURN NUMBER
    AS
    ret number;
    BEGIN
    SELECT COUNT(*) INTO ret from position where position_id = UID_;
    IF ret = 0
    THEN RETURN 0;
    ELSE
    RETURN 1;
    END IF;
    END POSITION_EXISTS;
    
    
    PROCEDURE fe_insertnewposition(consid IN position.constituency_id%type,
    pname IN position.position_name%type,prep IN position.position_resp%type,pstart IN varchar2,cid IN position.candidate_id%type)
    IS
    same_count NUMBER;
    cnt number;
    excep1 EXCEPTION;
	excep2 EXCEPTION;
    excep3 EXCEPTION;
    excep4 EXCEPTION;
    excep5 EXCEPTION;
    excep6 EXCEPTION;
    BEGIN
    SELECT COUNT(*) INTO cnt FROM position;
    SELECT COUNT(*) INTO same_count FROM Position WHERE candidate_id = cid;
    IF ( consid IS NULL OR pname IS NULL or cid IS NULL OR prep IS NULL OR pstart  IS NULL  )
    THEN RAISE excep1;
    ELSIF CONSTITUENCY_EXISTS(consid) =0 
    THEN RAISE excep2;
    ELSIF CANDIDATE_EXISTS(cid) =0 
    THEN RAISE excep3;
    ELSIF  IS_TIMESTAMP_VALID(pstart) =false
    THEN RAISE excep4;
    ELSIF to_timestamp(pstart) < SYSTIMESTAMP THEN RAISE excep5;
    ELSIF same_count !=0 THEN RAISE excep6;
    ELSE INSERT INTO position VALUES(consid,cnt+1,pname,prep,to_timestamp(pstart),to_timestamp(pstart ) + (1/1440*480) ,cid);
    DBMS_OUTPUT.PUT_LINE('Data successfully entered');   
    END IF;
    EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the Position');
	WHEN excep2 THEN
		dbms_output.put_line ('No Constituency exists with the given constituency ID');
	WHEN excep3 THEN
		dbms_output.put_line ('No Candidate exists with the given candidate ID');
    WHEN excep4 THEN
		dbms_output.put_line ('Please enter correct format for timestamp : DD-MON-YY HH.MM.SS.MS AM/PM');
    WHEN excep5 THEN
		dbms_output.put_line ('Please position start date cannot be in past');
    WHEN excep6 THEN
		dbms_output.put_line ('Candidate is already contesting for a position');
	WHEN OTHERS THEN
		dbms_output.put_line(cnt);
		dbms_output.put_line(SQLERRM);
		dbms_output.put_line('Duplicate Entry. Data Already exists');
    END fe_insertnewposition;
    
    PROCEDURE fe_updateposition ( consid IN position.constituency_id%type,posid  IN position.position_id%type,
    pname IN position.position_name%type,prep IN position.position_resp%type,pstart IN varchar2,cid IN position.candidate_id%type)
    IS
    excep1 EXCEPTION;
	excep2 EXCEPTION;
    excep3 EXCEPTION;
    excep4 EXCEPTION;
    excep5 EXCEPTION;
    excep6 EXCEPTION;
    BEGIN
	IF ( consid IS NULL OR pname IS NULL or cid IS NULL OR prep IS NULL OR pstart  IS NULL  )
	THEN RAISE excep1;
    ELSIF CONSTITUENCY_EXISTS(consid) =0 
    THEN RAISE excep2;
    ELSIF CANDIDATE_EXISTS(cid) =0 
    THEN RAISE excep3;
    ELSIF  IS_TIMESTAMP_VALID(pstart) =false
    THEN
    RAISE excep4; 
    ELSIF to_timestamp(pstart) < SYSTIMESTAMP
    THEN
    RAISE excep5;
    ELSIF   POSITION_EXISTS(POSID) =0
    THEN RAISE excep6;
    ELSE 
    DELETE FROM POSITION WHERE POSITION_ID =posid;
    INSERT INTO position VALUES(consid,posid,pname,prep,to_timestamp(pstart),to_timestamp(pstart ) + (1/1440*480) ,cid);
    DBMS_OUTPUT.PUT_LINE('Data successfully entered');    
    END IF;
    EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the Position');
	WHEN excep2 THEN
		dbms_output.put_line ('No Constituency exists with the given constituency ID');
	WHEN excep3 THEN
		dbms_output.put_line ('No Candidate exists with the given candidate ID');
    WHEN excep4 THEN
		dbms_output.put_line ('Please enter correct format for timestamp : DD-MON-YY HH.MM.SS.MS AM/PM');
    WHEN excep5 THEN
		dbms_output.put_line ('Please position start date cannot be in past');
    WHEN excep6 THEN
		dbms_output.put_line ('Position id mentioned does not exist');
	WHEN OTHERS THEN
		dbms_output.put_line(SQLERRM);
    END fe_updateposition;

    PROCEDURE fe_deleteposition(posid IN position.position_id%type)
    IS
    excep1 EXCEPTION;
	excep2 EXCEPTION;
    BEGIN
    IF ( posid IS NULL  )
	THEN RAISE excep1;
    ELSIF POSITION_EXISTS(posid)=0
    THEN RAISE excep2;
    ELSE 
        DELETE FROM POSITION WHERE POSITION_ID =posid;     
        DBMS_OUTPUT.PUT_LINE('Data successfully deleted');    
    END IF;
    EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the position');
	WHEN excep2 THEN
		dbms_output.put_line ('No position exists with the given position_id');
	WHEN OTHERS THEN
		dbms_output.put_line(SQLERRM);
    END fe_deleteposition;

END PKG_POSITION;





    
    
    

    
    

