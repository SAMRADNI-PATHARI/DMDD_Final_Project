create or replace PROCEDURE fe_deletecandidate
                    (
                                 cid          IN CANDIDATE.CANDIDATE_ID%type                               
                               )
IS

   
    excep1 EXCEPTION;
	excep2 EXCEPTION;
BEGIN


	IF ( cid IS NULL  )
	THEN RAISE excep1;

    ELSIF CANDIDATE_EXISTS(cid)=0
    THEN RAISE excep2;

	ELSE 

        DELETE FROM CANDIDATE WHERE CANDIDATE_ID =cid;


        DBMS_OUTPUT.PUT_LINE('Data successfully deleted');    





    END IF;
EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the candidate');
	WHEN excep2 THEN
		dbms_output.put_line ('No candidate exists with the given candidate_id');
	WHEN OTHERS THEN
		dbms_output.put_line(SQLERRM);


END fe_deletecandidate;