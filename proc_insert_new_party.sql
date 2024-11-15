create or replace PROCEDURE fe_insertnewparty
                    (
                                 pname          IN party.party_name%type
                                ,paddress       IN party.party_address%type
                                ,phone          IN party.contact_number%type
                                ,mail           IN party.email%type
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
          party;

	IF ( pname IS NULL OR paddress IS NULL OR phone IS NULL OR mail IS NULL )
	THEN RAISE excep1;

    ELSIF mail NOT LIKE '%@%.%'
    THEN RAISE excep3;

	ELSE 
		SELECT
           COUNT(*)
		INTO
           same_count
		FROM
           party
		WHERE
           party_name like upper(pname);


		IF same_count = 0 THEN
			INSERT INTO PARTY
            VALUES
               (cnt+1
                    ,upper(pname)
                    ,paddress
                    ,phone
                    ,mail
               )
        ;
        DBMS_OUTPUT.PUT_LINE('Data successfully entered');    

        ELSE    
			RAISE excep2;

            END IF;

    END IF;
EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the Party');
	WHEN excep2 THEN
		dbms_output.put_line ('Party already exists');
    WHEN excep3 THEN
		dbms_output.put_line ('email address incorrect type');
	WHEN OTHERS THEN
		dbms_output.put_line(SQLERRM);


END fe_insertnewparty;