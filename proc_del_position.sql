create or replace PROCEDURE fe_deleteposition
                    (
                                 posid          IN position.position_id%type                               
                               )
IS

   
    excep1 EXCEPTION;
	excep2 EXCEPTION;
BEGIN


	IF ( posid IS NULL  )
	THEN RAISE excep1;

    ELSIF POSITION_EXISTS(posid)=0
    THEN RAISE excep2;

	ELSE 

        DELETE FROM POSITION WHERE POSITION_ID =posid;


        DBMS_OUTPUT.PUT_LINE('Data successfully deleted');    





    END IF;
EXCEPTION
	WHEN excep1 THEN
		dbms_output.put_line ('Please enter all fields for the position');
	WHEN excep2 THEN
		dbms_output.put_line ('No position exists with the given position_id');
	WHEN OTHERS THEN
		dbms_output.put_line(SQLERRM);


END fe_deleteposition;