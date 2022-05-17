create or replace function user_connection_close(
	p_socket_id varchar,
	p_uid varchar
)
returns table(
	r_groups varchar
)
language plpgsql
as $$
declare
	v_msg varchar;
	v_err_buf varchar;
	
	active_connection_count int;
begin
	CALL update_connection_close(p_socket_id,p_uid,v_msg,v_err_buf); 
	
	select count(u_id) into active_connection_count from cnvo_user_connections where u_id = p_uid and uc_connection_end_on is null;

	return query
		select g_id
		from
			cnvo_group_members
		where active_connection_count = 0
			and u_id = p_uid;
	
end;
$$


select * from user_connection_close('kz2TgSP1yTITp3QpAAAJ','krishnakantha#BgFccgFjegjcH')