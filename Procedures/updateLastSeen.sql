create or replace procedure update_user_last_seen_in_group(
	p_uid varchar,
	p_gid varchar,
	
	p_err_buf inout varchar
)
language plpgsql
as $$
begin
	update cnvo_group_members set gm_user_last_seen_in_group = current_timestamp where u_id = p_uid and g_id = p_gid;
exception
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$