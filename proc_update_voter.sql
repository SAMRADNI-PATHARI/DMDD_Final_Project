create or replace PROCEDURE fe_updatevoter
                    (
                                   v_id        IN voter.voter_id%type
                                 , issue_date  IN voter.issue_date%type
                                 , uid         IN voter.u_id%type

                               )
AS
    
    excep1 EXCEPTION;
	excep2 EXCEPTION;
	excep3 EXCEPTION;
	excep4 EXCEPTION;
    excep5 EXCEPTION;
BEGIN


	IF (issue_date IS NULL OR uid IS NULL  )
	THEN RAISE excep1;

	ELSIF (NOT REGEXP_LIKE(issue_date, '^[0-9]{2}-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{2}$'))
    THEN

    RAISE excep2; 

    ELSIF (issue_date > SYSDATE)
    THEN RAISE excep3;
    ELSIF PERSON_EXISTS(uid) = 0
    THEN RAISE excep5;

	ELSE 
		UPDATE VOTER SET
        issue_date= issue_date,
        expiry_date= ADD_MONTHS(issue_date,60),
        U_ID= uid
    WHERE
        VOTER_ID= v_id;

        IF issue_date < SYSDATE THEN
           RAISE excep3;


        ELSE    
			RAISE excep4;

            END IF;


    END IF;
EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the Voter');
	WHEN excep2 THEN
		dbms_output.put_line ('Please enter correct format for issue date: DD-MON-YY');
	WHEN excep3 THEN
		dbms_output.put_line ('Issue Date cannot be in future');
	WHEN excep4 THEN
		 DBMS_OUTPUT.PUT_LINE ('Voter Already has his UID');
	WHEN excep5 THEN
		 DBMS_OUTPUT.PUT_LINE ('No person exists with the given UID');
	WHEN OTHERS THEN
		dbms_output.put_line(SQLERRM);
		dbms_output.put_line('Duplicate Entry. Data Already exists');


END fe_updatevoter;