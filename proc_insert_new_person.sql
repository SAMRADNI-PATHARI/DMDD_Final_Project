create or replace PROCEDURE fe_insertnewperson
                               (
                                   fname        IN people.first_name%type
                                 , lname          IN people.last_name%type
                                 , age                IN people.age%type
                                 , date_of_birth                varchar2
                                 , adr            IN people.address%type
                                 , phone     IN people.contact_number%type
                                 , e_address              IN people.email%type
                                 ,c_record     IN people.criminal_record% type
                                 ,cons_id     IN people.constituency_id%type
                                 ,par_name         IN people.parent_name%type
                                 ,gen              IN people.gender%type
                               )
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
    SELECT
           COUNT(*)
		INTO
           cnt
		FROM
           people;
	IF (fname IS NULL OR lname IS NULL OR  age IS NULL OR date_of_birth IS NULL OR adr IS NULL OR phone IS NULL or e_address IS NULL or c_record IS NULL or cons_id IS NULL OR par_name IS NULL OR gen IS NULL )
	THEN RAISE excep1;

	ELSIF e_address NOT LIKE '%@%.%'
	THEN RAISE excep2;

	ELSIF IS_DATE_VALID(date_of_birth) = false
    THEN

    RAISE excep3;

    ELSIF gen not like 'M' AND gen not like 'F'

    THEN RAISE excep5;
    ELSIF CONSTITUENCY_EXISTS(cons_id)=0
    THEN RAISE excep6;

	ELSE 
		SELECT
           COUNT(*)
		INTO
           same_count
		FROM
           people
		WHERE
           people.first_name like fname
           and 
           people.last_name like lname
           and
           people.gender like gen
           and
           to_char(people.dob)= to_char(to_date(date_of_birth,'DD-MON-YY'))
           and
           people.parent_name like par_name;


		IF same_count = 0 THEN
        cnt:=cnt+1;
			INSERT         INTO people
            VALUES
               (cnt
                    , fname
                    , lname
                    , age
                    , TO_DATE(date_of_birth,'DD-MON-YYYY')
                    , adr
                    , phone
                    , e_address
                    ,c_record
                    , cons_id
                    , par_name
                    , gen
               )
        ;
        DBMS_OUTPUT.PUT_LINE('Data successfully entered');

		ELSE
			RAISE excep4;

		END IF;
    END IF;
EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the Person');
	WHEN excep2 THEN
		dbms_output.put_line ('Please enter correct format for Email ID');
	WHEN excep3 THEN
		dbms_output.put_line ('Please enter correct format for birth date: DD-MON-YY');
	WHEN excep4 THEN
		 DBMS_OUTPUT.PUT_LINE ('Person Already has his UID');
    WHEN excep5 THEN
        DBMS_OUTPUT.PUT_LINE('Please set Gender as Male : M , Female : F');
    WHEN excep6 THEN
        DBMS_OUTPUT.PUT_LINE('Constituency provided does not exist');
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(cnt);
		dbms_output.put_line(SQLERRM);
		dbms_output.put_line('Duplicate Entry. Data Already exists');
END fe_insertnewperson;