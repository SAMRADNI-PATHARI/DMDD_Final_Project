create or replace package pkg_constituency
is 
   FUNCTION STATE_EXISTS(SID IN NUMBER) RETURN NUMBER;
   FUNCTION constituency_EXISTS(CID IN NUMBER)RETURN NUMBER ; 
   FUNCTION CONSTITUENCY_NAME_EXISTS(CNAME in varchar)RETURN NUMBER; 
  PROCEDURE fe_insertnewconstituency
                    (
                                 cname          IN constituency.constituency_name%type
                                 ,sid_          IN state.state_id%type                               
                               );
  PROCEDURE UPDATE_CONSTITUENCY(CID IN CONSTITUENCY.CONSTITUENCY_ID%TYPE, CNAME IN CONSTITUENCY.CONSTITUENCY_NAME%TYPE , SID IN CONSTITUENCY.STATE_ID%TYPE); 
   PROCEDURE delete_CONSTITUENCY(CID IN CONSTITUENCY.CONSTITUENCY_ID%TYPE); 

end pkg_constituency; 
/


create or replace package body pkg_constituency
is
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
    
    FUNCTION constituency_EXISTS(CID IN NUMBER)
    RETURN NUMBER
    AS
    ret number;
    BEGIN
    SELECT COUNT(*) INTO ret from constituency where constituency_id = CID;
    IF ret = 0
    THEN RETURN 0;
    ELSE
    RETURN 1;
    END IF;
    END constituency_EXISTS;
    
    FUNCTION CONSTITUENCY_NAME_EXISTS(CNAME in varchar)
    RETURN NUMBER
    AS
    ret number;
    BEGIN
    SELECT COUNT(*) INTO ret from CONSTITUENCY where CONSTITUENCY_NAME = Cname;
    IF ret = 0
    THEN RETURN 0;
    ELSE
    RETURN 1;
    END IF;
    END CONSTITUENCY_name_EXISTS;
    
  

PROCEDURE fe_insertnewconstituency
                    (
                                 cname          IN constituency.constituency_name%type
                                 ,sid_          IN state.state_id%type                               
                               )
IS
    same_count NUMBER;
    cnt number;
   
    excep1 EXCEPTION;
	excep2 EXCEPTION;
    excep3 EXCEPTION;
BEGIN
    SELECT
           COUNT(*)
		INTO
           cnt
		FROM
          constituency;
        
	IF ( cname IS NULL or sid_ IS NULL  )
	THEN RAISE excep1;
    
    ELSIF STATE_EXISTS(sid_) =0 
    THEN RAISE excep2;
    
	ELSE 
		SELECT
           COUNT(*)
		INTO
           same_count
		FROM
           constituency
		WHERE
           constituency_name like upper(cname);
        
    
		IF same_count = 0 THEN
			INSERT         INTO constituency
            VALUES
               (cnt+1
                    ,upper(cname)
                    ,sid_
               )
        ;
        DBMS_OUTPUT.PUT_LINE('Data successfully entered');    
        
        ELSE    
			RAISE excep3;
            
            END IF;
			
    END IF;
EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the State');
	WHEN excep2 THEN
		dbms_output.put_line ('No state exists with the given state ID');
    WHEN excep3 THEN
		dbms_output.put_line ('Constituency already exists');
	WHEN OTHERS THEN
		dbms_output.put_line(cnt);
		dbms_output.put_line(SQLERRM);
		dbms_output.put_line('Duplicate Entry. Data Already exists');


END fe_insertnewconstituency;
    
    PROCEDURE UPDATE_CONSTITUENCY
    (CID IN CONSTITUENCY.CONSTITUENCY_ID%TYPE, CNAME IN CONSTITUENCY.CONSTITUENCY_NAME%TYPE , SID IN CONSTITUENCY.STATE_ID%TYPE)
    IS 
    EXECP1 EXCEPTION;  -- if any of the fields are null
    EXECP2 EXCEPTION ; -- if that cid already exists
    EXECP3 EXCEPTION;  --  if given cname is already taken
    EXECP4 EXCEPTION;  -- if given sid doesnt exists
    begin 
    IF (CID IS NULL OR CNAME IS NULL OR SID IS NULL) THEN RAISE EXECP1; 
    ELSIF(constituency_EXISTS(CID)=0) THEN RAISE EXECP2; 
    ELSIF(CONSTITUENCY_NAME_EXISTS(CNAME)=1) THEN RAISE EXECP3; 
    ELSIF(STATE_EXISTS(SID)=0) THEN RAISE EXECP4; 
    ELSE 
    DELETE FROM CONSTITUENCY WHERE CONSTITUENCY_ID = CID;
    INSERT INTO CONSTITUENCY VALUES(CID, CNAME, SID); 
    END IF; 
    EXCEPTION 
    WHEN EXECP1 THEN 
    DBMS_OUTPUT.PUT_LINE('Please enter all the fields');
    WHEN EXECP2 THEN 
    DBMS_OUTPUT.PUT_LINE('That constituency ID DOESNT exist!Please enter a valid constituency ID');
    WHEN EXECP3 THEN
    DBMS_OUTPUT.PUT_LINE('That constituency name already exists!Please enter a valid constituency name');
    WHEN EXECP4 THEN
    DBMS_OUTPUT.PUT_LINE('That state ID doesnt exist. Please enter a valid state ID');
    END UPDATE_CONSTITUENCY;

    
    PROCEDURE delete_CONSTITUENCY
    (CID IN CONSTITUENCY.CONSTITUENCY_ID%TYPE)
    IS 
    EXECP1 EXCEPTION;  -- if any of the fields are null
    EXECP2 EXCEPTION ; -- if that cid doesnt exists
    begin 
    IF (CID IS NULL ) THEN RAISE EXECP1; 
    ELSIF(constituency_EXISTS(CID)=0) THEN RAISE EXECP2; 
    ELSE 
    delete from constituency where constituency_id=cid;
    DBMS_OUTPUT.PUT_LINE('Constitiuency deleted successfully!');
    END IF; 
    EXCEPTION 
    WHEN EXECP1 THEN 
    DBMS_OUTPUT.PUT_LINE('Please enter all the fields');
    WHEN EXECP2 THEN 
    DBMS_OUTPUT.PUT_LINE('That constituency ID DOESNT exist!Please enter a valid constituency ID');
    END DELETE_CONSTITUENCY;
    
END pkg_constituency;


    
    

  



