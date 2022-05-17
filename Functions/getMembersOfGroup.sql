create or replace function get_online_user_for_group(
	p_gid varchar
)
returns table(
	r_group_id varchar,
	r_user_id varchar,
	r_user_name varchar,
	r_status boolean
)
language plpgsql
as $$
begin
	return query
		with all_users_of_group as (
				select distinct cgm.g_id, cgm.u_id, cu.u_name
				from cnvo_group_members cgm, cnvo_users cu
				where cgm.g_id = p_gid
					and cgm.u_id = cu.u_id
			),
			all_online_users_of_group as(
				select distinct cgm.g_id, cgm.u_id
				from cnvo_group_members cgm, cnvo_user_connections cuc 
				where cgm.g_id = p_gid 
					and cgm.u_id = cuc.u_id 
					and cuc.uc_connection_end_on is null 
				group by cgm.g_id,cgm.u_id
			)
		select all_users.g_id, 
				all_users.u_id, 
				all_users.u_name,
				case 
					when online_users.u_id is not null then
						TRUE
					else
						FALSE
				end online
		from all_users_of_group all_users left join all_online_users_of_group online_users 
		on all_users.u_id = online_users.u_id;
end;
$$

select * from get_online_user_for_group('GROUP#shadow_clan#BgFcFjjjjcFDB')
