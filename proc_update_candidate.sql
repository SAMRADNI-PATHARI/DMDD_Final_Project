create or replace PROCEDURE fe_updatecandidate(uid IN candidate.u_id%type,pid IN candidate.party_id%type,cid IN candidate.candidate_id%type,
                            expr IN candidate.exp_years%type,jdate IN varchar2,pparty IN candidate.previous_party%type)
IS
    excep1 EXCEPTION;
	excep2 EXCEPTION;
    excep3 EXCEPTION;
    excep4 EXCEPTION;
    excep5 EXCEPTION;
    excep6 EXCEPTION;
BEGIN
    IF ( uid IS NULL OR pid IS NULL or cid IS NULL or expr IS NULL OR jdate IS NULL OR pparty  IS NULL  )
	THEN RAISE excep1;
    ELSIF PERSON_EXISTS(uid) =0 
    THEN RAISE excep2;
    ELSIF PARTY_EXISTS(pid) =0 
    THEN RAISE excep3;
    ELSIF IS_DATE_VALID(jdate) = false
    THEN  RAISE excep4;
    ELSIF jdate > SYSDATE
    THEN
    RAISE excep5;
    ELSIF CANDIDATE_EXISTS(cid) = 0
    THEN RAISE excep6;
    ELSE DELETE FROM CANDIDATE WHERE CANDIDATE_ID = cid;
    INSERT INTO candidate VALUES(uid,pid,cid,expr,to_date(jdate),pparty);
    DBMS_OUTPUT.PUT_LINE('Data successfully updated');    
   END IF;
EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the Candidate');
	WHEN excep2 THEN
		dbms_output.put_line ('No Person exists with the given  UID');
	WHEN excep3 THEN
		dbms_output.put_line ('No Party exists with the given Party ID');
    WHEN excep4 THEN
		dbms_output.put_line ('Please enter correct format for date : DD-MON-YY ');
    WHEN excep5 THEN
		dbms_output.put_line (' Join date cannot be in future');
    WHEN excep6 THEN
		dbms_output.put_line (' Candidate does not exist for the provided candidate id');
	WHEN OTHERS THEN
		dbms_output.put_line(SQLERRM);
END fe_updatecandidate;