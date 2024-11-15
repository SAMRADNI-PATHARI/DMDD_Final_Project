create or replace PROCEDURE fe_insertnewvoter
                    (
                                   idate        IN varchar2
                                 , uid_          IN voter.u_id%type                               
                               )
IS
    same_count NUMBER;
    edate date;
    cnt number;

    excep1 EXCEPTION;
	excep2 EXCEPTION;
	excep3 EXCEPTION;
	excep4 EXCEPTION;
    excep5 EXCEPTION;
    excep6 EXCEPTION;
BEGIN
    SELECT
           COUNT(*)
		INTO
           cnt
		FROM
          voter;

	IF (idate IS NULL OR uid_ IS NULL  )
	THEN RAISE excep1;

	ELSIF IS_DATE_VALID(idate)=false
    THEN

    RAISE excep2; 

    ELSIF (idate > SYSDATE)
    THEN RAISE excep3;
    ELSIF PERSON_EXISTS(uid_) = 0
    THEN RAISE excep5;

    ELSIF TOCHECK_ELIGIBILITY(uid_)=0
    THEN RAISE excep6;

	ELSE 
		SELECT
           COUNT(*)
		INTO
           same_count
		FROM
           voter
		WHERE
           voter.u_id =uid_;


		IF same_count = 0 THEN
			INSERT         INTO voter
            VALUES
               (cnt+1
                    ,idate
                    ,ADD_MONTHS(idate,60)
                    , uid_
               )
        ;
        DBMS_OUTPUT.PUT_LINE('Data successfully entered');

		ELSE
        SELECT 
            expiry_date
        INTO
            edate
        FROM
            VOTER
        WHERE
            voter.u_id = uid_;
        IF edate < SYSDATE THEN
        DELETE FROM VOTER WHERE u_id = uid_;
            INSERT         INTO voter
            VALUES
               (cnt+1
                    ,idate
                    ,ADD_MONTHS(idate,60)
                    , uid_
               )
        ;
        DBMS_OUTPUT.PUT_LINE('Data successfully entered');


        ELSE    
			RAISE excep4;

            END IF;

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
    WHEN excep6 THEN
		 DBMS_OUTPUT.PUT_LINE ('Voter age is less than 18');
	WHEN OTHERS THEN
		dbms_output.put_line(cnt);
		dbms_output.put_line(SQLERRM);
		dbms_output.put_line('Duplicate Entry. Data Already exists');


END fe_insertnewvoter;