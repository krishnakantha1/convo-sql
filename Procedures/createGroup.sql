create or replace procedure create_group(
	p_uid varchar,
	p_gid varchar,
	p_gname varchar,
	p_gabout varchar,
	p_msg inout varchar,
	p_err_buf inout varchar
)
language plpgsql
as $$
declare
	stack_var varchar;
	temp_var1 varchar;
	temp_var2 varchar;
	temp_var3 varchar;
begin
	if char_length(p_uid)=0 OR char_length(p_gid)=0 OR char_length(p_gname)=0 then
		raise exception using 
			errcode='NOPAR';
	end if;
	
	insert into cnvo_groups(g_id,g_name,g_grp_about) values(p_gid,upper(p_gname),p_gabout);
	insert into cnvo_group_message(u_id,g_id,gmsg_message,gmsg_type) values('SYSTEM',p_gid,'Group Created','SYS');
	
	call user_join_group(p_uid,p_gid,temp_var1,temp_var2,temp_var3, p_msg,p_err_buf);
	
	
	
	p_msg := 'group created.';
exception
	when unique_violation then
		get stacked diagnostics 
			stack_var := CONSTRAINT_NAME;
		
		if stack_var = 'g_name_unique' then
			p_err_buf := 'group name already exists.';
		end if;
	when sqlstate 'NOPAR' then
		p_err_buf := 'parameter/s missing';
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$