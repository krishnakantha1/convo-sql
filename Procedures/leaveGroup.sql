create or replace procedure user_group_leave(
	p_uid varchar,
	p_gid varchar,
	
	r_user_name inout varchar,
	p_msg inout varchar,
	p_err_buf inout varchar
)
language plpgsql
as $$
declare
	user_name varchar;
begin
	--select the user name
	select u_name into user_name from cnvo_users where u_id = p_uid;
	
	--delete entry in the group members table to finalise the leave group process.
	delete from cnvo_group_members where u_id = p_uid and g_id = p_gid;
	
	--record the leave group event
	insert into cnvo_group_message(u_id,g_id,gmsg_message,gmsg_type) values('SYSTEM',p_gid,user_name || ' Left.','SYS');
	
	r_user_name := user_name;
	p_msg := 'success';
exception
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$