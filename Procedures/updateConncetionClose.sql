create or replace procedure update_connection_close(
	p_socket_id varchar,
	p_user_id varchar,
	p_msg inout varchar,
	p_err_buf inout varchar
)
language plpgsql
as $$
begin

	update cnvo_user_connections set uc_connection_end_on = current_timestamp 
	where uc_connection_string = p_socket_id and u_id = p_user_id and uc_connection_end_on is null;
	
	p_msg := 'success';
exception
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$