create or replace procedure delete_state(sid in state.state_id%type)
is 
execp1 exception; 
execp2  exception;
begin 
if(sid is null) then raise execp1; 
elsif (state_exists(sid)=0) then raise execp2; 
else
   delete from state where state_id = sid;
end if ; 
exception 
when execp1 then 
   DBMS_OUTPUT.PUT_LINE('Please enter a valid state ID');
when execp2 then 
    DBMS_OUTPUT.PUT_LINE('That State ID doesnt exist. Enter a valid state ID:');
end delete_state;