create or replace function user_connection_open(
	p_socket_id varchar,
	p_uid varchar
)
returns table(
	r_group_id varchar,
	r_user_id varchar,
	r_user_name varchar,
	r_status boolean
)
language plpgsql
as $$
declare
	v_msg varchar;
	v_err_buf varchar;
	
	active_connection_count int;
begin
	CALL log_user(p_socket_id,p_uid,v_msg,v_err_buf);
	
	select count(u_id) into active_connection_count from cnvo_user_connections where u_id = p_uid and uc_connection_end_on is null;
	
	return query
		select g_id,
			cu.u_id,
			cu.u_name,
			true
		from
			cnvo_group_members cgm,
			cnvo_users cu
		where active_connection_count = 1
			and cgm.u_id = p_uid
			and cu.u_id = cgm.u_id;

end;
$$