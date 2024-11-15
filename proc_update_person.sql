create or replace PROCEDURE fe_updateperson
                               (
                                    uid              IN people.u_id%type
                                , fname        IN people.first_name%type
                                 , lname          IN people.last_name%type
                                 , age                IN people.age%type
                                 , date_of_birth                IN people.dob%type
                                 , adr            IN people.address%type
                                 , phone     IN people.contact_number%type
                                 , e_address              IN people.email%type
                                 ,c_record     IN people.criminal_record% type
                                 ,cons_id     IN people.constituency_id%type
                                 ,par_name         IN people.parent_name%type
                                 ,gen              IN people.gender%type
                               )
AS   
    excep1 EXCEPTION;
	excep2 EXCEPTION;
	excep3 EXCEPTION;
	excep4 EXCEPTION;
    excep5 EXCEPTION;
    excep6 EXCEPTION;
BEGIN
	IF (fname IS NULL OR lname IS NULL OR  age IS NULL OR date_of_birth IS NULL OR adr IS NULL OR phone IS NULL or e_address IS NULL or c_record IS NULL or cons_id IS NULL OR par_name IS NULL OR gen IS NULL )
	THEN RAISE excep1;

	ELSIF e_address NOT LIKE '%@%.%'
	THEN RAISE excep2;

	ELSIF (NOT REGEXP_LIKE(date_of_birth, '^[0-9]{2}-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{2}$'))
    THEN

    RAISE excep3;

    ELSIF gen not like 'M' AND gen not like 'F'

    THEN RAISE excep5;
    ELSIF CONSTITUENCY_EXISTS(cons_id)=0
    THEN RAISE excep6;

ELSE

UPDATE PEOPLE SET 
FIRST_NAME= fname,
LAST_NAME= lname,
AGE= age,
DOB= date_of_birth,
ADDRESS= adr,
CONTACT_NUMBER=phone,
EMAIL=e_address,
CRIMINAL_RECORD= c_record,
CONSTITUENCY_ID=cons_id,
PARENT_NAME= par_name,
GENDER= gen
WHERE 
U_ID= uid  ;
        DBMS_OUTPUT.PUT_LINE('Data successfully updated');

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

END fe_updateperson;