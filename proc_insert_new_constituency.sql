create or replace PROCEDURE fe_insertnewconstituency
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