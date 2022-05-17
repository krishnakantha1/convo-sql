create or replace procedure add_user_connection_entry(
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
	
	insert into cnvo_user_connections(uc_connection_string,u_id) values(p_socket_id,p_uid);
	
	p_msg := 'successful';
exception
	when foreign_key_violation then
		p_err_buf := 'user doest exist.';
	when sqlstate 'NOPAR' then
		p_err_buf := 'parameter/s missing';
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$