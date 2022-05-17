create or replace procedure log_user(
	p_socket_id varchar,
	p_user_id varchar,
	p_msg inout varchar,
	p_err_buf inout varchar
)
language plpgsql
as $$
begin
	insert into cnvo_user_connections(uc_connection_string,u_id) values(p_socket_id,p_user_id);
	
	p_msg := 'success';
exception
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$