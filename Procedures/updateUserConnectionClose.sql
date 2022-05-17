create or replace procedure update_user_connection(
	p_socket_id varchar,
	p_uid varchar,
	p_msg inout varchar,
	p_err_buf inout varchar
)
language plpgsql
as $$
begin
	if char_length(p_socket_id)=0 OR char_length(p_uid)=0 then
		raise exception using 
			errcode='NOPAR';
	end if;
	
	update cnvo_user_connections set uc_connection_end_on = current_timestamp where uc_connection_string = p_socket_id and u_id = p_uid;
	
	p_msg := 'successful';
exception
	when sqlstate 'NOPAR' then
		p_err_buf := 'parameter/s missing';
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$