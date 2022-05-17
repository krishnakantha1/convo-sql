create or replace function get_groups_for_user(
	p_uid varchar
)
returns table(
	group_id  cnvo_groups.g_id%type,
	group_name  cnvo_groups.g_name%type,
	about  cnvo_groups.g_grp_about%type
)
language plpgsql
as $$
begin
	return query select cg.g_id,cg.g_name,cg.g_grp_about from cnvo_group_members cgm, cnvo_groups cg 
					where cgm.u_id = p_uid and cgm.g_id = cg.g_id;
end;
$$

select * from get_groups_for_user('krishnakantha#BgFccgFjegjcH');