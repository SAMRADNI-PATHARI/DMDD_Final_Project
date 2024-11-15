create or replace PROCEDURE delete_CONSTITUENCY
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