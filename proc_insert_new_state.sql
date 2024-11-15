create or replace PROCEDURE fe_insertnewstate
                    (
                                 sname          IN state.state_name%type                               
                               )
IS
    same_count NUMBER;
    cnt number;

    excep1 EXCEPTION;
	excep2 EXCEPTION;
BEGIN
    SELECT
           COUNT(*)
		INTO
           cnt
		FROM
          state;

	IF ( sname IS NULL  )
	THEN RAISE excep1;

	ELSE 
		SELECT
           COUNT(*)
		INTO
           same_count
		FROM
           state
		WHERE
           state_name like upper(sname);


		IF same_count = 0 THEN
			INSERT         INTO state
            VALUES
               (cnt+1
                    ,upper(sname)
               )
        ;
        DBMS_OUTPUT.PUT_LINE('Data successfully entered');    

        ELSE    
			RAISE excep2;

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