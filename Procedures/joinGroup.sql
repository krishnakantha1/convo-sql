create or replace procedure user_join_group(
	p_uid varchar,
	p_gid inout varchar,
	p_user_name inout varchar,
	p_group_name inout varchar,
	p_about inout varchar,
	
	p_msg inout varchar,
	p_err_buf inout varchar
)
language plpgsql
as $$
declare
	stack_var varchar;
	user_name varchar;
	group_id varchar;
	group_name varchar;
	group_about varchar;
begin
	if char_length(p_uid)=0 OR char_length(p_gid)=0 then
		raise exception using 
			errcode='NOPAR';
	end if;
	
	--store the username to retrun
	select u_name into user_name from cnvo_users where u_id = p_uid;
	
	--store the group id, group name, group about to return
	select g_id,g_name,g_grp_about into group_id,group_name,group_about from cnvo_groups where g_id = p_gid;
	
	--add user to group
	insert into cnvo_group_members(u_id,g_id) values(p_uid,p_gid);
	
	--add a message saying the user joined
	insert into cnvo_group_message(u_id,g_id,gmsg_message,gmsg_type) values('SYSTEM',p_gid,user_name || ' Joined.','SYS');
	
	p_gid := group_id;
	p_user_name := user_name;
	p_group_name := group_name;
	p_about := group_about;
	
	p_msg := 'successful';
exception
	when foreign_key_violation then
		get stacked diagnostics 
			stack_var := CONSTRAINT_NAME;
		
		if stack_var = 'gm_u_id_fk' then
			p_err_buf := 'user id dosent exist.';
		elseif stack_var = 'gm_g_id_fk' then
			p_err_buf := 'group id dosent exist.';
		end if;
		
	when unique_violation then
		get stacked diagnostics 
			stack_var := CONSTRAINT_NAME;
		
		if stack_var = 'gm_u_g_unique' then
			p_err_buf := 'user already exists in the group.';
		end if;
	when sqlstate 'NOPAR' then
		p_err_buf := 'parameter/s missing';
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$